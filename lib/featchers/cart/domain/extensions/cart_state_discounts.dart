part of '../../presentation/bloc/cart_state.dart';

typedef ResolvedItemDiscount = ({
  double value,
  bool isPercentage,
  int? discountId,
  bool isAuto,
});

typedef EffectiveInvoiceDiscount = ({
  double value,
  bool isPercentage,
  bool capped,
});

const ResolvedItemDiscount _noItemDiscount = (
  value: 0.0,
  isPercentage: false,
  discountId: null,
  isAuto: false,
);

extension CartStateDiscounts on CartState {
  int get currentPosTypeId => selectedOrderType.apiValue;

  bool get manualDiscountSettingOn =>
      settingsModel?.posRestaurant?.activeDiscount ?? false;

  // ---------------------------------------------------------------------------
  // Dynamic invoice discount
  // ---------------------------------------------------------------------------

  bool get dynamicDiscountIsActive =>
      !isPreviousInvoice &&
      !isPending &&
      mode.allowsDynamicDiscount &&
      activeDiscounts.any((d) => d.posTypeId == currentPosTypeId);

  bool get dynamicInvoiceDiscountIsActive => dynamicDiscountIsActive;

  DynamicDiscountModel? get matchedDynamicDiscount {
    if (!dynamicInvoiceDiscountIsActive) return null;

    if (activeDiscountModel?.posTypeId == currentPosTypeId) {
      return activeDiscountModel;
    }

    return activeDiscounts
        .where((d) => d.posTypeId == currentPosTypeId)
        .firstOrNull;
  }

  EffectiveInvoiceDiscount? get effectiveDynamicInvoiceDiscount {
    if (!dynamicInvoiceDiscountIsActive) return null;

    final d = matchedDynamicDiscount?.discount;
    if (d == null) return null;

    final value = d.discountValue ?? 0.0;
    if (value <= 0) return null;

    final base = _itemsTotalBeforeDiscount;

    if (d.discountNatural == 1) {
      final maxValue = d.maxDiscountValue ?? 0.0;

      if (maxValue > 0 && base * value / 100 > maxValue) {
        return (value: maxValue, isPercentage: false, capped: true);
      }

      return (value: value, isPercentage: true, capped: false);
    }

    final minNet = d.minInvoiceNET ?? 0.0;

    if (minNet > 0 && _netOfVat(base) < minNet) {
      return null;
    }

    return (value: value, isPercentage: false, capped: false);
  }

  // Not based on calculationResult, to avoid a circular dependency.
  double get _itemsTotalBeforeDiscount =>
      items.fold(0.0, (sum, item) => sum + item.totalPriceBeforeDiscount);

  // ---------------------------------------------------------------------------
  // Customer discount
  // ---------------------------------------------------------------------------

  bool get isCustomerDiscountEditable => !dynamicInvoiceDiscountIsActive;

  bool get isCustomerDiscountApplied =>
      mode.allowsCustomerDiscount &&
      isCustomerDiscountEditable &&
      (customerDiscount?.value ?? 0) > 0;

  // ---------------------------------------------------------------------------
  // Dynamic size / item discount
  // ---------------------------------------------------------------------------

  ItemDiscount? dynamicDiscountForSize(ItemSize? size) {
    if (!mode.allowsSizeDiscount || isPreviousInvoice || isPending) {
      return null;
    }

    final discount = size?.discountForPosType(currentPosTypeId);

    if (discount == null || discount.discountValue <= 0) {
      return null;
    }

    return discount;
  }

  bool get hasSizeDiscount =>
      items.any((item) => dynamicDiscountForSize(item.selectedSize) != null);

  // ---------------------------------------------------------------------------
  // Manual discounts
  // ---------------------------------------------------------------------------

  bool get isManualItemDiscountApplied =>
      !hasSizeDiscount && items.any((item) => item.discount > 0);

  bool get isManualInvoiceDiscountApplied =>
      (mode.allowsInvoiceDiscount || isReturn) &&
      !dynamicInvoiceDiscountIsActive &&
      selectedDiscountType == DiscountTypeEnum.direct &&
      (restaurantPosDiscountRequest?.value ?? 0) > 0;

  bool get isInvoiceManualDiscountEnabled =>
      mode.allowsManualDiscountEditing &&
      !dynamicInvoiceDiscountIsActive &&
      !isCustomerDiscountApplied &&
      manualDiscountSettingOn &&
      !isManualItemDiscountApplied;

  bool get isItemManualDiscountEnabled =>
      mode.allowsManualDiscountEditing &&
      !dynamicInvoiceDiscountIsActive &&
      !isCustomerDiscountApplied &&
      !hasSizeDiscount &&
      manualDiscountSettingOn &&
      !isManualInvoiceDiscountApplied;

  // ---------------------------------------------------------------------------
  // Which invoice discount source wins
  // ---------------------------------------------------------------------------

  DiscountSource get activeDiscountSource {
    if (dynamicInvoiceDiscountIsActive) {
      return DiscountSource.dynamic;
    }

    if (isCustomerDiscountApplied) {
      return DiscountSource.customer;
    }

    if (isManualInvoiceDiscountApplied) {
      return DiscountSource.manualInvoice;
    }

    if (hasSizeDiscount) {
      return DiscountSource.size;
    }

    if (isManualItemDiscountApplied) {
      return DiscountSource.manualItem;
    }

    return DiscountSource.none;
  }

  // ---------------------------------------------------------------------------
  // Per-item discount resolution
  // ---------------------------------------------------------------------------

  ResolvedItemDiscount _resolveItemDiscount(OrderItem item) {
    // Dynamic size discount has its own priority.
    // It is independent of an invoice-level dynamic discount.
    final sizeDiscount = _sizeDiscountFor(item);

    if (sizeDiscount != null) {
      return sizeDiscount;
    }

    // Customer discount replaces item-level discounts.
    if (isCustomerDiscountApplied) {
      return _noItemDiscount;
    }

    // Manual invoice discount is calculated at invoice level.
    // Do not apply manual item discounts alongside it.
    if (isManualInvoiceDiscountApplied) {
      return _noItemDiscount;
    }

    // Manual item discount.
    if (item.discount > 0 && isItemManualDiscountAllowedFor(item)) {
      return (
        value: mode.itemDiscountValue(item),
        isPercentage: item.isPercentageDiscount,
        discountId: null,
        isAuto: false,
      );
    }

    return _noItemDiscount;
  }

  /// Allows dynamic size discounts even when a dynamic invoice discount
  /// is active, but keeps manual item discounts disabled in that situation.
  bool isItemManualDiscountAllowedFor(OrderItem item) {
    if (dynamicInvoiceDiscountIsActive ||
        isCustomerDiscountApplied ||
        isManualInvoiceDiscountApplied ||
        !manualDiscountSettingOn ||
        !mode.allowsManualDiscountEditing) {
      return false;
    }

    return dynamicDiscountForSize(item.selectedSize) == null;
  }

  // ---------------------------------------------------------------------------
  // Resolve dynamic size discount
  // ---------------------------------------------------------------------------

  ResolvedItemDiscount? _sizeDiscountFor(OrderItem item) {
    final discount = dynamicDiscountForSize(item.selectedSize);

    if (discount == null) return null;

    final lineTotal = item.totalPriceBeforeDiscount;

    // Check minimum invoice net for the individual item.
    if (discount.minInvoiceNet > 0 &&
        _netOfVat(lineTotal) < discount.minInvoiceNet) {
      return null;
    }

    final isPercentage = discount.discountNatural == 1;
    final value = discount.discountValue;
    final discountId = int.tryParse(discount.id.toString());

    // Apply maximum discount cap.
    if (isPercentage &&
        discount.maxDiscountValue > 0 &&
        lineTotal * value / 100 > discount.maxDiscountValue) {
      return (
        value: discount.maxDiscountValue,
        isPercentage: false,
        discountId: discountId,
        isAuto: true,
      );
    }

    return (
      value: value,
      isPercentage: isPercentage,
      discountId: discountId,
      isAuto: true,
    );
  }
}

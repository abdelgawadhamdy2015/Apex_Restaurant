part of '../../presentation/bloc/cart_state.dart';

typedef ResolvedItemDiscount = ({
  double value,
  bool isPercentage,
  int? discountId,
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
);

extension CartStateDiscounts on CartState {
  int get currentPosTypeId => selectedOrderType.apiValue;

  bool get _manualDiscountSettingOn =>
      settingsModel?.posRestaurant?.activeDiscount ?? false;

  // ---------------------------------------------------------------------------
  // Dynamic (invoice level)
  // ---------------------------------------------------------------------------

  bool get dynamicDiscountIsActive =>
      mode.allowsDynamicDiscount &&
      activeDiscounts.any((d) => d.posTypeId == currentPosTypeId);

  DynamicDiscountModel? get matchedDynamicDiscount {
    if (!dynamicDiscountIsActive) return null;

    if (activeDiscountModel?.posTypeId == currentPosTypeId) {
      return activeDiscountModel;
    }
    return activeDiscounts
        .where((d) => d.posTypeId == currentPosTypeId)
        .firstOrNull;
  }

  /// Dynamic invoice discount after applying its rules:
  /// - fixed (discountNatural == 2): ignored when total < `minInvoiceNet`.
  /// - percentage (discountNatural == 1): amount is capped at
  ///   `maxDiscountValue` (when > 0) and then becomes a fixed amount.
  /// Returns null when no discount should be applied.
  EffectiveInvoiceDiscount? get effectiveDynamicInvoiceDiscount {
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
    if (minNet > 0 && base < minNet) return null;
    return (value: value, isPercentage: false, capped: false);
  }

  // Not based on calculationResult, to avoid a circular dependency.
  double get _itemsTotalBeforeDiscount =>
      items.fold(0.0, (sum, i) => sum + i.totalPriceBeforeDiscount);

  // ---------------------------------------------------------------------------
  // Customer
  // ---------------------------------------------------------------------------

  bool get isCustomerDiscountEditable => !dynamicDiscountIsActive;

  bool get isCustomerDiscountApplied =>
      mode.allowsCustomerDiscount &&
      isCustomerDiscountEditable &&
      (customerDiscount?.value ?? 0) > 0;

  // ---------------------------------------------------------------------------
  // Size (item level)
  // ---------------------------------------------------------------------------

  ItemDiscount? dynamicDiscountForSize(ItemSize? size) {
    if (!mode.allowsSizeDiscount) return null;
    final discount = size?.discountForPosType(currentPosTypeId);
    if (discount == null || discount.discountValue <= 0) return null;
    return discount;
  }

  bool get hasSizeDiscount =>
      items.any((i) => dynamicDiscountForSize(i.selectedSize) != null);

  // ---------------------------------------------------------------------------
  // Manual
  // ---------------------------------------------------------------------------

  bool get isManualItemDiscountApplied =>
      !hasSizeDiscount && items.any((i) => i.discount > 0);

  bool get isManualInvoiceDiscountApplied =>
      mode.allowsInvoiceDiscount &&
      selectedDiscountType == DiscountTypeEnum.direct &&
      (restaurantPosDiscountRequest?.value ?? 0) > 0;

  bool get isInvoiceManualDiscountEnabled =>
      mode.allowsManualDiscountEditing &&
      !dynamicDiscountIsActive &&
      !isCustomerDiscountApplied &&
      _manualDiscountSettingOn &&
      !isManualItemDiscountApplied;

  bool get isItemManualDiscountEnabled =>
      mode.allowsManualDiscountEditing &&
      !dynamicDiscountIsActive &&
      !isCustomerDiscountApplied &&
      !hasSizeDiscount &&
      _manualDiscountSettingOn &&
      !isManualInvoiceDiscountApplied;

  // ---------------------------------------------------------------------------
  // Which source wins
  // ---------------------------------------------------------------------------

  DiscountSource get activeDiscountSource {
    if (dynamicDiscountIsActive) return DiscountSource.dynamic;
    if (isCustomerDiscountApplied) return DiscountSource.customer;
    if (hasSizeDiscount) return DiscountSource.size;
    if (isManualInvoiceDiscountApplied) return DiscountSource.manualInvoice;
    if (isManualItemDiscountApplied) return DiscountSource.manualItem;
    return DiscountSource.none;
  }

  // ---------------------------------------------------------------------------
  // Per-item discount
  // ---------------------------------------------------------------------------

  ResolvedItemDiscount _resolveItemDiscount(OrderItem item) {
    // An invoice-level discount replaces any item-level one.
    if (dynamicDiscountIsActive || isCustomerDiscountApplied) {
      return _noItemDiscount;
    }

    final sizeDiscount = _sizeDiscountFor(item);
    if (sizeDiscount != null) return sizeDiscount;

    if (isManualInvoiceDiscountApplied) return _noItemDiscount;

    if (item.discount > 0) {
      return (
        value: mode.itemDiscountValue(item),
        isPercentage: item.isPercentageDiscount,
        discountId: null,
      );
    }
    return _noItemDiscount;
  }

  ResolvedItemDiscount? _sizeDiscountFor(OrderItem item) {
    final discount = dynamicDiscountForSize(item.selectedSize);
    if (discount == null) return null;

    final lineTotal = item.totalPriceBeforeDiscount;
    if (discount.minInvoiceNet > 0 && lineTotal < discount.minInvoiceNet) {
      return null;
    }

    final isPercentage = discount.discountNatural == 1;
    final value = discount.discountValue;
    final discountId = int.tryParse(discount.id.toString());

    if (isPercentage &&
        discount.maxDiscountValue > 0 &&
        lineTotal * value / 100 > discount.maxDiscountValue) {
      return (
        value: discount.maxDiscountValue,
        isPercentage: false,
        discountId: discountId,
      );
    }
    return (value: value, isPercentage: isPercentage, discountId: discountId);
  }
}

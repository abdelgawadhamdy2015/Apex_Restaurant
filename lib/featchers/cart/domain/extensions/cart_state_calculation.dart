part of '../../presentation/bloc/cart_state.dart';

class _TxIdGenerator {
  int _next = 100000;
  String next() => (_next++).toString();
}

DiscountNatural _naturalOf(num? type) =>
    type == 1 ? DiscountNatural.percentage : DiscountNatural.fixedAmount;

extension CartStateCalculation on CartState {
  // ---------------------------------------------------------------------------
  // Public totals
  // ---------------------------------------------------------------------------

  double get subtotal => calculationResult?.totalOfItems ?? 0.0;
  double get netSubtotal => calculationResult?.totalWithoutVAT ?? 0.0;
  double get vatAmount => calculationResult?.totalVAT ?? 0.0;
  double get tobaccoTaxAmount => calculationResult?.totalTobaccoTax ?? 0.0;
  double get dineInCost => calculationResult?.dineInCost ?? 0.0;
  double get grandTotal => calculationResult?.netTotal ?? 0.0;

  double get totalDiscountAmount =>
      mode.totalDiscount(calculationResult, selectedDiscountType);

  // ---------------------------------------------------------------------------
  // Calculator
  // ---------------------------------------------------------------------------

  InvoiceCalculationResult? get calculationResult {
    if (items.isEmpty) return null;

    final invoiceDiscount = _invoiceLevelDiscount;

    final input = InvoiceCalculationInput(
      discountOnTotal: invoiceDiscount.value,
      discountType: invoiceDiscount.type,
      deliveryCost: isDeliveryOrder
          ? settingsModel?.posRestaurant?.deliveryCost ?? 0.0
          : 0.0,
      dineInRatio: selectedOrderType == CartOrderType.DINE_IN
          ? selectedTable?.serviceRatio ?? 0.0
          : 0.0,
      applyVAT: settingsModel?.vat?.vatActive ?? false,
      priceIncludesVAT: mode.priceIncludesVat(this),
      items: _mapItemsToCalculationInputs(),
      voucher: _voucherInput,
      dynamicDiscount: matchedDynamicDiscount?.discount
          ?.toDynamicDiscountInput(),
    );

    const calculator = InvoiceCalculator(
      noteItemTypeId: 99,
      offerItemTypeId: 100,
    );
    return calculator.calculate(input).data;
  }

  /// Invoice-level discount sent to the calculator, based on the winning source.
  ({double value, DiscountNatural type}) get _invoiceLevelDiscount {
    switch (activeDiscountSource) {
      case DiscountSource.dynamic:
        final effective = effectiveDynamicInvoiceDiscount;
        return (
          value: effective?.value ?? 0.0,
          type: (effective?.isPercentage ?? false)
              ? DiscountNatural.percentage
              : DiscountNatural.fixedAmount,
        );
      case DiscountSource.customer:
        return (
          value: customerDiscount?.value ?? 0.0,
          type: _naturalOf(customerDiscount?.type),
        );
      case DiscountSource.manualInvoice:
        return (
          value: restaurantPosDiscountRequest?.value ?? 0.0,
          type: _naturalOf(restaurantPosDiscountRequest?.type),
        );
      case DiscountSource.size:
      case DiscountSource.manualItem:
      case DiscountSource.none:
        return (value: 0.0, type: DiscountNatural.percentage);
    }
  }

  VoucherInput? get _voucherInput {
    final voucher = voucherData;
    if (!mode.allowsVoucher ||
        selectedDiscountType != DiscountTypeEnum.coupon ||
        voucher == null) {
      return null;
    }
    return VoucherInput(
      code: voucher.voucherCode!,
      discountType: _naturalOf(voucher.discountNatural),
      value: voucher.discountValue ?? 0,
      minimumCharge: voucher.minimumCharge ?? 0,
      maximumDiscount: voucher.maximumDiscountValue ?? 0,
    );
  }

  // ---------------------------------------------------------------------------
  // Items -> calculator inputs
  // ---------------------------------------------------------------------------

  /// Existing transaction id if the item was restored, a generated one otherwise.
  String _parentTxIdFor(OrderItem item, int index) =>
      item.transactionId.isNotEmpty
      ? item.transactionId
      : 'item_${index}_${DateTime.now().millisecondsSinceEpoch}';

  String _addonTxId(AdditiveModel addon, _TxIdGenerator ids) {
    final id = addon.transactionId;
    return (id != null && id.isNotEmpty) ? id : ids.next();
  }

  String _addonParentTxId(AdditiveModel addon, String fallback) {
    final id = addon.parentTransactionId;
    return (id != null && id.isNotEmpty) ? id : fallback;
  }

  double _unitPriceOf(OrderItem item) =>
      item.selectedSize?.price ??
      (item.menuItem.sizes.isNotEmpty
          ? item.menuItem.sizes.first.price
          : item.menuItem.defaultPrice) ??
      0.0;

  List<InvoiceItemInput> _mapItemsToCalculationInputs() {
    final ids = _TxIdGenerator();
    final vatRatio = (settingsModel?.vat?.vatActive ?? false)
        ? (settingsModel?.vat?.vatDefaultValue ?? 0).toDouble()
        : 0.0;

    final inputs = <InvoiceItemInput>[];
    for (var i = 0; i < items.length; i++) {
      final item = items[i];
      final parentTxId = _parentTxIdFor(item, i);
      final discount = _resolveItemDiscount(item);

      inputs.add(
        InvoiceItemInput(
          transactionId: parentTxId,
          parentTransactionId: null,
          itemId: item.menuItem.itemId,
          sizeId: item.selectedSize?.sizeId,
          quantity: mode.quantityOf(item),
          unitPrice: _unitPriceOf(item),
          vatRatio: vatRatio,
          discount: discount.value,
          discountType: discount.isPercentage
              ? DiscountNatural.percentage
              : DiscountNatural.fixedAmount,
          itemTypeId: item.menuItem.itemTypeId ?? 0,
          isTobacco: item.menuItem.isTobaccoTax ?? false,
        ),
      );

      // One line per addon type, with its count.
      final grouped = <String, ({AdditiveModel addon, int count})>{};
      for (final addon in item.addons) {
        final existing = grouped[addon.id];
        grouped[addon.id] = (
          addon: existing?.addon ?? addon,
          count: (existing?.count ?? 0) + 1,
        );
      }

      for (final entry in grouped.values) {
        final addon = entry.addon;
        inputs.add(
          InvoiceItemInput(
            transactionId: _addonTxId(addon, ids),
            parentTransactionId: _addonParentTxId(addon, parentTxId),
            itemId: item.menuItem.itemId,
            additiveId: int.tryParse(addon.id),
            quantity: entry.count.toDouble(),
            unitPrice: addon.price,
            vatRatio: vatRatio,
            itemTypeId: item.menuItem.itemTypeId ?? 0,
          ),
        );
      }
    }
    return inputs;
  }
}

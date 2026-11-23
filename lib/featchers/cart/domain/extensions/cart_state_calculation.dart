part of '../../presentation/bloc/cart_state.dart';

class _TxIdGenerator {
  int _next = 100000;
  String next() => (_next++).toString();
}

extension CartStateCalculation on CartState {
  // ---- Totals (all come from the calculation server) ----
  double get subtotal =>
      (calculationResult?.totalOfItems ?? 0.0) -
      (calculationResult?.totalItemDiscount ?? 0.0);
  double get netSubtotal => calculationResult?.totalWithoutVAT ?? 0.0;
  double get vatAmount => calculationResult?.totalVAT ?? 0.0;
  double get tobaccoTaxAmount => calculationResult?.totalTobbacoTAX ?? 0.0;
  double get dineInCost => calculationResult?.dineInCost ?? 0.0;
  double get deliveryCost => calculationResult?.deliveryCost ?? 0.0;
  double get grandTotal => calculationResult?.net ?? 0.0;
  double get totalDiscountAmount => calculationResult?.totalDiscount ?? 0.0;
  double get voucherDiscountAmount => calculationResult?.voucherDiscount ?? 0.0;
  double get invoiceDiscountAmount => calculationResult?.invoiceDiscount ?? 0.0;
  bool get isCalculating => status == CartStatus.itemsUpdateing;

  /// The server's result row for this cart line (matched by transactionID).
  CalculationItemResult? _calcItemFor(OrderItem item, int index) {
    final id = _parentTxIdFor(item, index);
    return calculationResult?.items
        .where((e) => e.transactionID == id)
        .firstOrNull;
  }

  /// Main item gross for the quantity that is actually calculated.
  double lineMainGrossFor(OrderItem item) =>
      _unitPriceOf(item) * mode.quantityOf(item);

  /// Main item + addons, before any discount.
  double lineGrossFor(OrderItem item) =>
      lineMainGrossFor(item) + item.addonsTotalPrice;

  /// Item-level discount: server value first, local value as a fallback
  /// (e.g. while the calculation is still running).
  double lineDiscountFor(OrderItem item, int index) {
    final fromServer = _calcItemFor(item, index)?.itemDiscountValue;
    final value = fromServer ?? _itemDiscountAmount(item);
    return value.clamp(0.0, lineMainGrossFor(item)).toDouble();
  }

  /// What the tile shows: gross - item discount (addons are never discounted).
  /// The invoice-level discount and VAT are shown in the summary only.
  double lineTotalFor(OrderItem item, int index) =>
      lineGrossFor(item) - lineDiscountFor(item, index);
  double get _vatRatio => (settingsModel?.vat?.vatActive ?? false)
      ? (settingsModel?.vat?.vatDefaultValue ?? 0).toDouble()
      : 0.0;

  // ---- Invoice-level discount to push to the server ----
  ({double value, int natural, bool isAuto, double min, double max})
  get invoiceDiscountForCalculation {
    const none = (
      value: 0.0,
      natural: DiscountNatural.ratio,
      isAuto: false,
      min: 0.0,
      max: 0.0,
    );
    // Return invoices get their discount per item (see _itemDiscountAmount).
    if (isReturn) return none;

    int naturalOf(num? t) =>
        t == 1 ? DiscountNatural.ratio : DiscountNatural.value;

    switch (activeDiscountSource) {
      case DiscountSource.dynamic:
        final d = matchedDynamicDiscount?.discount;
        if (d == null) return none;
        return (
          value: d.discountValue ?? 0.0,
          natural: naturalOf(d.discountNatural),
          isAuto: true,
          min: d.minInvoiceNET ?? 0.0,
          max: d.maxDiscountValue ?? 0.0,
        );
      case DiscountSource.customer:
        final c = customerDiscount;
        return (
          value: c?.value ?? 0.0,
          natural: naturalOf(c?.type),
          isAuto: false,
          min: 0.0,
          max: 0.0,
        );
      case DiscountSource.manualInvoice:
        final m = restaurantPosDiscountRequest;
        return (
          value: m?.value ?? 0.0,
          natural: naturalOf(m?.type),
          isAuto: false,
          min: 0.0,
          max: 0.0,
        );
      case DiscountSource.size:
      case DiscountSource.manualItem:
      case DiscountSource.none:
        return none;
    }
  }

  // ---- Item helpers (also used by cart_state_request.dart) ----
  String _parentTxIdFor(OrderItem item, int index) =>
      item.transactionId.isNotEmpty ? item.transactionId : 'item_$index';

  String _addonTxId(AdditiveModel addon, String parentTx) {
    final id = addon.transactionId;
    return (id != null && id.isNotEmpty) ? id : '${parentTx}_a${addon.id}';
  }

  double _netOfVat(double amount) {
    if (!mode.priceIncludesVat(this) || _vatRatio <= 0) return amount;
    return amount / (1 + _vatRatio / 100);
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

  /// Fixed discount amount for the quantity that is actually calculated.
  double _itemDiscountAmount(OrderItem item) {
    final unit = _unitPriceOf(item);
    final qty = mode.quantityOf(item);
    final gross = unit * qty;

    if (isReturn) {
      final sold = item.quantity.toDouble();
      final own = item.isPercentageDiscount
          ? gross * item.discount / 100
          : mode.itemDiscountValue(item);
      final share = sold <= 0
          ? 0.0
          : (returnInvoiceDiscountShares[item.transactionId] ?? 0.0) /
                sold *
                qty;
      return (own + share).clamp(0.0, gross).toDouble();
    }

    final d = _resolveItemDiscount(item);
    if (d.value <= 0) return 0.0;
    final amount = d.isPercentage ? gross * d.value / 100 : d.value;
    return amount.clamp(0.0, gross).toDouble();
  }

  /// Main line + one line per addon type. Used for every add/rebuild.
  List<AddCalculationItemRequest> calculationRequestsFor(
    OrderItem item,
    int index,
    String cartId,
  ) {
    final parentTx = _parentTxIdFor(item, index);
    final dyn = dynamicDiscountIsActive
        ? matchedDynamicDiscount?.discount
        : null;

    final requests = <AddCalculationItemRequest>[
      AddCalculationItemRequest(
        cartId: cartId,
        itemId: item.menuItem.itemId,
        quantity: mode.quantityOf(item),
        unitPrice: _unitPriceOf(item),
        vatRatio: _vatRatio,
        itemDiscount: _itemDiscountAmount(item),
        discountNatural: DiscountNatural.value,
        minimumCharge: dyn?.minInvoiceNET ?? 0,
        maximumDiscount: dyn?.maxDiscountValue ?? 0,
        isAutoDiscount: dyn != null,
        itemTypeId: item.menuItem.itemTypeId ?? 0,
        isTobacco: item.menuItem.isTobaccoTax ?? false,
        transactionId: parentTx,
      ),
    ];

    final grouped = <String, ({AdditiveModel addon, int count})>{};
    for (final addon in item.addons) {
      final e = grouped[addon.id];
      grouped[addon.id] = (
        addon: e?.addon ?? addon,
        count: (e?.count ?? 0) + 1,
      );
    }

    for (final g in grouped.values) {
      final addon = g.addon;
      final txId = _addonTxId(addon, parentTx);
      requests.add(
        AddCalculationItemRequest(
          cartId: cartId,
          itemId: int.tryParse(addon.id) ?? item.menuItem.itemId,
          quantity: g.count.toDouble(),
          unitPrice: addon.price,
          vatRatio: _vatRatio,
          itemDiscount: 0,
          discountNatural: DiscountNatural.value,
          minimumCharge: 0,
          maximumDiscount: 0,
          isAutoDiscount: false,
          itemTypeId: CalculationItemTypes.additives,
          isTobacco: false,
          transactionId: txId,
          parentTransactionId: _addonParentTxId(addon, parentTx),
        ),
      );
    }
    return requests;
  }

  ItemLinePreview linePreviewFrom(OrderItem item, CalculationResult result) {
    final id = _parentTxIdFor(item, 0);
    final main = result.items.where((e) => e.transactionID == id).firstOrNull;
    final mainGross = lineMainGrossFor(item);
    final discount = (main?.itemDiscountValue ?? _itemDiscountAmount(item))
        .clamp(0.0, mainGross)
        .toDouble();
    return ItemLinePreview(
      gross: lineGrossFor(item),
      discount: discount,
      vat: result.totalVAT,
      vatIncluded: mode.priceIncludesVat(this),
    );
  }
}

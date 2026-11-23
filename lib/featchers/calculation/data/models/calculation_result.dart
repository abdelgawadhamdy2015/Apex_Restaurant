class CalculationResult {
  final List<CalculationItemResult> items;
  final double totalOfItems;
  final double voucherDiscount;
  final double invoiceDiscount;
  final double totalItemDiscount;
  final double totalDiscount;
  final double totalVAT;
  final double totalTobbacoTAX;
  final double deliveryCost;
  final double dineInCost;
  final double totalInvoice;
  final double totalWithoutVAT;
  final double totalWithVAT;
  final double net;

  const CalculationResult({
    this.items = const [],
    this.totalOfItems = 0,
    this.voucherDiscount = 0,
    this.invoiceDiscount = 0,
    this.totalItemDiscount = 0,
    this.totalDiscount = 0,
    this.totalVAT = 0,
    this.totalTobbacoTAX = 0,
    this.deliveryCost = 0,
    this.dineInCost = 0,
    this.totalInvoice = 0,
    this.totalWithoutVAT = 0,
    this.totalWithVAT = 0,
    this.net = 0,
  });

  factory CalculationResult.fromJson(Map<String, dynamic> json) {
    double number(String key) => (json[key] as num?)?.toDouble() ?? 0.0;

    return CalculationResult(
      items: (json['items'] as List<dynamic>? ?? [])
          .map(
            (item) => CalculationItemResult.fromJson(
              Map<String, dynamic>.from(item as Map),
            ),
          )
          .toList(),
      totalOfItems: number('totalOfItems'),
      voucherDiscount: number('voucherDiscount'),
      invoiceDiscount: number('invoiceDiscount'),
      totalItemDiscount: number('totalItemDiscount'),
      totalDiscount: number('totalDiscount'),
      totalVAT: number('totalVAT'),
      totalTobbacoTAX: number('totalTobbacoTAX'),
      deliveryCost: number('deliveryCost'),
      dineInCost: number('dineInCost'),
      totalInvoice: number('totalInvoice'),
      totalWithoutVAT: number('totalWithoutVAT'),
      totalWithVAT: number('totalWithVAT'),
      net: number('net'),
    );
  }

  CalculationResult copyWith({List<CalculationItemResult>? items}) {
    return CalculationResult(
      items: items ?? this.items,
      totalOfItems: totalOfItems,
      voucherDiscount: voucherDiscount,
      invoiceDiscount: invoiceDiscount,
      totalItemDiscount: totalItemDiscount,
      totalDiscount: totalDiscount,
      totalVAT: totalVAT,
      totalTobbacoTAX: totalTobbacoTAX,
      deliveryCost: deliveryCost,
      dineInCost: dineInCost,
      totalInvoice: totalInvoice,
      totalWithoutVAT: totalWithoutVAT,
      totalWithVAT: totalWithVAT,
      net: net,
    );
  }

  /// The server now returns ONLY the items that changed.
  ///
  /// - Totals (net, VAT, discounts ...) are taken from `this` (newest response,
  ///   they are always for the whole cart).
  /// - Items = [previous] items, overridden by the items in `this`
  ///   (matched by `transactionID`).
  CalculationResult mergeChangedItems(CalculationResult? previous) {
    if (previous == null) return this;

    final byId = <String, CalculationItemResult>{
      for (final i in previous.items) i.transactionID: i,
    };
    for (final i in items) {
      byId[i.transactionID] = i;
    }
    return copyWith(items: byId.values.toList());
  }
}

class CalculationItemResult {
  final String transactionID;
  final double itemDiscountValue;
  final double vatValue;
  final double spDiscount;
  final double tobaccoTaxValue;

  const CalculationItemResult({
    required this.transactionID,
    this.itemDiscountValue = 0,
    this.vatValue = 0,
    this.spDiscount = 0,
    this.tobaccoTaxValue = 0,
  });

  factory CalculationItemResult.fromJson(Map<String, dynamic> json) {
    double number(String key) => (json[key] as num?)?.toDouble() ?? 0.0;

    return CalculationItemResult(
      transactionID: json['transactionID']?.toString() ?? '',
      itemDiscountValue: number('itemDiscountValue'),
      vatValue: number('vatValue'),
      spDiscount: number('spDiscount'),
      tobaccoTaxValue: number('tobaccoTaxValue'),
    );
  }
}

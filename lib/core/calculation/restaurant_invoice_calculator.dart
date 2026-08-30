/// طريقة تفسير قيمة الخصم
enum DiscountNatural { percentage, fixedAmount }

typedef ItemTypeId = int;

// =====================================================================
// نماذج الإدخال
// =====================================================================

class InvoiceCalculationInput {
  final double discountOnTotal;
  final DiscountNatural discountType;
  final double customerDiscountRatio;
  final double deliveryCost;
  final double dineInRatio;
  final bool priceIncludesVAT;
  final bool applyVAT;
  final List<InvoiceItemInput> items;
  final VoucherInput? voucher;
  final DynamicDiscountInput? dynamicDiscount;

  const InvoiceCalculationInput({
    this.discountOnTotal = 0.0,
    this.discountType = DiscountNatural.percentage,
    this.customerDiscountRatio = 0.0,
    this.deliveryCost = 0.0,
    this.dineInRatio = 0.0,
    this.priceIncludesVAT = false,
    this.applyVAT = false,
    this.items = const [],
    this.voucher,
    this.dynamicDiscount,
  });
}

class InvoiceItemInput {
  final int itemId;
  final int? additiveId;
  final int? sizeId;
  final double quantity;
  final double unitPrice;
  final double vatRatio;
  final double discount;
  final DiscountNatural discountType;
  final ItemTypeId itemTypeId;
  final bool isTobacco;
  final String transactionId;
  final String? parentTransactionId;

  const InvoiceItemInput({
    required this.itemId,
    this.additiveId,
    this.sizeId,
    required this.quantity,
    required this.unitPrice,
    this.vatRatio = 0.0,
    this.discount = 0.0,
    this.discountType = DiscountNatural.percentage,
    required this.itemTypeId,
    this.isTobacco = false,
    required this.transactionId,
    this.parentTransactionId,
  });

  double get grossValue => quantity * unitPrice;
}

class VoucherInput {
  final String code;
  final DiscountNatural discountType;
  final double value;
  final double minimumCharge;
  final double maximumDiscount;

  const VoucherInput({
    required this.code,
    required this.discountType,
    required this.value,
    this.minimumCharge = 0.0,
    this.maximumDiscount = 0.0,
  });
}

/// خصم ديناميكي (مبني على DiscountModel القادم من السيرفر)
class DynamicDiscountInput {
  /// معرّف الخصم (اختياري، للعرض فقط)
  final String? id;

  /// نوع الخصم: نسبة أو قيمة ثابتة
  final DiscountNatural discountType;

  /// قيمة الخصم (نسبة أو مبلغ حسب discountType)
  final double discountValue;

  /// أقل قيمة صافي للفاتورة عشان الخصم يتفعّل (null = بدون حد أدنى)
  final double? minInvoiceNET;

  /// أعلى قيمة يقدر يوصلها الخصم (null = بدون حد أقصى)
  final double? maxDiscountValue;

  const DynamicDiscountInput({
    this.id,
    required this.discountType,
    required this.discountValue,
    this.minInvoiceNET,
    this.maxDiscountValue,
  });

  /// تحويل من موديل الـ API (DiscountModel) لموديل الحساب
  /// ملاحظة: 1 = نسبة، غير كده = قيمة ثابت)
  factory DynamicDiscountInput.fromDiscountType({
    required String? id,
    required int? discountType,
    required double? discountValue,
    required double? minInvoiceNET,
    required double? maxDiscountValue,
  }) {
    return DynamicDiscountInput(
      id: id,
      discountType: discountType == 1
          ? DiscountNatural.percentage
          : DiscountNatural.fixedAmount,
      discountValue: discountValue ?? 0.0,
      minInvoiceNET: minInvoiceNET,
      maxDiscountValue: maxDiscountValue,
    );
  }
}

// =====================================================================
// نماذج الإخراج
// =====================================================================

class InvoiceItemResult {
  final InvoiceItemInput input;
  final double itemDiscountValue;
  final double allocatedInvoiceDiscountValue;
  final double vatValue;
  final double tobaccoTaxValue;

  const InvoiceItemResult({
    required this.input,
    required this.itemDiscountValue,
    required this.allocatedInvoiceDiscountValue,
    required this.vatValue,
    required this.tobaccoTaxValue,
  });

  double get netBeforeTax {
    final net =
        input.grossValue - itemDiscountValue - allocatedInvoiceDiscountValue;
    return net < 0.0 ? 0.0 : net;
  }

  double get allocatedDiscountPercentOfGross {
    final gross = input.grossValue;
    if (gross == 0.0) return 0;
    return (allocatedInvoiceDiscountValue / gross * 100.toDouble()).toDouble();
  }
}

class InvoiceCalculationResult {
  final bool priceIncludesVAT;
  final List<InvoiceItemResult> items;
  final double totalOfItems;
  final double totalItemDiscount;
  final double voucherDiscount;
  final double invoiceDiscount;
  final double dynamicDiscount;
  final double totalDiscount;
  final double totalVAT;
  final double totalTobaccoTax;
  final double deliveryCost;
  final double dineInCost;

  const InvoiceCalculationResult({
    required this.priceIncludesVAT,
    required this.items,
    required this.totalOfItems,
    required this.totalItemDiscount,
    required this.voucherDiscount,
    required this.invoiceDiscount,
    this.dynamicDiscount = 0.0,
    required this.totalDiscount,
    required this.totalVAT,
    required this.totalTobaccoTax,
    required this.deliveryCost,
    required this.dineInCost,
  });

  double get totalWithoutVAT =>
      totalOfItems - totalDiscount - (priceIncludesVAT ? totalVAT : 0.0);

  double get totalWithVAT =>
      totalOfItems -
      totalDiscount +
      totalTobaccoTax +
      (priceIncludesVAT ? 0.0 : totalVAT);

  double get netTotal =>
      totalOfItems -
      totalDiscount +
      totalTobaccoTax +
      dineInCost +
      deliveryCost +
      (priceIncludesVAT ? 0.0 : totalVAT);
}

class InvoiceCalculationError {
  final String messageAr;
  final String messageEn;

  const InvoiceCalculationError({
    required this.messageAr,
    required this.messageEn,
  });

  @override
  String toString() => messageEn;
}

class InvoiceCalculationResponse {
  final InvoiceCalculationResult? data;
  final InvoiceCalculationError? error;

  const InvoiceCalculationResponse._({this.data, this.error});

  factory InvoiceCalculationResponse.success(InvoiceCalculationResult data) =>
      InvoiceCalculationResponse._(data: data);

  factory InvoiceCalculationResponse.failure(InvoiceCalculationError error) =>
      InvoiceCalculationResponse._(error: error);

  bool get isSuccess => data != null;
  bool get isFailure => !isSuccess;
}

/// مصدر الخصم اللي كسب المقارنة (داخلي فقط)
enum _DiscountSource { customer, invoice, voucher, dynamic }

// =====================================================================
// حاسبة الفاتورة
// =====================================================================

class InvoiceCalculator {
  static final double minimumTobaccoTax = 25.toDouble();
  static final double _hundred = 100.toDouble();

  final ItemTypeId noteItemTypeId;
  final ItemTypeId offerItemTypeId;

  const InvoiceCalculator({
    required this.noteItemTypeId,
    required this.offerItemTypeId,
  });

  InvoiceCalculationResponse calculate(InvoiceCalculationInput input) {
    final validationError = _validate(input);
    if (validationError != null) {
      return InvoiceCalculationResponse.failure(validationError);
    }

    final calculableItems = _selectCalculableItems(input.items);
    if (calculableItems.isEmpty) {
      return InvoiceCalculationResponse.failure(
        const InvoiceCalculationError(
          messageAr: 'لا توجد أصناف قابلة للحساب',
          messageEn: 'No calculable items exist',
        ),
      );
    }

    final totalOfItems = calculableItems.fold<double>(
      0.0,
      (sum, item) => sum + item.grossValue,
    );

    if (totalOfItems <= 0.0) {
      return InvoiceCalculationResponse.failure(
        const InvoiceCalculationError(
          messageAr: 'إجمالي الأصناف يجب أن يكون أكبر من صفر',
          messageEn: 'Total items value must be greater than zero',
        ),
      );
    }

    // -- خصومات الأصناف --
    final itemDiscountError = _validateItemDiscounts(calculableItems);
    if (itemDiscountError != null) {
      return InvoiceCalculationResponse.failure(itemDiscountError);
    }

    final itemDiscountValues = <String, double>{};
    for (final item in calculableItems) {
      itemDiscountValues[item.transactionId] = _resolveDiscountValue(
        base: item.grossValue,
        discount: item.discount,
        type: item.discountType,
      );
    }

    final totalItemDiscount = itemDiscountValues.values.fold<double>(
      0.0,
      (sum, v) => sum + v,
    );

    if (totalItemDiscount > totalOfItems) {
      return InvoiceCalculationResponse.failure(
        const InvoiceCalculationError(
          messageAr: 'إجمالي خصومات الأصناف أكبر من قيمة الأصناف',
          messageEn: 'Total item discounts cannot exceed total items value',
        ),
      );
    }

    var totalAfterItemDiscount = totalOfItems - totalItemDiscount;
    if (totalAfterItemDiscount < 0.0) {
      totalAfterItemDiscount = 0.0;
    }

    // -- خيارات خصم الفاتورة --
    final customerDiscount = input.customerDiscountRatio > 0.0
        ? totalAfterItemDiscount * input.customerDiscountRatio / _hundred
        : 0.0;

    final directInvoiceDiscount = _resolveDiscountValue(
      base: totalAfterItemDiscount,
      discount: input.discountOnTotal,
      type: input.discountType,
    );

    if (directInvoiceDiscount > totalAfterItemDiscount) {
      return InvoiceCalculationResponse.failure(
        const InvoiceCalculationError(
          messageAr:
              'خصم الفاتورة لا يمكن أن يتجاوز إجمالي الأصناف بعد خصومات الأصناف',
          messageEn:
              'Invoice discount cannot exceed total items after item discounts',
        ),
      );
    }

    final voucherDiscount = _resolveVoucherDiscount(
      voucher: input.voucher,
      totalAfterItemDiscount: totalAfterItemDiscount,
    );

    // خصم ديناميكي: بيتفعل لو الفاتورة >= الحد الأدنى، ومحدود بالحد الأقصى
    final dynamicDiscountValue = _resolveDynamicDiscount(
      dynamicDiscount: input.dynamicDiscount,
      totalAfterItemDiscount: totalAfterItemDiscount,
    );

    // -- المقارنة بين كل مصادر الخصم واختيار الأعلى --
    var winningDiscount = customerDiscount;
    var winningSource = _DiscountSource.customer;

    if (directInvoiceDiscount > winningDiscount) {
      winningDiscount = directInvoiceDiscount;
      winningSource = _DiscountSource.invoice;
    }
    if (voucherDiscount >= winningDiscount && voucherDiscount > 0.0) {
      winningDiscount = voucherDiscount;
      winningSource = _DiscountSource.voucher;
    }
    if (dynamicDiscountValue >= winningDiscount && dynamicDiscountValue > 0.0) {
      winningDiscount = dynamicDiscountValue;
      winningSource = _DiscountSource.dynamic;
    }

    final resultVoucherDiscount = winningSource == _DiscountSource.voucher
        ? winningDiscount
        : 0.0;
    final resultInvoiceDiscount = winningSource == _DiscountSource.invoice
        ? winningDiscount
        : 0.0;
    final resultDynamicDiscount = winningSource == _DiscountSource.dynamic
        ? winningDiscount
        : 0.0;

    var netAmount = totalAfterItemDiscount - winningDiscount;
    if (netAmount < 0.0) {
      netAmount = 0.0;
    }

    // -- توزيع خصم الفاتورة نسبيًا على كل صنف --
    final allocatedDiscounts = <String, double>{};
    for (final item in calculableItems) {
      if (winningDiscount > 0.0 && totalOfItems > 0.0) {
        allocatedDiscounts[item.transactionId] =
            (item.grossValue / totalOfItems) * winningDiscount;
      } else {
        allocatedDiscounts[item.transactionId] = 0.0;
      }
    }

    // -- الضريبة وضريبة التبغ (تُحسب بعد خصم الصنف وخصم الفاتورة الموزّع) --
    var totalVAT = 0.0;
    var totalTobaccoTax = 0.0;
    final itemResults = <InvoiceItemResult>[];

    for (final item in calculableItems) {
      final itemDiscountValue = itemDiscountValues[item.transactionId]!;
      final allocated = allocatedDiscounts[item.transactionId]!;

      // صافي الصنف بعد خصم الصنف وخصم الفاتورة الموزّع عليه
      var itemNet = item.grossValue - itemDiscountValue - allocated;
      if (itemNet < 0.0) itemNet = 0.0;

      var itemVAT = 0.0;
      if (input.applyVAT && item.vatRatio > 0.0) {
        itemVAT = input.priceIncludesVAT
            ? itemNet * item.vatRatio / (_hundred + item.vatRatio)
            : itemNet * item.vatRatio / _hundred;
      }
      totalVAT += itemVAT;

      // ضريبة التبغ تُحسب على الصافي بعد الخصم (وبعد خصم الضريبة إن كان السعر شاملها)
      var itemTobaccoTax = 0.0;
      if (item.isTobacco) {
        final tobaccoBase = input.priceIncludesVAT
            ? itemNet - itemVAT
            : itemNet;
        itemTobaccoTax = tobaccoBase;
        totalTobaccoTax += itemTobaccoTax;
      }

      itemResults.add(
        InvoiceItemResult(
          input: item,
          itemDiscountValue: itemDiscountValue,
          allocatedInvoiceDiscountValue: allocated,
          vatValue: itemVAT,
          tobaccoTaxValue: itemTobaccoTax,
        ),
      );
    }

    // -- رسوم خدمة الصالة --
    final dineInCost = input.dineInRatio > 0.0
        ? netAmount * input.dineInRatio / _hundred
        : 0.0;

    return InvoiceCalculationResponse.success(
      InvoiceCalculationResult(
        priceIncludesVAT: input.priceIncludesVAT,
        items: itemResults,
        totalOfItems: totalOfItems,
        totalItemDiscount: totalItemDiscount,
        voucherDiscount: resultVoucherDiscount,
        invoiceDiscount: resultInvoiceDiscount,
        dynamicDiscount: resultDynamicDiscount,
        totalDiscount: totalItemDiscount + winningDiscount,
        totalVAT: totalVAT,
        // إذا كان إجمالي ضريبة التبغ أقل من 25 يُضبط على 25، غير ذلك يؤخذ كما هو
        totalTobaccoTax: totalTobaccoTax == 0
            ? 0
            : totalTobaccoTax < 25
            ? 25
            : totalTobaccoTax,
        deliveryCost: input.deliveryCost,
        dineInCost: dineInCost,
      ),
    );
  }

  InvoiceCalculationError? _validate(InvoiceCalculationInput input) {
    if (input.items.isEmpty) {
      return const InvoiceCalculationError(
        messageAr: 'لا توجد أصناف',
        messageEn: 'No items exist',
      );
    }

    if (input.deliveryCost < 0.0) {
      return const InvoiceCalculationError(
        messageAr: 'مصاريف التوصيل لا يمكن أن تكون بالسالب',
        messageEn: 'Delivery cost cannot be negative',
      );
    }

    if (input.dineInRatio < 0.0) {
      return const InvoiceCalculationError(
        messageAr: 'نسبة خدمة الصالة غير صحيحة',
        messageEn: 'Dine in ratio is invalid',
      );
    }

    if (input.customerDiscountRatio < 0.0 ||
        input.customerDiscountRatio > _hundred) {
      return const InvoiceCalculationError(
        messageAr: 'نسبة خصم العميل يجب أن تكون بين 0 و 100',
        messageEn: 'Customer discount ratio must be between 0 and 100',
      );
    }

    if (input.discountOnTotal < 0.0) {
      return const InvoiceCalculationError(
        messageAr: 'خصم الفاتورة لا يمكن أن يكون بالسالب',
        messageEn: 'Invoice discount cannot be negative',
      );
    }

    if (input.discountOnTotal > 0.0) {
      final hasManualItemDiscount = input.items.any(
        (item) => item.discount > 0.0,
      );
      if (hasManualItemDiscount) {
        return const InvoiceCalculationError(
          messageAr: 'لا يمكن ادخال خصم يدوي على الاصناف مع خصم على الفاتورة',
          messageEn:
              "Can't use manual discount on items and on invoice together",
        );
      }
    }

    if (input.dynamicDiscount != null &&
        input.dynamicDiscount!.discountValue < 0.0) {
      return const InvoiceCalculationError(
        messageAr: 'قيمة الخصم الديناميكي لا يمكن أن تكون بالسالب',
        messageEn: 'Dynamic discount value cannot be negative',
      );
    }

    for (final item in input.items) {
      if (item.quantity <= 0.0) {
        return InvoiceCalculationError(
          messageAr: 'كمية الصنف رقم ${item.itemId} يجب أن تكون أكبر من صفر',
          messageEn:
              'Quantity of item ${item.itemId} must be greater than zero',
        );
      }
      if (item.unitPrice < 0.0) {
        return InvoiceCalculationError(
          messageAr: 'سعر الصنف رقم ${item.itemId} لا يمكن أن يكون بالسالب',
          messageEn: 'Unit price of item ${item.itemId} cannot be negative',
        );
      }
      if (item.vatRatio < 0.0) {
        return InvoiceCalculationError(
          messageAr: 'نسبة الضريبة للصنف رقم ${item.itemId} غير صحيحة',
          messageEn: 'VAT ratio of item ${item.itemId} is invalid',
        );
      }
      if (item.discount < 0.0) {
        return InvoiceCalculationError(
          messageAr: 'خصم الصنف رقم ${item.itemId} لا يمكن أن يكون بالسالب',
          messageEn: 'Item discount of item ${item.itemId} cannot be negative',
        );
      }
    }

    return null;
  }

  InvoiceCalculationError? _validateItemDiscounts(
    List<InvoiceItemInput> items,
  ) {
    final withDiscount = items.where((i) => i.discount > 0.0);

    final illegalRatio = withDiscount.where(
      (i) =>
          i.discountType == DiscountNatural.percentage && i.discount > _hundred,
    );
    if (illegalRatio.isNotEmpty) {
      return const InvoiceCalculationError(
        messageAr: 'خصم الصنف لا يمكن تجاوز نسبة 100%',
        messageEn: "Discount on item Can't exceed the ratio of 100%",
      );
    }

    final illegalValue = withDiscount.where(
      (i) =>
          i.discountType == DiscountNatural.fixedAmount &&
          i.discount > i.grossValue,
    );
    if (illegalValue.isNotEmpty) {
      return const InvoiceCalculationError(
        messageAr: 'خصم الصنف لا يمكن تجاوز الاجمالى',
        messageEn: "Discount on item Can't exceed the Total",
      );
    }

    return null;
  }

  /// التعديل هنا: السماح بحساب الإضافات (Additives) حتى لو كانت مرتبطة بـ parentTransactionId
  List<InvoiceItemInput> _selectCalculableItems(List<InvoiceItemInput> items) {
    final offerTransactionIds = items
        .where((i) => i.itemTypeId == offerItemTypeId)
        .map((i) => i.transactionId)
        .toSet();

    return items.where((item) {
      // 1. استبعاد الملاحظات دائماً
      if (item.itemTypeId == noteItemTypeId) return false;

      final parentId = item.parentTransactionId;

      // 2. إذا كان الصنف تابعة لعرض (Offer)، يتم استبعاده لمنع التكرار
      final isChildOfOffer =
          parentId != null &&
          parentId.isNotEmpty &&
          offerTransactionIds.contains(parentId) &&
          item.itemTypeId != offerItemTypeId;

      if (isChildOfOffer) return false;

      // 3. الإضافات (Additives) أصبحت قابلة للحساب ومقبولة
      return true;
    }).toList();
  }

  double _resolveDiscountValue({
    required double base,
    required double discount,
    required DiscountNatural type,
  }) {
    if (discount <= 0.0) return 0.0;
    return type == DiscountNatural.fixedAmount
        ? discount
        : base * discount / _hundred;
  }

  double _resolveVoucherDiscount({
    required VoucherInput? voucher,
    required double totalAfterItemDiscount,
  }) {
    if (voucher == null || voucher.code.trim().isEmpty) return 0.0;
    if (totalAfterItemDiscount < voucher.minimumCharge) return 0.0;

    var discount = voucher.discountType == DiscountNatural.percentage
        ? totalAfterItemDiscount * voucher.value / _hundred
        : voucher.value;

    if (voucher.maximumDiscount > 0.0 && discount > voucher.maximumDiscount) {
      discount = voucher.maximumDiscount;
    }

    if (discount > totalAfterItemDiscount) {
      discount = totalAfterItemDiscount;
    }

    return discount;
  }

  /// حساب الخصم الديناميكي مع مراعاة الحد الأدنى والحد الأقصى
  double _resolveDynamicDiscount({
    required DynamicDiscountInput? dynamicDiscount,
    required double totalAfterItemDiscount,
  }) {
    if (dynamicDiscount == null) return 0.0;
    if (dynamicDiscount.discountValue <= 0.0) return 0.0;

    // الحد الأدنى: لازم صافي الفاتورة يكون أكبر منه عشان الخصم يتفعل
    final minInvoice = dynamicDiscount.minInvoiceNET;
    if (minInvoice != null && totalAfterItemDiscount < minInvoice) {
      return 0.0;
    }

    var value = _resolveDiscountValue(
      base: totalAfterItemDiscount,
      discount: dynamicDiscount.discountValue,
      type: dynamicDiscount.discountType,
    );

    // الحد الأقصى: يقصّ قيمة الخصم لو موجود
    final maxValue = dynamicDiscount.maxDiscountValue;
    if (maxValue != null && maxValue > 0.0 && value > maxValue) {
      value = maxValue;
    }

    if (value > totalAfterItemDiscount) {
      value = totalAfterItemDiscount;
    }

    return value;
  }
}

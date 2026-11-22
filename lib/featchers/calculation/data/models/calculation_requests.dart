class OpenNewCartRequest {
  final int empId;
  final String companyName;
  final bool priceIncludeVAT;
  final bool applyVAT;
  final double vatRatio;
  final bool applyTobaccoTax;
  final bool systemApplyDiscount;
  final bool userCanAddDiscount;
  final int decimalCount;

  const OpenNewCartRequest({
    required this.empId,
    required this.companyName,
    required this.priceIncludeVAT,
    required this.applyVAT,
    required this.vatRatio,
    required this.applyTobaccoTax,
    required this.systemApplyDiscount,
    required this.userCanAddDiscount,
    required this.decimalCount,
  });

  Map<String, dynamic> toQuery() => {
    'empId': empId,
    'CompanyName': companyName,
    'priceIncludeVAT': priceIncludeVAT,
    'ApplyVAT': applyVAT,
    'VatRatio': vatRatio,
    'ApplyTobbacoTax': applyTobaccoTax,
    'SystemApplyDiscount': systemApplyDiscount,
    'UserCanAddDiscount': userCanAddDiscount,
    'DecimalCount': decimalCount,
  };
}

class AddCalculationItemRequest {
  final String cartId;
  final int itemId;
  final double quantity;
  final double unitPrice;
  final double vatRatio;
  final double itemDiscount;
  final double minimumCharge;
  final double maximumDiscount;
  final bool isAutoDiscount;
  final int itemTypeId;
  final bool isTobacco;
  final String transactionId;
  final String? parentTransactionId;

  const AddCalculationItemRequest({
    required this.cartId,
    required this.itemId,
    required this.quantity,
    required this.unitPrice,
    required this.vatRatio,
    required this.itemDiscount,
    required this.minimumCharge,
    required this.maximumDiscount,
    required this.isAutoDiscount,
    required this.itemTypeId,
    required this.isTobacco,
    required this.transactionId,
    this.parentTransactionId,
  });

  Map<String, dynamic> toQuery() {
    final query = <String, dynamic>{
      'CartID': cartId,
      'itemID': itemId,
      'qty': quantity,
      'unitPrice': unitPrice,
      'VATRatio': vatRatio,
      'itemDiscount': itemDiscount,
      'minimumCharge': minimumCharge,
      'MaximumDiscount': maximumDiscount,
      'isAutoDiscount': isAutoDiscount,
      'itemTypeId': itemTypeId,
      'isTobacco': isTobacco,
      'TransactionID': transactionId,
    };

    if (parentTransactionId != null && parentTransactionId!.isNotEmpty) {
      query['ParentTransactionID'] = parentTransactionId;
    }

    return query;
  }
}

class EditCalculationItemRequest {
  final String cartId;
  final String transactionId;
  final double quantity;
  final double unitPrice;
  final double vatRatio;
  final double itemDiscount;
  final double minimumCharge;
  final double maximumDiscount;
  final bool isAutoDiscount;

  const EditCalculationItemRequest({
    required this.cartId,
    required this.transactionId,
    required this.quantity,
    required this.unitPrice,
    required this.vatRatio,
    required this.itemDiscount,
    required this.minimumCharge,
    required this.maximumDiscount,
    required this.isAutoDiscount,
  });

  Map<String, dynamic> toQuery() => {
    'CartID': cartId,
    'TransID': transactionId,
    'qty': quantity,
    'unitPrice': unitPrice,
    'VATRatio': vatRatio,
    'itemDiscount': itemDiscount,
    'minimumCharge': minimumCharge,
    'MaximumDiscount': maximumDiscount,
    'isAutoDiscount': isAutoDiscount,
  };
}

class SetPosTypeRequest {
  final String cartId;
  final int posType;
  final double deliveryCost;
  final double dineInRatio;
  const SetPosTypeRequest({
    required this.cartId,
    required this.posType,
    this.deliveryCost = 0,
    this.dineInRatio = 0,
  });
  Map<String, dynamic> toQuery() => {
    'CartID': cartId,
    'PosType': posType,
    'DeliveryCost': deliveryCost,
    'DineInRatio': dineInRatio,
  };
}

class AddVoucherRequest {
  final String cartId;
  final String code;
  final int discountNatural; // 1 ratio / 2 value
  final double discountValue;
  final double minimumCharge;
  final double maximumDiscount;
  const AddVoucherRequest({
    required this.cartId,
    required this.code,
    required this.discountNatural,
    required this.discountValue,
    this.minimumCharge = 0,
    this.maximumDiscount = 0,
  });
  Map<String, dynamic> toQuery() => {
    'CartID': cartId,
    'VoucherCode': code,
    'DiscountNatural': discountNatural,
    'DiscountValue': discountValue,
    'MinimumCharge': minimumCharge,
    'MaximumDiscount': maximumDiscount,
  };
}

class SetDiscountOnTotalRequest {
  final String cartId;
  final int discountNatural;
  final double discountValue;
  final bool isAutoDiscount;
  final double minimumCharge;
  final double maximumDiscount;
  const SetDiscountOnTotalRequest({
    required this.cartId,
    required this.discountNatural,
    required this.discountValue,
    this.isAutoDiscount = false,
    this.minimumCharge = 0,
    this.maximumDiscount = 0,
  });
  Map<String, dynamic> toQuery() => {
    'CartID': cartId,
    'DiscountNatural': discountNatural,
    'DiscountValue': discountValue,
    'isAutoDiscount': isAutoDiscount,
    'minimumCharge': minimumCharge,
    'MaximumDiscount': maximumDiscount,
  };
}

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
  final int discountNatural;
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
    required this.discountNatural,
  });

  Map<String, dynamic> toQuery() {
    final query = <String, dynamic>{
      'CartID': cartId,
      'itemID': itemId,
      'qty': quantity,
      'unitPrice': unitPrice,
      'VATRatio': vatRatio,
      'itemDiscount': itemDiscount,
      "discountNatural": discountNatural,
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
  final int discountNatural;
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
    required this.discountNatural,
  });

  Map<String, dynamic> toQuery() => {
    'CartID': cartId,
    'TransID': transactionId,
    'qty': quantity,
    'unitPrice': unitPrice,
    'VATRatio': vatRatio,
    'itemDiscount': itemDiscount,
    'discountNatural': discountNatural,
    'minimumCharge': minimumCharge,
    'MaximumDiscount': maximumDiscount,
    'isAutoDiscount': isAutoDiscount,
  };
}

class SetPosTypeRequest {
  final String cartId;
  final int posType;
  final double serviceValue;
  const SetPosTypeRequest({
    required this.cartId,
    required this.posType,
    required this.serviceValue,
  });
  Map<String, dynamic> toQuery() => {
    'CartID': cartId,
    'posType': posType,
    'ServiceValue': serviceValue,
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

class EditListOfItemsRequest {
  final String cardId;
  final List<CalculationItemModel> items;

  const EditListOfItemsRequest({required this.cardId, required this.items});

  Map<String, dynamic> toQuery() => {
    'CartID': cardId,
    'Items': items.map((item) => item.toQuery()).toList(),
  };
}

class CalculationItemModel {
  final int itemId;
  final double quantity;
  final double unitPrice;
  final double vatRatio;
  final ItemDiscountModel discountOnItem;
  final int itemTypeId;
  final bool isTobacco;
  final String transactionId;
  final String parentTransactionId;
  final double itemDiscountValue;
  final double vatValue;
  final double spDiscount;
  final double tobaccoTaxValue;
  final String name;

  const CalculationItemModel({
    required this.itemId,
    required this.quantity,
    required this.unitPrice,
    required this.vatRatio,
    required this.discountOnItem,
    required this.itemTypeId,
    required this.isTobacco,
    required this.transactionId,
    required this.parentTransactionId,
    required this.itemDiscountValue,
    required this.vatValue,
    required this.spDiscount,
    required this.tobaccoTaxValue,
    required this.name,
  });

  factory CalculationItemModel.fromMap(Map<String, dynamic> map) {
    return CalculationItemModel(
      itemId: (map['itemID'] as num?)?.toInt() ?? 0,
      quantity: (map['qty'] as num?)?.toDouble() ?? 0.0,
      unitPrice: (map['unitPrice'] as num?)?.toDouble() ?? 0.0,
      vatRatio: (map['vatRatio'] as num?)?.toDouble() ?? 0.0,
      discountOnItem: ItemDiscountModel.fromMap(
        map['discountOnItem'] as Map<String, dynamic>? ?? {},
      ),
      itemTypeId: (map['itemTypeId'] as num?)?.toInt() ?? 0,
      isTobacco: map['isTobacco'] as bool? ?? false,
      transactionId: map['transactionID'] as String? ?? '',
      parentTransactionId: map['parentTransactionID'] as String? ?? '',
      itemDiscountValue: (map['itemDiscountValue'] as num?)?.toDouble() ?? 0.0,
      vatValue: (map['vatValue'] as num?)?.toDouble() ?? 0.0,
      spDiscount: (map['spDiscount'] as num?)?.toDouble() ?? 0.0,
      tobaccoTaxValue: (map['tobaccoTaxValue'] as num?)?.toDouble() ?? 0.0,
      name: map['name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toQuery() {
    return {
      'itemID': itemId,
      'qty': quantity,
      'unitPrice': unitPrice,
      'vatRatio': vatRatio,
      'discountOnItem': discountOnItem.toMap(),
      'itemTypeId': itemTypeId,
      'isTobacco': isTobacco,
      'transactionID': transactionId,
      'parentTransactionID': parentTransactionId,
      'itemDiscountValue': itemDiscountValue,
      'vatValue': vatValue,
      'spDiscount': spDiscount,
      'tobaccoTaxValue': tobaccoTaxValue,
      'name': name,
    };
  }
}

class ItemDiscountModel {
  final double discountValue;
  final bool isAutoDiscount;
  final int discountNatural;
  final double minimumCharge;
  final double maximumDiscount;

  const ItemDiscountModel({
    required this.discountValue,
    required this.isAutoDiscount,
    required this.discountNatural,
    required this.minimumCharge,
    required this.maximumDiscount,
  });

  factory ItemDiscountModel.fromMap(Map<String, dynamic> map) {
    return ItemDiscountModel(
      discountValue: (map['discountValue'] as num?)?.toDouble() ?? 0.0,
      isAutoDiscount: map['isAutoDiscount'] as bool? ?? false,
      discountNatural: (map['discountNatural'] as num?)?.toInt() ?? 1,
      minimumCharge: (map['minimumCharge'] as num?)?.toDouble() ?? 0.0,
      maximumDiscount: (map['maximumDiscount'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'discountValue': discountValue,
      'isAutoDiscount': isAutoDiscount,
      'discountNatural': discountNatural,
      'minimumCharge': minimumCharge,
      'maximumDiscount': maximumDiscount,
    };
  }
}

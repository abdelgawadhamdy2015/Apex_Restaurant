// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restored_invoice_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RestoredInvoiceModel _$RestoredInvoiceModelFromJson(
  Map<String, dynamic> json,
) => RestoredInvoiceModel(
  invoice: RestoredInvoiceInfo.fromJson(
    json['invoice'] as Map<String, dynamic>,
  ),
  items: (json['items'] as List<dynamic>)
      .map((e) => RestoredInvoiceItem.fromJson(e as Map<String, dynamic>))
      .toList(),
  payments: (json['payments'] as List<dynamic>)
      .map((e) => RestoredInvoicePayment.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$RestoredInvoiceModelToJson(
  RestoredInvoiceModel instance,
) => <String, dynamic>{
  'invoice': instance.invoice,
  'items': instance.items,
  'payments': instance.payments,
};

RestoredInvoiceInfo _$RestoredInvoiceInfoFromJson(Map<String, dynamic> json) =>
    RestoredInvoiceInfo(
      invoiceId: (json['invoiceId'] as num).toInt(),
      invoiceDiscountId: (json['invoiceDiscountId'] as num).toInt(),
      orderNumber: (json['orderNumber'] as num).toInt(),
      invoiceCode: json['invoiceCode'] as String,
      invoiceDate: DateTime.parse(json['invoiceDate'] as String),
      posType: (json['posType'] as num).toInt(),
      foodTableId: (json['foodTableId'] as num?)?.toInt(),
      foodTableArabicName: json['foodTableArabicName'] as String?,
      foodTableLatinName: json['foodTableLatinName'] as String?,
      waiterId: (json['waiterId'] as num?)?.toInt(),
      waiterArabicName: json['waiterArabicName'] as String?,
      waiterLatinName: json['waiterLatinName'] as String?,
      deliveryCompanyId: (json['deliveryCompanyId'] as num?)?.toInt(),
      deliveryCompanyArabicName: json['deliveryCompanyArabicName'] as String?,
      deliveryCompanyLatinName: json['deliveryCompanyLatinName'] as String?,
      deliveryManId: (json['deliveryManId'] as num?)?.toInt(),
      deliveryManArabicName: json['deliveryManArabicName'] as String?,
      deliveryManLatinName: json['deliveryManLatinName'] as String?,
      clientId: (json['clientId'] as num?)?.toInt(),
      clientArabicName: json['clientArabicName'] as String?,
      clientLatinName: json['clientLatinName'] as String?,
      personAddressId: (json['personAddressId'] as num?)?.toInt(),
      address: json['address'] == null
          ? null
          : RestoredAddress.fromJson(json['address'] as Map<String, dynamic>),
      personPhoneId: (json['personPhoneId'] as num?)?.toInt(),
      phone: json['phone'] == null
          ? null
          : RestoredPhone.fromJson(json['phone'] as Map<String, dynamic>),
      notes: json['notes'] as String?,
      invoiceDiscount: json['invoiceDiscount'] == null
          ? null
          : RestoredInvoiceDiscount.fromJson(
              json['invoiceDiscount'] as Map<String, dynamic>,
            ),
      totalInvoicePrice: (json['totalInvoicePrice'] as num).toDouble(),
      paidAmount: (json['paidAmount'] as num).toDouble(),
      remain: (json['remain'] as num).toDouble(),
      totalVat: (json['totalVat'] as num).toDouble(),
      deliveryCost: (json['deliveryCost'] as num).toDouble(),
      dineInCost: (json['dineInCost'] as num).toDouble(),
      tobaccoTax: (json['tobaccoTax'] as num).toDouble(),
      client: json['client'] == null
          ? null
          : RestoredClient.fromJson(json['client'] as Map<String, dynamic>),
      waiter: json['waiter'] == null
          ? null
          : RestoredWaiter.fromJson(json['waiter'] as Map<String, dynamic>),
      deliveryCompany: json['deliveryCompany'] == null
          ? null
          : RestoredDeliveryCompany.fromJson(
              json['deliveryCompany'] as Map<String, dynamic>,
            ),
      deliveryMan: json['deliveryMan'] == null
          ? null
          : RestoredDeliveryMan.fromJson(
              json['deliveryMan'] as Map<String, dynamic>,
            ),
      foodTable: json['foodTable'] == null
          ? null
          : RestoredFoodTable.fromJson(
              json['foodTable'] as Map<String, dynamic>,
            ),
      voucherId: (json['voucherId'] as num?)?.toInt(),
    );

Map<String, dynamic> _$RestoredInvoiceInfoToJson(
  RestoredInvoiceInfo instance,
) => <String, dynamic>{
  'invoiceId': instance.invoiceId,
  'invoiceDiscountId': instance.invoiceDiscountId,
  'orderNumber': instance.orderNumber,
  'invoiceCode': instance.invoiceCode,
  'invoiceDate': instance.invoiceDate.toString(),
  'posType': instance.posType,
  'foodTableId': instance.foodTableId,
  'foodTableArabicName': instance.foodTableArabicName,
  'foodTableLatinName': instance.foodTableLatinName,
  'waiterId': instance.waiterId,
  'waiterArabicName': instance.waiterArabicName,
  'waiterLatinName': instance.waiterLatinName,
  'deliveryCompanyId': instance.deliveryCompanyId,
  'deliveryCompanyArabicName': instance.deliveryCompanyArabicName,
  'deliveryCompanyLatinName': instance.deliveryCompanyLatinName,
  'deliveryManId': instance.deliveryManId,
  'deliveryManArabicName': instance.deliveryManArabicName,
  'deliveryManLatinName': instance.deliveryManLatinName,
  'clientId': instance.clientId,
  'clientArabicName': instance.clientArabicName,
  'clientLatinName': instance.clientLatinName,
  'personAddressId': instance.personAddressId,
  'address': instance.address,
  'personPhoneId': instance.personPhoneId,
  'phone': instance.phone,
  'notes': instance.notes,
  'invoiceDiscount': instance.invoiceDiscount,
  'totalInvoicePrice': instance.totalInvoicePrice,
  'paidAmount': instance.paidAmount,
  'remain': instance.remain,
  'totalVat': instance.totalVat,
  'deliveryCost': instance.deliveryCost,
  'dineInCost': instance.dineInCost,
  'tobaccoTax': instance.tobaccoTax,
  'client': instance.client,
  'waiter': instance.waiter,
  'deliveryCompany': instance.deliveryCompany,
  'deliveryMan': instance.deliveryMan,
  'foodTable': instance.foodTable,
  'voucherId': instance.voucherId,
};

RestoredAddress _$RestoredAddressFromJson(Map<String, dynamic> json) =>
    RestoredAddress(
      id: (json['id'] as num).toInt(),
      addressLineAr: json['addressLineAr'] as String,
      addressLineEn: json['addressLineEn'] as String,
      city: json['city'] as String,
      street: json['street'] as String?,
      district: json['district'] as String,
      buildingNo: json['buildingNo'] as String,
      floor: json['floor'] as String?,
      apartmentNo: json['apartmentNo'] as String,
      landmark: json['landmark'] as String?,
      isDefault: json['isDefault'] as bool,
      personsId: (json['personsId'] as num).toInt(),
      isDeleted: json['isDeleted'] as bool,
      persons: json['persons'],
    );

Map<String, dynamic> _$RestoredAddressToJson(RestoredAddress instance) =>
    <String, dynamic>{
      'id': instance.id,
      'addressLineAr': instance.addressLineAr,
      'addressLineEn': instance.addressLineEn,
      'city': instance.city,
      'street': instance.street,
      'district': instance.district,
      'buildingNo': instance.buildingNo,
      'floor': instance.floor,
      'apartmentNo': instance.apartmentNo,
      'landmark': instance.landmark,
      'isDefault': instance.isDefault,
      'personsId': instance.personsId,
      'isDeleted': instance.isDeleted,
      'persons': instance.persons,
    };

RestoredPhone _$RestoredPhoneFromJson(Map<String, dynamic> json) =>
    RestoredPhone();

Map<String, dynamic> _$RestoredPhoneToJson(RestoredPhone instance) =>
    <String, dynamic>{};

RestoredInvoiceDiscount _$RestoredInvoiceDiscountFromJson(
  Map<String, dynamic> json,
) => RestoredInvoiceDiscount(
  id: (json['id'] as num).toInt(),
  arabicName: json['arabicName'] as String?,
  latinName: json['latinName'] as String?,
  discountType: (json['discountType'] as num).toInt(),
  discountNatural: (json['discountNatural'] as num).toInt(),
  discountValue: (json['discountValue'] as num).toDouble(),
  isAutomatic: json['isAutomatic'] as bool,
);

Map<String, dynamic> _$RestoredInvoiceDiscountToJson(
  RestoredInvoiceDiscount instance,
) => <String, dynamic>{
  'id': instance.id,
  'arabicName': instance.arabicName,
  'latinName': instance.latinName,
  'discountType': instance.discountType,
  'discountNatural': instance.discountNatural,
  'discountValue': instance.discountValue,
  'isAutomatic': instance.isAutomatic,
};

RestoredClient _$RestoredClientFromJson(Map<String, dynamic> json) =>
    RestoredClient(
      id: (json['id'] as num).toInt(),
      arabicName: json['arabicName'] as String,
      latinName: json['latinName'] as String,
      price: (json['price'] as num).toDouble(),
      categoryId: (json['categoryId'] as num).toInt(),
    );

Map<String, dynamic> _$RestoredClientToJson(RestoredClient instance) =>
    <String, dynamic>{
      'id': instance.id,
      'arabicName': instance.arabicName,
      'latinName': instance.latinName,
      'price': instance.price,
      'categoryId': instance.categoryId,
    };

RestoredWaiter _$RestoredWaiterFromJson(Map<String, dynamic> json) =>
    RestoredWaiter(
      id: (json['id'] as num).toInt(),
      arabicName: json['arabicName'] as String,
      latinName: json['latinName'] as String,
      price: (json['price'] as num).toDouble(),
      categoryId: (json['categoryId'] as num).toInt(),
    );

Map<String, dynamic> _$RestoredWaiterToJson(RestoredWaiter instance) =>
    <String, dynamic>{
      'id': instance.id,
      'arabicName': instance.arabicName,
      'latinName': instance.latinName,
      'price': instance.price,
      'categoryId': instance.categoryId,
    };

RestoredDeliveryCompany _$RestoredDeliveryCompanyFromJson(
  Map<String, dynamic> json,
) => RestoredDeliveryCompany(
  id: (json['id'] as num).toInt(),
  arabicName: json['arabicName'] as String,
  latinName: json['latinName'] as String,
  price: (json['price'] as num).toDouble(),
  categoryId: (json['categoryId'] as num).toInt(),
);

Map<String, dynamic> _$RestoredDeliveryCompanyToJson(
  RestoredDeliveryCompany instance,
) => <String, dynamic>{
  'id': instance.id,
  'arabicName': instance.arabicName,
  'latinName': instance.latinName,
  'price': instance.price,
  'categoryId': instance.categoryId,
};

RestoredDeliveryMan _$RestoredDeliveryManFromJson(Map<String, dynamic> json) =>
    RestoredDeliveryMan(
      id: (json['id'] as num).toInt(),
      arabicName: json['arabicName'] as String,
      latinName: json['latinName'] as String,
      price: (json['price'] as num).toDouble(),
      categoryId: (json['categoryId'] as num).toInt(),
    );

Map<String, dynamic> _$RestoredDeliveryManToJson(
  RestoredDeliveryMan instance,
) => <String, dynamic>{
  'id': instance.id,
  'arabicName': instance.arabicName,
  'latinName': instance.latinName,
  'price': instance.price,
  'categoryId': instance.categoryId,
};

RestoredFoodTable _$RestoredFoodTableFromJson(Map<String, dynamic> json) =>
    RestoredFoodTable(
      id: (json['id'] as num).toInt(),
      arabicName: json['arabicName'] as String,
      latinName: json['latinName'] as String,
      price: (json['price'] as num).toDouble(),
      categoryId: (json['categoryId'] as num).toInt(),
    );

Map<String, dynamic> _$RestoredFoodTableToJson(RestoredFoodTable instance) =>
    <String, dynamic>{
      'id': instance.id,
      'arabicName': instance.arabicName,
      'latinName': instance.latinName,
      'price': instance.price,
      'categoryId': instance.categoryId,
    };

RestoredInvoiceItem _$RestoredInvoiceItemFromJson(Map<String, dynamic> json) =>
    RestoredInvoiceItem(
      transactionId: (json['transactionId'] as num).toInt(),
      parentTransactionId: (json['parentTransactionId'] as num?)?.toInt(),
      itemId: (json['itemId'] as num).toInt(),
      itemArabicName: json['itemArabicName'] as String?,
      itemLatinName: json['itemLatinName'] as String?,
      itemImagePath: json['itemImagePath'] as String?,
      sizeId: (json['sizeId'] as num).toInt(),
      sizeArabicName: json['sizeArabicName'] as String?,
      sizeLatinName: json['sizeLatinName'] as String?,
      quantity: (json['quantity'] as num).toDouble(),
      price: (json['price'] as num).toDouble(),
      notes: json['notes'] as String,
      itemDiscount: json['itemDiscount'] == null
          ? null
          : RestoredItemDiscount.fromJson(
              json['itemDiscount'] as Map<String, dynamic>,
            ),
      additives: (json['additives'] as List<dynamic>)
          .map(
            (e) => RestoredInvoiceAdditive.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      item: json['item'] == null
          ? null
          : RestoredItem.fromJson(json['item'] as Map<String, dynamic>),
      size: json['size'] == null
          ? null
          : RestoredSize.fromJson(json['size'] as Map<String, dynamic>),
      additive: json['additive'],
      foodAdditiveId: (json['foodAdditiveId'] as num?)?.toInt(),
    );

Map<String, dynamic> _$RestoredInvoiceItemToJson(
  RestoredInvoiceItem instance,
) => <String, dynamic>{
  'transactionId': instance.transactionId,
  'parentTransactionId': instance.parentTransactionId,
  'itemId': instance.itemId,
  'itemArabicName': instance.itemArabicName,
  'itemLatinName': instance.itemLatinName,
  'itemImagePath': instance.itemImagePath,
  'sizeId': instance.sizeId,
  'sizeArabicName': instance.sizeArabicName,
  'sizeLatinName': instance.sizeLatinName,
  'quantity': instance.quantity,
  'price': instance.price,
  'notes': instance.notes,
  'itemDiscount': instance.itemDiscount,
  'additives': instance.additives,
  'item': instance.item,
  'size': instance.size,
  'additive': instance.additive,
  'foodAdditiveId': instance.foodAdditiveId,
};

RestoredItemDiscount _$RestoredItemDiscountFromJson(
  Map<String, dynamic> json,
) => RestoredItemDiscount(
  id: (json['id'] as num).toInt(),
  arabicName: json['arabicName'] as String?,
  latinName: json['latinName'] as String?,
  discountType: (json['discountType'] as num).toInt(),
  discountNatural: (json['discountNatural'] as num).toInt(),
  discountValue: (json['discountValue'] as num).toDouble(),
  isAutomatic: json['isAutomatic'] as bool,
);

Map<String, dynamic> _$RestoredItemDiscountToJson(
  RestoredItemDiscount instance,
) => <String, dynamic>{
  'id': instance.id,
  'arabicName': instance.arabicName,
  'latinName': instance.latinName,
  'discountType': instance.discountType,
  'discountNatural': instance.discountNatural,
  'discountValue': instance.discountValue,
  'isAutomatic': instance.isAutomatic,
};

RestoredInvoiceAdditive _$RestoredInvoiceAdditiveFromJson(
  Map<String, dynamic> json,
) => RestoredInvoiceAdditive(
  additiveId: (json['additiveId'] as num).toInt(),
  arabicName: json['arabicName'] as String?,
  latinName: json['latinName'] as String?,
  imagePath: json['imagePath'] as String?,
  quantity: (json['quantity'] as num).toDouble(),
  price: (json['price'] as num).toDouble(),
  additive: json['additive'] == null
      ? null
      : RestoredAdditive.fromJson(json['additive'] as Map<String, dynamic>),
  transactionId: (json['transactionId'] as num).toInt(),
  parentTransactionId: (json['parentTransactionId'] as num).toInt(),
);

Map<String, dynamic> _$RestoredInvoiceAdditiveToJson(
  RestoredInvoiceAdditive instance,
) => <String, dynamic>{
  'additiveId': instance.additiveId,
  'arabicName': instance.arabicName,
  'latinName': instance.latinName,
  'imagePath': instance.imagePath,
  'quantity': instance.quantity,
  'price': instance.price,
  'additive': instance.additive,
  'transactionId': instance.transactionId,
  'parentTransactionId': instance.parentTransactionId,
};

RestoredAdditive _$RestoredAdditiveFromJson(Map<String, dynamic> json) =>
    RestoredAdditive(
      id: (json['id'] as num).toInt(),
      arabicName: json['arabicName'] as String,
      latinName: json['latinName'] as String,
      price: (json['price'] as num).toDouble(),
      categoryId: (json['categoryId'] as num).toInt(),
    );

Map<String, dynamic> _$RestoredAdditiveToJson(RestoredAdditive instance) =>
    <String, dynamic>{
      'id': instance.id,
      'arabicName': instance.arabicName,
      'latinName': instance.latinName,
      'price': instance.price,
      'categoryId': instance.categoryId,
    };

RestoredItem _$RestoredItemFromJson(Map<String, dynamic> json) => RestoredItem(
  id: (json['id'] as num).toInt(),
  arabicName: json['arabicName'] as String,
  latinName: json['latinName'] as String,
  price: (json['price'] as num).toDouble(),
  categoryId: (json['categoryId'] as num).toInt(),
);

Map<String, dynamic> _$RestoredItemToJson(RestoredItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'arabicName': instance.arabicName,
      'latinName': instance.latinName,
      'price': instance.price,
      'categoryId': instance.categoryId,
    };

RestoredSize _$RestoredSizeFromJson(Map<String, dynamic> json) => RestoredSize(
  id: (json['id'] as num).toInt(),
  arabicName: json['arabicName'] as String,
  latinName: json['latinName'] as String,
  price: (json['price'] as num).toDouble(),
  categoryId: (json['categoryId'] as num).toInt(),
);

Map<String, dynamic> _$RestoredSizeToJson(RestoredSize instance) =>
    <String, dynamic>{
      'id': instance.id,
      'arabicName': instance.arabicName,
      'latinName': instance.latinName,
      'price': instance.price,
      'categoryId': instance.categoryId,
    };

RestoredInvoicePayment _$RestoredInvoicePaymentFromJson(
  Map<String, dynamic> json,
) => RestoredInvoicePayment(
  paymentMethodId: (json['paymentMethodId'] as num).toInt(),
  amount: (json['amount'] as num).toDouble(),
);

Map<String, dynamic> _$RestoredInvoicePaymentToJson(
  RestoredInvoicePayment instance,
) => <String, dynamic>{
  'paymentMethodId': instance.paymentMethodId,
  'amount': instance.amount,
};

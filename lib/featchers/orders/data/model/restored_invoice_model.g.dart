// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restored_invoice_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RestoredInvoiceModel _$RestoredInvoiceModelFromJson(
  Map<String, dynamic> json,
) => RestoredInvoiceModel(
  invoice: json['invoice'] == null
      ? null
      : RestoredInvoiceDetailsModel.fromJson(
          json['invoice'] as Map<String, dynamic>,
        ),
  items: (json['items'] as List<dynamic>?)
      ?.map((e) => RestoredInvoiceItemModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  payments: (json['payments'] as List<dynamic>?)
      ?.map(
        (e) => RestoredInvoicePaymentModel.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
);

Map<String, dynamic> _$RestoredInvoiceModelToJson(
  RestoredInvoiceModel instance,
) => <String, dynamic>{
  'invoice': instance.invoice,
  'items': instance.items,
  'payments': instance.payments,
};

RestoredInvoiceDetailsModel _$RestoredInvoiceDetailsModelFromJson(
  Map<String, dynamic> json,
) => RestoredInvoiceDetailsModel(
  invoiceId: (json['invoiceId'] as num?)?.toInt(),
  orderNumber: (json['orderNumber'] as num?)?.toInt(),
  invoiceCode: json['invoiceCode'] as String?,
  invoiceDate: json['invoiceDate'] as String?,
  posType: (json['posType'] as num?)?.toInt(),
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
  address: json['address'] as String?,
  personPhoneId: (json['personPhoneId'] as num?)?.toInt(),
  phone: json['phone'] as String?,
  notes: json['notes'] as String?,
  invoiceDiscount: json['invoiceDiscount'],
  totalInvoicePrice: (json['totalInvoicePrice'] as num?)?.toDouble(),
  paidAmount: (json['paidAmount'] as num?)?.toDouble(),
  remain: (json['remain'] as num?)?.toDouble(),
  totalVat: (json['totalVat'] as num?)?.toDouble(),
  deliveryCost: (json['deliveryCost'] as num?)?.toDouble(),
  dineInCost: (json['dineInCost'] as num?)?.toDouble(),
  tobaccoTax: (json['tobaccoTax'] as num?)?.toDouble(),
  client: json['client'] == null
      ? null
      : RestoredInvoiceClientModel.fromJson(
          json['client'] as Map<String, dynamic>,
        ),
  waiter: json['waiter'],
  deliveryCompany: json['deliveryCompany'],
  deliveryMan: json['deliveryMan'],
  foodTable: json['foodTable'],
);

Map<String, dynamic> _$RestoredInvoiceDetailsModelToJson(
  RestoredInvoiceDetailsModel instance,
) => <String, dynamic>{
  'invoiceId': instance.invoiceId,
  'orderNumber': instance.orderNumber,
  'invoiceCode': instance.invoiceCode,
  'invoiceDate': instance.invoiceDate,
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
};

RestoredInvoiceClientModel _$RestoredInvoiceClientModelFromJson(
  Map<String, dynamic> json,
) => RestoredInvoiceClientModel(
  id: (json['id'] as num?)?.toInt(),
  arabicName: json['arabicName'] as String?,
  latinName: json['latinName'] as String?,
);

Map<String, dynamic> _$RestoredInvoiceClientModelToJson(
  RestoredInvoiceClientModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'arabicName': instance.arabicName,
  'latinName': instance.latinName,
};

RestoredInvoiceItemModel _$RestoredInvoiceItemModelFromJson(
  Map<String, dynamic> json,
) => RestoredInvoiceItemModel(
  transactionId: (json['transactionId'] as num?)?.toInt(),
  parentTransactionId: (json['parentTransactionId'] as num?)?.toInt(),
  itemId: (json['itemId'] as num?)?.toInt(),
  itemArabicName: json['itemArabicName'] as String?,
  itemLatinName: json['itemLatinName'] as String?,
  itemImagePath: json['itemImagePath'] as String?,
  sizeId: (json['sizeId'] as num?)?.toInt(),
  sizeArabicName: json['sizeArabicName'] as String?,
  sizeLatinName: json['sizeLatinName'] as String?,
  quantity: (json['quantity'] as num?)?.toDouble(),
  price: (json['price'] as num?)?.toDouble(),
  notes: json['notes'] as String?,
  itemDiscount: json['itemDiscount'],
  additives: json['additives'] as List<dynamic>?,
  item: json['item'] == null
      ? null
      : RestoredInvoiceItemInfoModel.fromJson(
          json['item'] as Map<String, dynamic>,
        ),
  size: json['size'],
  additive: json['additive'],
  foodAdditiveId: (json['foodAdditiveId'] as num?)?.toInt(),
);

Map<String, dynamic> _$RestoredInvoiceItemModelToJson(
  RestoredInvoiceItemModel instance,
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

RestoredInvoiceItemInfoModel _$RestoredInvoiceItemInfoModelFromJson(
  Map<String, dynamic> json,
) => RestoredInvoiceItemInfoModel(
  id: (json['id'] as num?)?.toInt(),
  arabicName: json['arabicName'] as String?,
  latinName: json['latinName'] as String?,
);

Map<String, dynamic> _$RestoredInvoiceItemInfoModelToJson(
  RestoredInvoiceItemInfoModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'arabicName': instance.arabicName,
  'latinName': instance.latinName,
};

RestoredInvoicePaymentModel _$RestoredInvoicePaymentModelFromJson(
  Map<String, dynamic> json,
) => RestoredInvoicePaymentModel(
  paymentMethodId: (json['paymentMethodId'] as num?)?.toInt(),
  arabicName: json['arabicName'] as String?,
  latinName: json['latinName'] as String?,
  amount: (json['amount'] as num?)?.toDouble(),
  paymentMethod: json['paymentMethod'] == null
      ? null
      : RestoredInvoicePaymentMethodModel.fromJson(
          json['paymentMethod'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$RestoredInvoicePaymentModelToJson(
  RestoredInvoicePaymentModel instance,
) => <String, dynamic>{
  'paymentMethodId': instance.paymentMethodId,
  'arabicName': instance.arabicName,
  'latinName': instance.latinName,
  'amount': instance.amount,
  'paymentMethod': instance.paymentMethod,
};

RestoredInvoicePaymentMethodModel _$RestoredInvoicePaymentMethodModelFromJson(
  Map<String, dynamic> json,
) => RestoredInvoicePaymentMethodModel(
  id: (json['id'] as num?)?.toInt(),
  arabicName: json['arabicName'] as String?,
  latinName: json['latinName'] as String?,
);

Map<String, dynamic> _$RestoredInvoicePaymentMethodModelToJson(
  RestoredInvoicePaymentMethodModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'arabicName': instance.arabicName,
  'latinName': instance.latinName,
};

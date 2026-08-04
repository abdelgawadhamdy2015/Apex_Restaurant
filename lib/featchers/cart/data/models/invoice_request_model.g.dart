// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SaveInvoiceRequestModel _$SaveInvoiceRequestModelFromJson(
  Map<String, dynamic> json,
) => SaveInvoiceRequestModel(
  invoice: json['invoice'] == null
      ? null
      : SaveInvoiceModel.fromJson(json['invoice'] as Map<String, dynamic>),
  items: (json['items'] as List<dynamic>?)
      ?.map((e) => InvoiceItemModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  payments: (json['payments'] as List<dynamic>?)
      ?.map((e) => SavePaymentModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  gediaKey: json['gediaKey'] as String?,
);

Map<String, dynamic> _$SaveInvoiceRequestModelToJson(
  SaveInvoiceRequestModel instance,
) => <String, dynamic>{
  'invoice': instance.invoice?.toJson(),
  'items': instance.items?.map((e) => e.toJson()).toList(),
  'payments': instance.payments?.map((e) => e.toJson()).toList(),
  'gediaKey': instance.gediaKey,
};

SaveInvoiceModel _$SaveInvoiceModelFromJson(Map<String, dynamic> json) =>
    SaveInvoiceModel(
      postype: (json['postype'] as num?)?.toInt(),
      foodTableId: (json['foodTableId'] as num?)?.toInt(),
      waiterId: (json['waiterId'] as num?)?.toInt(),
      deliveryCompanyId: (json['deliveryCompanyId'] as num?)?.toInt(),
      deliveryManId: (json['deliveryManId'] as num?)?.toInt(),
      notes: json['notes'] as String?,
      discount: json['discount'] == null
          ? null
          : SaveDiscountModel.fromJson(
              json['discount'] as Map<String, dynamic>,
            ),
      paidAmount: (json['paidAmount'] as num?)?.toDouble(),
      totalInvoicePrice: (json['totalInvoicePrice'] as num?)?.toDouble(),
      clientId: (json['clientId'] as num?)?.toInt(),
      invoiceDiscountId: (json['invoiceDiscountId'] as num?)?.toInt(),
      takeawayDateTime: json['takeawayDateTime'] == null
          ? null
          : DateTime.parse(json['takeawayDateTime'] as String),
    );

Map<String, dynamic> _$SaveInvoiceModelToJson(SaveInvoiceModel instance) =>
    <String, dynamic>{
      'postype': instance.postype,
      'foodTableId': instance.foodTableId,
      'waiterId': instance.waiterId,
      'deliveryCompanyId': instance.deliveryCompanyId,
      'deliveryManId': instance.deliveryManId,
      'notes': instance.notes,
      'discount': instance.discount?.toJson(),
      'paidAmount': instance.paidAmount,
      'totalInvoicePrice': instance.totalInvoicePrice,
      'clientId': instance.clientId,
      'invoiceDiscountId': instance.invoiceDiscountId,
      'takeawayDateTime': instance.takeawayDateTime?.toIso8601String(),
    };

SaveDiscountModel _$SaveDiscountModelFromJson(Map<String, dynamic> json) =>
    SaveDiscountModel(
      type: (json['type'] as num?)?.toInt(),
      value: (json['value'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$SaveDiscountModelToJson(SaveDiscountModel instance) =>
    <String, dynamic>{'type': instance.type, 'value': instance.value};

InvoiceItemModel _$InvoiceItemModelFromJson(Map<String, dynamic> json) =>
    InvoiceItemModel(
      itemId: (json['itemId'] as num?)?.toInt(),
      sizeId: (json['sizeId'] as num?)?.toInt(),
      quantity: (json['quantity'] as num?)?.toDouble(),
      price: (json['price'] as num?)?.toDouble(),
      notes: json['notes'] as String?,
      discount: json['discount'] == null
          ? null
          : SaveDiscountModel.fromJson(
              json['discount'] as Map<String, dynamic>,
            ),
      itemDiscountId: (json['itemDiscountId'] as num?)?.toInt(),
      additives: (json['additives'] as List<dynamic>?)
          ?.map((e) => SaveAdditiveModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$InvoiceItemModelToJson(InvoiceItemModel instance) =>
    <String, dynamic>{
      'itemId': instance.itemId,
      'sizeId': instance.sizeId,
      'quantity': instance.quantity,
      'price': instance.price,
      'notes': instance.notes,
      'discount': instance.discount?.toJson(),
      'itemDiscountId': instance.itemDiscountId,
      'additives': instance.additives?.map((e) => e.toJson()).toList(),
    };

SaveAdditiveModel _$SaveAdditiveModelFromJson(Map<String, dynamic> json) =>
    SaveAdditiveModel(
      additiveId: (json['additiveId'] as num?)?.toInt(),
      quantity: (json['quantity'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$SaveAdditiveModelToJson(SaveAdditiveModel instance) =>
    <String, dynamic>{
      'additiveId': instance.additiveId,
      'quantity': instance.quantity,
    };

SavePaymentModel _$SavePaymentModelFromJson(Map<String, dynamic> json) =>
    SavePaymentModel(
      paymentMethodId: (json['paymentMethodId'] as num?)?.toInt(),
      amount: (json['amount'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$SavePaymentModelToJson(SavePaymentModel instance) =>
    <String, dynamic>{
      'paymentMethodId': instance.paymentMethodId,
      'amount': instance.amount,
    };

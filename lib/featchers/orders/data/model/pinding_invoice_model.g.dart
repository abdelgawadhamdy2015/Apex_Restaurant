// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pinding_invoice_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PindingInvoiceModel _$PindingInvoiceModelFromJson(Map<String, dynamic> json) =>
    PindingInvoiceModel(
      invoiceId: (json['invoiceId'] as num?)?.toInt(),
      orderNumber: (json['orderNumber'] as num?)?.toInt(),
      code: json['code'] as String?,
      invoiceDate: json['invoiceDate'] == null
          ? null
          : DateTime.parse(json['invoiceDate'] as String),
      itemsCount: (json['itemsCount'] as num?)?.toInt(),
      items: (json['items'] as List<dynamic>?)
          ?.map(
            (e) => PindingInvoiceItemModel.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      invoiceTotal: (json['invoiceTotal'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$PindingInvoiceModelToJson(
  PindingInvoiceModel instance,
) => <String, dynamic>{
  'invoiceId': instance.invoiceId,
  'orderNumber': instance.orderNumber,
  'code': instance.code,
  'invoiceDate': instance.invoiceDate?.toIso8601String(),
  'itemsCount': instance.itemsCount,
  'items': instance.items,
  'invoiceTotal': instance.invoiceTotal,
};

PindingInvoiceItemModel _$PindingInvoiceItemModelFromJson(
  Map<String, dynamic> json,
) => PindingInvoiceItemModel(
  itemId: (json['itemId'] as num?)?.toInt(),
  itemNameAr: json['itemNameAr'] as String?,
  quantity: (json['quantity'] as num?)?.toDouble(),
  price: (json['price'] as num?)?.toDouble(),
  total: (json['total'] as num?)?.toDouble(),
  itemNameEn: json['itemNameEn'] as String?,
);

Map<String, dynamic> _$PindingInvoiceItemModelToJson(
  PindingInvoiceItemModel instance,
) => <String, dynamic>{
  'itemId': instance.itemId,
  'itemNameAr': instance.itemNameAr,
  'quantity': instance.quantity,
  'price': instance.price,
  'total': instance.total,
  'itemNameEn': instance.itemNameEn,
};

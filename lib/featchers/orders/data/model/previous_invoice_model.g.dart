// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'previous_invoice_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PreviousInvoiceModel _$PreviousInvoiceModelFromJson(
  Map<String, dynamic> json,
) => PreviousInvoiceModel(
  invoiceId: (json['invoiceId'] as num?)?.toInt(),
  invoiceCode: json['invoiceCode'] as String?,
  invoiceDate: json['invoiceDate'] == null
      ? null
      : DateTime.parse(json['invoiceDate'] as String),
  personNameAr: json['personNameAr'] as String?,
  personNameEn: json['personNameEn'] as String?,
  totalAmount: (json['totalAmount'] as num?)?.toDouble(),
);

Map<String, dynamic> _$PreviousInvoiceModelToJson(
  PreviousInvoiceModel instance,
) => <String, dynamic>{
  'invoiceId': instance.invoiceId,
  'invoiceCode': instance.invoiceCode,
  'invoiceDate': instance.invoiceDate?.toIso8601String(),
  'personNameAr': instance.personNameAr,
  'personNameEn': instance.personNameEn,
  'totalAmount': instance.totalAmount,
};

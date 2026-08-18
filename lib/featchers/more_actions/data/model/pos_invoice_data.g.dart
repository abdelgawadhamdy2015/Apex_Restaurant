// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pos_invoice_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PosInvoiceData _$PosInvoiceDataFromJson(Map<String, dynamic> json) =>
    PosInvoiceData(
      invoiceId: (json['invoiceId'] as num).toInt(),
      isTransferDataToNewYear: json['isTransferDataToNewYear'] as bool,
      invoiceType: json['invoiceType'] as String,
      invoiceTypeId: (json['invoiceTypeId'] as num).toInt(),
      invoiceDate: DateTime.parse(json['invoiceDate'] as String),
      totalPrice: (json['totalPrice'] as num).toDouble(),
      discount: (json['discount'] as num).toDouble(),
      invoiceSubTypesId: (json['invoiceSubTypesId'] as num).toInt(),
      paymentType: (json['paymentType'] as num).toInt(),
      personNameAr: json['personNameAr'] as String,
      personNameEn: json['personNameEn'] as String,
      paid: (json['paid'] as num).toDouble(),
      reportStatus: (json['reportStatus'] as num).toInt(),
    );

Map<String, dynamic> _$PosInvoiceDataToJson(PosInvoiceData instance) =>
    <String, dynamic>{
      'invoiceId': instance.invoiceId,
      'isTransferDataToNewYear': instance.isTransferDataToNewYear,
      'invoiceType': instance.invoiceType,
      'invoiceTypeId': instance.invoiceTypeId,
      'invoiceDate': instance.invoiceDate.toIso8601String(),
      'totalPrice': instance.totalPrice,
      'discount': instance.discount,
      'invoiceSubTypesId': instance.invoiceSubTypesId,
      'paymentType': instance.paymentType,
      'personNameAr': instance.personNameAr,
      'personNameEn': instance.personNameEn,
      'paid': instance.paid,
      'reportStatus': instance.reportStatus,
    };

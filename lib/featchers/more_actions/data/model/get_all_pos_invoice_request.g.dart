// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_all_pos_invoice_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetAllPosInvoiceRequest _$GetAllPosInvoiceRequestFromJson(
  Map<String, dynamic> json,
) => GetAllPosInvoiceRequest(
  pageNumber: (json['pageNumber'] as num?)?.toInt() ?? 1,
  pageSize: (json['pageSize'] as num?)?.toInt() ?? 20,
  invoiceTypeId: (json['invoiceTypeId'] as num?)?.toInt() ?? 11,
  invoiceCode: (json['invoiceCode'] as num?)?.toInt() ?? 0,
  invoiceType: json['invoiceType'] as String?,
  invoiceDate: json['invoiceDate'] == null
      ? null
      : DateTime.parse(json['invoiceDate'] as String),
  dateFrom: json['dateFrom'] == null
      ? null
      : DateTime.parse(json['dateFrom'] as String),
  dateTo: json['dateTo'] == null
      ? null
      : DateTime.parse(json['dateTo'] as String),
  storeId: (json['storeId'] as num?)?.toInt() ?? 0,
  personId: (json['personId'] as num?)?.toInt() ?? 0,
  isReturn: json['isReturn'] as bool? ?? true,
  sessionId: (json['sessionId'] as num?)?.toInt() ?? 0,
  financialYearId: (json['financialYearId'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$GetAllPosInvoiceRequestToJson(
  GetAllPosInvoiceRequest instance,
) => <String, dynamic>{
  'pageNumber': instance.pageNumber,
  'pageSize': instance.pageSize,
  'invoiceTypeId': instance.invoiceTypeId,
  'invoiceCode': instance.invoiceCode,
  'invoiceType': ?instance.invoiceType,
  'invoiceDate': ?instance.invoiceDate?.toIso8601String(),
  'dateFrom': ?instance.dateFrom?.toIso8601String(),
  'dateTo': ?instance.dateTo?.toIso8601String(),
  'storeId': instance.storeId,
  'personId': instance.personId,
  'isReturn': instance.isReturn,
  'sessionId': instance.sessionId,
  'financialYearId': instance.financialYearId,
};

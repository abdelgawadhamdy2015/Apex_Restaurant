// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice_report_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InvoiceReportRequest _$InvoiceReportRequestFromJson(
  Map<String, dynamic> json,
) => InvoiceReportRequest(
  invoiceId: (json['invoiceId'] as num?)?.toInt(),
  invoiceCode: json['invoiceCode'] as String?,
  isPriceOffer: json['isPriceOffer'] as bool?,
  exportType: (json['exportType'] as num?)?.toInt() ?? 1,
  fileId: (json['fileId'] as num?)?.toInt(),
  financialYearId: (json['financialYearId'] as num?)?.toInt() ?? 1,
  subScreenId: (json['subScreenId'] as num?)?.toInt(),
  screenId: (json['screenId'] as num?)?.toInt() ?? 732,
  isArabic: json['isArabic'] as bool? ?? true,
  reportId: (json['reportId'] as num?)?.toInt(),
  invoiceTypeId: (json['invoiceTypeId'] as num?)?.toInt(),
);

Map<String, dynamic> _$InvoiceReportRequestToJson(
  InvoiceReportRequest instance,
) => <String, dynamic>{
  'invoiceId': ?instance.invoiceId,
  'invoiceCode': ?instance.invoiceCode,
  'isPriceOffer': ?instance.isPriceOffer,
  'exportType': ?instance.exportType,
  'fileId': ?instance.fileId,
  'financialYearId': ?instance.financialYearId,
  'subScreenId': ?instance.subScreenId,
  'screenId': ?instance.screenId,
  'isArabic': ?instance.isArabic,
  'reportId': ?instance.reportId,
  'invoiceTypeId': ?instance.invoiceTypeId,
};

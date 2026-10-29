// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice_report_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InvoiceReportResponse _$InvoiceReportResponseFromJson(
  Map<String, dynamic> json,
) => InvoiceReportResponse(
  result: json['result'],
  dataCount: (json['dataCount'] as num?)?.toInt(),
  data: json['data'],
  printingData: json['printingData'],
  alart: json['alart'] as String?,
  id: json['id'],
  code: json['code'],
  note: json['note'] as String?,
  totalCount: (json['totalCount'] as num?)?.toInt(),
  errors: json['errors'],
  errorMessageAr: json['errorMessageAr'] as String?,
  errorMessageEn: json['errorMessageEn'] as String?,
  total: (json['total'] as num?)?.toDouble(),
  dateTimeNow: json['dateTimeNow'] == null
      ? null
      : DateTime.parse(json['dateTimeNow'] as String),
  updateNumber: (json['updateNumber'] as num?)?.toInt(),
  isUpdate: (json['isUpdate'] as num?)?.toInt(),
  isPrint: json['isPrint'] as bool?,
  permissionListId: (json['permissionListId'] as num?)?.toInt(),
  employyeNameAr: json['employyeNameAr'] as String?,
  employyeNameEn: json['employyeNameEn'] as String?,
  posPrintFilesAr: json['posPrintFilesAr'],
  posPrintFilesEn: json['posPrintFilesEn'],
  returnPosPrintFilesAr: json['returnPosPrintFilesAr'],
  returnPosPrintFilesEn: json['returnPosPrintFilesEn'],
  isAuthorizedOnDashboardData: json['isAuthorizedOnDashboardData'] as bool?,
);

Map<String, dynamic> _$InvoiceReportResponseToJson(
  InvoiceReportResponse instance,
) => <String, dynamic>{
  'result': instance.result,
  'dataCount': instance.dataCount,
  'data': instance.data,
  'printingData': instance.printingData,
  'alart': instance.alart,
  'id': instance.id,
  'code': instance.code,
  'note': instance.note,
  'totalCount': instance.totalCount,
  'errors': instance.errors,
  'errorMessageAr': instance.errorMessageAr,
  'errorMessageEn': instance.errorMessageEn,
  'total': instance.total,
  'dateTimeNow': instance.dateTimeNow?.toIso8601String(),
  'updateNumber': instance.updateNumber,
  'isUpdate': instance.isUpdate,
  'isPrint': instance.isPrint,
  'permissionListId': instance.permissionListId,
  'employyeNameAr': instance.employyeNameAr,
  'employyeNameEn': instance.employyeNameEn,
  'posPrintFilesAr': instance.posPrintFilesAr,
  'posPrintFilesEn': instance.posPrintFilesEn,
  'returnPosPrintFilesAr': instance.returnPosPrintFilesAr,
  'returnPosPrintFilesEn': instance.returnPosPrintFilesEn,
  'isAuthorizedOnDashboardData': instance.isAuthorizedOnDashboardData,
};

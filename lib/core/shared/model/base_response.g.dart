// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BaseResponse<T> _$BaseResponseFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) => BaseResponse<T>(
  result: (json['result'] as num?)?.toInt(),
  dataCount: (json['dataCount'] as num?)?.toInt(),
  data: _$nullableGenericFromJson(json['data'], fromJsonT),
  printingData: json['printingData'],
  alert: json['alart'] == null
      ? null
      : AlertModel.fromJson(json['alart'] as Map<String, dynamic>),
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
  employeeNameAr: json['employyeNameAr'] as String?,
  employeeNameEn: json['employyeNameEn'] as String?,
  posPrintFilesAr: json['posPrintFilesAr'],
  posPrintFilesEn: json['posPrintFilesEn'],
  returnPosPrintFilesAr: json['returnPosPrintFilesAr'],
  returnPosPrintFilesEn: json['returnPosPrintFilesEn'],
  isAuthorizedOnDashboardData: json['isAuthorizedOnDashboardData'] as bool?,
);

Map<String, dynamic> _$BaseResponseToJson<T>(
  BaseResponse<T> instance,
  Object? Function(T value) toJsonT,
) => <String, dynamic>{
  'result': instance.result,
  'dataCount': instance.dataCount,
  'data': _$nullableGenericToJson(instance.data, toJsonT),
  'printingData': instance.printingData,
  'alart': instance.alert,
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
  'employyeNameAr': instance.employeeNameAr,
  'employyeNameEn': instance.employeeNameEn,
  'posPrintFilesAr': instance.posPrintFilesAr,
  'posPrintFilesEn': instance.posPrintFilesEn,
  'returnPosPrintFilesAr': instance.returnPosPrintFilesAr,
  'returnPosPrintFilesEn': instance.returnPosPrintFilesEn,
  'isAuthorizedOnDashboardData': instance.isAuthorizedOnDashboardData,
};

T? _$nullableGenericFromJson<T>(
  Object? input,
  T Function(Object? json) fromJson,
) => input == null ? null : fromJson(input);

Object? _$nullableGenericToJson<T>(
  T? input,
  Object? Function(T value) toJson,
) => input == null ? null : toJson(input);

AlertModel _$AlertModelFromJson(Map<String, dynamic> json) => AlertModel(
  alartType: (json['alartType'] as num?)?.toInt(),
  type: (json['type'] as num?)?.toInt(),
  titleAr: json['titleAr'] as String?,
  titleEn: json['titleEn'] as String?,
  messageAr: json['messageAr'] as String?,
  messageEn: json['messageEn'] as String?,
);

Map<String, dynamic> _$AlertModelToJson(AlertModel instance) =>
    <String, dynamic>{
      'alartType': instance.alartType,
      'type': instance.type,
      'titleAr': instance.titleAr,
      'titleEn': instance.titleEn,
      'messageAr': instance.messageAr,
      'messageEn': instance.messageEn,
    };

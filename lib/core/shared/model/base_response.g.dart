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
  data: _$nullableGenericFromJson(json['data'], fromJsonT),
  totalCount: (json['totalCount'] as num?)?.toInt(),
  errorMessageAr: json['errorMessageAr'] as String?,
  errorMessageEn: json['errorMessageEn'] as String?,
  alart: json['alart'] == null
      ? null
      : AlertModel.fromJson(json['alart'] as Map<String, dynamic>),
);

Map<String, dynamic> _$BaseResponseToJson<T>(
  BaseResponse<T> instance,
  Object? Function(T value) toJsonT,
) => <String, dynamic>{
  'result': instance.result,
  'data': _$nullableGenericToJson(instance.data, toJsonT),
  'totalCount': instance.totalCount,
  'errorMessageAr': instance.errorMessageAr,
  'errorMessageEn': instance.errorMessageEn,
  'alart': instance.alart,
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

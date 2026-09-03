// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'safe_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SafeModel _$SafeModelFromJson(Map<String, dynamic> json) => SafeModel(
  id: (json['id'] as num?)?.toInt(),
  latinName: json['latinName'] as String?,
  arabicName: json['arabicName'] as String?,
  code: (json['code'] as num?)?.toInt(),
);

Map<String, dynamic> _$SafeModelToJson(SafeModel instance) => <String, dynamic>{
  'id': instance.id,
  'latinName': instance.latinName,
  'arabicName': instance.arabicName,
  'code': instance.code,
};

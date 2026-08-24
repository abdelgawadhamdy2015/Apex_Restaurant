// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'waiter_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WaiterModel _$WaiterModelFromJson(Map<String, dynamic> json) => WaiterModel(
  id: (json['id'] as num?)?.toInt(),
  arabicName: json['arabicName'] as String?,
  latinName: json['latinName'] as String?,
  status: (json['status'] as num?)?.toInt(),
  code: (json['code'] as num?)?.toInt(),
);

Map<String, dynamic> _$WaiterModelToJson(WaiterModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'arabicName': instance.arabicName,
      'latinName': instance.latinName,
      'status': instance.status,
      'code': instance.code,
    };

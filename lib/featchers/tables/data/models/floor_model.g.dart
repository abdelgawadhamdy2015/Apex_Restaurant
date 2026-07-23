// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'floor_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FloorModel _$FloorModelFromJson(Map<String, dynamic> json) => FloorModel(
  id: json['id'] as String,
  code: (json['code'] as num).toInt(),
  arabicName: json['arabicName'] as String,
  latinName: json['latinName'] as String,
  notes: json['notes'] as String?,
  status: (json['status'] as num).toInt(),
  tableCount: (json['tableCount'] as num).toInt(),
  branchId: (json['branchId'] as num).toInt(),
  branchNameAr: json['branchNameAr'] as String,
  branchNameEn: json['branchNameEn'] as String,
);

Map<String, dynamic> _$FloorModelToJson(FloorModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'arabicName': instance.arabicName,
      'latinName': instance.latinName,
      'notes': instance.notes,
      'status': instance.status,
      'tableCount': instance.tableCount,
      'branchId': instance.branchId,
      'branchNameAr': instance.branchNameAr,
      'branchNameEn': instance.branchNameEn,
    };

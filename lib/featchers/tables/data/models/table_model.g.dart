// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TableModel _$TableModelFromJson(Map<String, dynamic> json) => TableModel(
  id: json['id'] as String?,
  code: (json['code'] as num?)?.toInt(),
  arabicName: json['arabicName'] as String?,
  latinName: json['latinName'] as String?,
  notes: json['notes'] as String?,
  status: $enumDecodeNullable(_$TableStatusEnumMap, json['status']),
  seatNumbers: (json['seatNumbers'] as num?)?.toInt(),
  tableTypeID: (json['tableTypeID'] as num?)?.toInt(),
  tableTypeNameAr: json['tableTypeNameAr'] as String?,
  tableTypeNameEn: json['tableTypeNameEn'] as String?,
  floorID: json['floorID'] as String?,
  floorNameAr: json['floorNameAr'] as String?,
  floorNameEn: json['floorNameEn'] as String?,
  uTime: json['uTime'] == null ? null : DateTime.parse(json['uTime'] as String),
  serviceRatio: (json['serviceRatio'] as num?)?.toDouble(),
  canDelete: json['canDelete'] as bool?,
  canEdit: json['canEdit'] as bool?,
  xloc: (json['xloc'] as num?)?.toDouble(),
  yloc: (json['yloc'] as num?)?.toDouble(),
  isReserved: json['isReserved'] as bool?,
);

Map<String, dynamic> _$TableModelToJson(TableModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'arabicName': instance.arabicName,
      'latinName': instance.latinName,
      'notes': instance.notes,
      'status': _$TableStatusEnumMap[instance.status],
      'seatNumbers': instance.seatNumbers,
      'tableTypeID': instance.tableTypeID,
      'tableTypeNameAr': instance.tableTypeNameAr,
      'tableTypeNameEn': instance.tableTypeNameEn,
      'floorID': instance.floorID,
      'floorNameAr': instance.floorNameAr,
      'floorNameEn': instance.floorNameEn,
      'uTime': instance.uTime?.toIso8601String(),
      'serviceRatio': instance.serviceRatio,
      'canDelete': instance.canDelete,
      'canEdit': instance.canEdit,
      'xloc': instance.xloc,
      'yloc': instance.yloc,
      'isReserved': instance.isReserved,
    };

const _$TableStatusEnumMap = {
  TableStatus.unAvailable: 0,
  TableStatus.available: 1,
  TableStatus.occupied: 2,
  TableStatus.reserved: 3,
  TableStatus.maintenance: 4,
};

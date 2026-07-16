// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TableModel _$TableModelFromJson(Map<String, dynamic> json) => TableModel(
  tableId: json['tableId'] as String?,
  arabicName: json['arabicName'] as String?,
  latinName: json['latinName'] as String?,
  status: $enumDecodeNullable(_$TableStatusEnumMap, json['status']),
  tableTypeId: (json['tableTypeId'] as num?)?.toInt(),
  tableTypeNameAr: json['tableTypeNameAr'] as String?,
  tableTypeNameEn: json['tableTypeNameEn'] as String?,
  isReserved: json['isReserved'] as bool?,
  locationX: (json['locationX'] as num?)?.toInt(),
  locationY: (json['locationY'] as num?)?.toInt(),
  reservationCustomerAr: json['reservationCustomer_ar'] as String?,
  reservationCustomerEn: json['reservationCustomer_en'] as String?,
  reservationStartTime: json['reservationStartTime'] as String?,
  reservationEndTime: json['reservationEndTime'] as String?,
);

Map<String, dynamic> _$TableModelToJson(TableModel instance) =>
    <String, dynamic>{
      'tableId': instance.tableId,
      'arabicName': instance.arabicName,
      'latinName': instance.latinName,
      'status': _$TableStatusEnumMap[instance.status],
      'tableTypeId': instance.tableTypeId,
      'tableTypeNameAr': instance.tableTypeNameAr,
      'tableTypeNameEn': instance.tableTypeNameEn,
      'isReserved': instance.isReserved,
      'locationX': instance.locationX,
      'locationY': instance.locationY,
      'reservationCustomer_ar': instance.reservationCustomerAr,
      'reservationCustomer_en': instance.reservationCustomerEn,
      'reservationStartTime': instance.reservationStartTime,
      'reservationEndTime': instance.reservationEndTime,
    };

const _$TableStatusEnumMap = {
  TableStatus.unAvailable: 0,
  TableStatus.available: 1,
  TableStatus.occupied: 2,
  TableStatus.reserved: 3,
  TableStatus.maintenance: 4,
};

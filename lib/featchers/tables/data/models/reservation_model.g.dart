// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReservationModel _$ReservationModelFromJson(Map<String, dynamic> json) =>
    ReservationModel(
      id: json['id'] as String?,
      tableId: json['tableId'] as String?,
      tableNameAr: json['tableName_ar'] as String?,
      tableNameEn: json['tableName_en'] as String?,
      date: json['date'] as String?,
      time: json['time'] as String?,
      customerId: json['customerId'] as String?,
      customerNameAr: json['customerName_ar'] as String?,
      customerNameEn: json['customerName_en'] as String?,
      seatsCount: (json['seatsCount'] as num?)?.toInt(),
      duration: (json['duration'] as num?)?.toInt(),
      statusCode: (json['statusCode'] as num?)?.toInt(),
      statusNameAr: json['statusName_ar'] as String?,
      statusNameEn: json['statusName_en'] as String?,
      canEdit: json['canEdit'] as bool?,
      canCancel: json['canCancel'] as bool?,
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$ReservationModelToJson(ReservationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tableId': instance.tableId,
      'tableName_ar': instance.tableNameAr,
      'tableName_en': instance.tableNameEn,
      'date': instance.date,
      'time': instance.time,
      'customerId': instance.customerId,
      'customerName_ar': instance.customerNameAr,
      'customerName_en': instance.customerNameEn,
      'seatsCount': instance.seatsCount,
      'duration': instance.duration,
      'statusCode': instance.statusCode,
      'statusName_ar': instance.statusNameAr,
      'statusName_en': instance.statusNameEn,
      'canEdit': instance.canEdit,
      'canCancel': instance.canCancel,
      'notes': instance.notes,
    };

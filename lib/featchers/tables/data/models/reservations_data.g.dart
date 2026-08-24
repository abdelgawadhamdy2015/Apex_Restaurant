// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservations_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReservationsData _$ReservationsDataFromJson(Map<String, dynamic> json) =>
    ReservationsData(
      allCount: (json['allCount'] as num?)?.toInt(),
      waitingCount: (json['waitingCount'] as num?)?.toInt(),
      confirmedCount: (json['confirmedCount'] as num?)?.toInt(),
      canceledCount: (json['canceledCount'] as num?)?.toInt(),
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => ReservationModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ReservationsDataToJson(ReservationsData instance) =>
    <String, dynamic>{
      'allCount': instance.allCount,
      'waitingCount': instance.waitingCount,
      'confirmedCount': instance.confirmedCount,
      'canceledCount': instance.canceledCount,
      'data': instance.data,
    };

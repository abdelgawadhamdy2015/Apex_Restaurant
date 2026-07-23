// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservation_requests.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReserveFoodTableRequest _$ReserveFoodTableRequestFromJson(
  Map<String, dynamic> json,
) => ReserveFoodTableRequest(
  foodTablesId: json['foodTablesID'] as String?,
  customerId: (json['CustomerID'] as num?)?.toInt(),
  reservationDate: json['ReservationDate'] as String?,
  reservationPeriod: (json['ReservationPeriod'] as num?)?.toInt(),
  seatsCount: (json['SeatsCount'] as num?)?.toInt(),
  notes: json['Notes'] as String?,
);

Map<String, dynamic> _$ReserveFoodTableRequestToJson(
  ReserveFoodTableRequest instance,
) => <String, dynamic>{
  'foodTablesID': instance.foodTablesId,
  'CustomerID': instance.customerId,
  'ReservationDate': instance.reservationDate,
  'ReservationPeriod': instance.reservationPeriod,
  'SeatsCount': instance.seatsCount,
  'Notes': instance.notes,
};

CancelReserveFoodTableRequest _$CancelReserveFoodTableRequestFromJson(
  Map<String, dynamic> json,
) => CancelReserveFoodTableRequest(
  reservationId: json['ReservationID'] as String?,
);

Map<String, dynamic> _$CancelReserveFoodTableRequestToJson(
  CancelReserveFoodTableRequest instance,
) => <String, dynamic>{'ReservationID': instance.reservationId};

EditReserveFoodTableRequest _$EditReserveFoodTableRequestFromJson(
  Map<String, dynamic> json,
) => EditReserveFoodTableRequest(
  foodTablesId: json['foodTablesID'] as String?,
  customerId: (json['CustomerID'] as num?)?.toInt(),
  reservationDate: json['ReservationDate'] as String?,
  reservationPeriod: (json['ReservationPeriod'] as num?)?.toInt(),
  seatsCount: (json['SeatsCount'] as num?)?.toInt(),
  notes: json['Notes'] as String?,
  reservationId: json['ReservationID'] as String?,
);

Map<String, dynamic> _$EditReserveFoodTableRequestToJson(
  EditReserveFoodTableRequest instance,
) => <String, dynamic>{
  'foodTablesID': instance.foodTablesId,
  'CustomerID': instance.customerId,
  'ReservationDate': instance.reservationDate,
  'ReservationPeriod': instance.reservationPeriod,
  'SeatsCount': instance.seatsCount,
  'Notes': instance.notes,
  'ReservationID': instance.reservationId,
};

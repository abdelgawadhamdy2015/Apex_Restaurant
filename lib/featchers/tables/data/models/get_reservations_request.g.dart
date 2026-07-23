// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_reservations_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetReservationRequest _$GetReservationRequestFromJson(
  Map<String, dynamic> json,
) => GetReservationRequest(
  pageNumber: (json['pageNumber'] as num?)?.toInt() ?? 1,
  pageSize: (json['pageSize'] as num?)?.toInt() ?? 20,
  foodTableName: json['foodTableName'] as String?,
  customerName: json['customerName'] as String?,
  dateFrom: json['datefrom'] as String?,
  dateTo: json['dateTo'] as String?,
  status: (json['status'] as num?)?.toInt(),
);

Map<String, dynamic> _$GetReservationRequestToJson(
  GetReservationRequest instance,
) => <String, dynamic>{
  'pageNumber': instance.pageNumber,
  'pageSize': instance.pageSize,
  'foodTableName': instance.foodTableName,
  'customerName': instance.customerName,
  'datefrom': instance.dateFrom,
  'dateTo': instance.dateTo,
  'status': instance.status,
};

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_delivery_companies_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetDeliveryCompaniesRequest _$GetDeliveryCompaniesRequestFromJson(
  Map<String, dynamic> json,
) => GetDeliveryCompaniesRequest(
  isActive: json['isActive'] as bool?,
  pageNumber: (json['pageNumber'] as num?)?.toInt(),
  pageSize: (json['pageSize'] as num?)?.toInt(),
);

Map<String, dynamic> _$GetDeliveryCompaniesRequestToJson(
  GetDeliveryCompaniesRequest instance,
) => <String, dynamic>{
  'pageNumber': ?instance.pageNumber,
  'pageSize': ?instance.pageSize,
  'isActive': ?instance.isActive,
};

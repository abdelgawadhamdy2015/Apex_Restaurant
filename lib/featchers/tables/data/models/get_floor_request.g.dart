// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_floor_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetFloorsRequest _$GetFloorsRequestFromJson(Map<String, dynamic> json) =>
    GetFloorsRequest(
      pageNumber: (json['pageNumber'] as num?)?.toInt() ?? 1,
      pageSize: (json['pageSize'] as num?)?.toInt() ?? 20,
      id: json['id'] as String?,
      name: json['name'] as String?,
      branchId: (json['branchId'] as num?)?.toInt(),
    );

Map<String, dynamic> _$GetFloorsRequestToJson(GetFloorsRequest instance) =>
    <String, dynamic>{
      'name': instance.name,
      'pageNumber': instance.pageNumber,
      'pageSize': instance.pageSize,
      'id': instance.id,
      'branchId': instance.branchId,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_table_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetTablesRequest _$GetTablesRequestFromJson(Map<String, dynamic> json) =>
    GetTablesRequest(
      pageNumber: (json['pageNumber'] as num?)?.toInt(),
      pageSize: (json['pageSize'] as num?)?.toInt(),
      id: json['id'] as String?,
      name: json['name'] as String?,
      floorID: json['floorID'] as String?,
      forPOS: json['forPOS'] as bool?,
    );

Map<String, dynamic> _$GetTablesRequestToJson(GetTablesRequest instance) =>
    <String, dynamic>{
      'name': instance.name,
      'pageNumber': instance.pageNumber,
      'pageSize': instance.pageSize,
      'id': instance.id,
      'floorID': instance.floorID,
      'forPOS': instance.forPOS,
    };

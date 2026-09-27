// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'open_restaurant_pos_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OpenSessionRequest _$OpenSessionRequestFromJson(Map<String, dynamic> json) =>
    OpenSessionRequest(
      safeId: (json['safeId'] as num?)?.toInt(),
      openingBalance: json['openingBalance'] as num?,
    );

Map<String, dynamic> _$OpenSessionRequestToJson(OpenSessionRequest instance) =>
    <String, dynamic>{
      'safeId': instance.safeId,
      'openingBalance': instance.openingBalance,
    };

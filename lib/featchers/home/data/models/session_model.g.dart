// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SessionModel _$SessionModelFromJson(Map<String, dynamic> json) => SessionModel(
  (json['id'] as num).toInt(),
  openingbalance: (json['openingbalance'] as num?)?.toInt(),
  openedAt: json['openedAt'] == null
      ? null
      : DateTime.parse(json['openedAt'] as String),
);

Map<String, dynamic> _$SessionModelToJson(SessionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'openingbalance': instance.openingbalance,
      'openedAt': instance.openedAt?.toIso8601String(),
    };

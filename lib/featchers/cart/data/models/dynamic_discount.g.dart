// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dynamic_discount.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DynamicDiscountModel _$DynamicDiscountModelFromJson(
  Map<String, dynamic> json,
) => DynamicDiscountModel(
  discount: json['discount'] == null
      ? null
      : DiscountModel.fromJson(json['discount'] as Map<String, dynamic>),
  posTypeId: (json['posTypeID'] as num?)?.toInt(),
);

Map<String, dynamic> _$DynamicDiscountModelToJson(
  DynamicDiscountModel instance,
) => <String, dynamic>{
  'discount': instance.discount?.toJson(),
  'posTypeID': instance.posTypeId,
};

DiscountModel _$DiscountModelFromJson(Map<String, dynamic> json) =>
    DiscountModel(
      id: (json['id'] as num?)?.toInt(),
      code: (json['code'] as num?)?.toInt(),
      arabicName: json['arabicName'] as String?,
      latinName: json['latinName'] as String?,
      startDate: json['startDate'] == null
          ? null
          : DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
      startTime: json['startTime'] == null
          ? null
          : DateTime.parse(json['startTime'] as String),
      endTime: json['endTime'] == null
          ? null
          : DateTime.parse(json['endTime'] as String),
      includeFoodAdditions: json['includeFoodAdditions'] as bool?,
      discountType: (json['discountType'] as num?)?.toInt(),
      discountNatural: (json['discountNatural'] as num?)?.toInt(),
      discountValue: (json['discountValue'] as num?)?.toDouble(),
      maxDiscountValue: (json['maxDiscountValue'] as num?)?.toDouble(),
      minInvoiceNET: (json['minInvoiceNET'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$DiscountModelToJson(DiscountModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'arabicName': instance.arabicName,
      'latinName': instance.latinName,
      'startDate': instance.startDate?.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
      'startTime': instance.startTime?.toIso8601String(),
      'endTime': instance.endTime?.toIso8601String(),
      'includeFoodAdditions': instance.includeFoodAdditions,
      'discountType': instance.discountType,
      'discountNatural': instance.discountNatural,
      'discountValue': instance.discountValue,
      'maxDiscountValue': instance.maxDiscountValue,
      'minInvoiceNET': instance.minInvoiceNET,
    };

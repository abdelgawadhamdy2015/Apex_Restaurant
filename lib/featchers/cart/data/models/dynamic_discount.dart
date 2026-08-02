import 'package:json_annotation/json_annotation.dart';

part 'dynamic_discount.g.dart';

@JsonSerializable(explicitToJson: true)
class DynamicDiscountModel {
  final DiscountModel? discount;

  @JsonKey(name: 'posTypeID')
  final int? posTypeId;

  const DynamicDiscountModel({this.discount, this.posTypeId});

  factory DynamicDiscountModel.fromJson(Map<String, dynamic> json) =>
      _$DynamicDiscountModelFromJson(json);

  Map<String, dynamic> toJson() => _$DynamicDiscountModelToJson(this);
}

@JsonSerializable()
class DiscountModel {
  final int? id;
  final int? code;
  final String? arabicName;
  final String? latinName;
  final DateTime? startDate;
  final DateTime? endDate;
  final DateTime? startTime;
  final DateTime? endTime;
  final bool? includeFoodAdditions;
  final int? discountType;
  final int? discountNatural;
  final double? discountValue;
  final double? maxDiscountValue;
  final double? minInvoiceNET;

  const DiscountModel({
    this.id,
    this.code,
    this.arabicName,
    this.latinName,
    this.startDate,
    this.endDate,
    this.startTime,
    this.endTime,
    this.includeFoodAdditions,
    this.discountType,
    this.discountNatural,
    this.discountValue,
    this.maxDiscountValue,
    this.minInvoiceNET,
  });

  factory DiscountModel.fromJson(Map<String, dynamic> json) =>
      _$DiscountModelFromJson(json);

  Map<String, dynamic> toJson() => _$DiscountModelToJson(this);
}

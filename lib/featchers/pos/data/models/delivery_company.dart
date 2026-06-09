import 'package:json_annotation/json_annotation.dart';

part 'delivery_company.g.dart';

@JsonSerializable()
class DeliveryCompanyModel {
  final int? id;
  final int? code;
  final String? arabicName;
  final String? latinName;
  final String? phone;
  final String? city;
  final String? region;
  final String? country;
  final String? street;
  final String? buildingNumber;
  final String? address;
  final bool? canDelete;
  final int? commissionListId;
  final String? commissionArabicName;
  final String? commissionLatinName;
  final bool? isActive;

  const DeliveryCompanyModel({
    this.id,
    this.code,
    this.arabicName,
    this.latinName,
    this.phone,
    this.city,
    this.region,
    this.country,
    this.street,
    this.buildingNumber,
    this.address,
    this.canDelete,
    this.commissionListId,
    this.commissionArabicName,
    this.commissionLatinName,
    this.isActive,
  });

  factory DeliveryCompanyModel.fromJson(Map<String, dynamic> json) =>
      _$DeliveryCompanyModelFromJson(json);

  Map<String, dynamic> toJson() => _$DeliveryCompanyModelToJson(this);
}

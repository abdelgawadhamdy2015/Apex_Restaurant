// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery_company.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeliveryCompanyModel _$DeliveryCompanyModelFromJson(
  Map<String, dynamic> json,
) => DeliveryCompanyModel(
  id: (json['id'] as num?)?.toInt(),
  code: (json['code'] as num?)?.toInt(),
  arabicName: json['arabicName'] as String?,
  latinName: json['latinName'] as String?,
  phone: json['phone'] as String?,
  city: json['city'] as String?,
  region: json['region'] as String?,
  country: json['country'] as String?,
  street: json['street'] as String?,
  buildingNumber: json['buildingNumber'] as String?,
  address: json['address'] as String?,
  canDelete: json['canDelete'] as bool?,
  commissionListId: (json['commissionListId'] as num?)?.toInt(),
  commissionArabicName: json['commissionArabicName'] as String?,
  commissionLatinName: json['commissionLatinName'] as String?,
  isActive: json['isActive'] as bool?,
);

Map<String, dynamic> _$DeliveryCompanyModelToJson(
  DeliveryCompanyModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'code': instance.code,
  'arabicName': instance.arabicName,
  'latinName': instance.latinName,
  'phone': instance.phone,
  'city': instance.city,
  'region': instance.region,
  'country': instance.country,
  'street': instance.street,
  'buildingNumber': instance.buildingNumber,
  'address': instance.address,
  'canDelete': instance.canDelete,
  'commissionListId': instance.commissionListId,
  'commissionArabicName': instance.commissionArabicName,
  'commissionLatinName': instance.commissionLatinName,
  'isActive': instance.isActive,
};

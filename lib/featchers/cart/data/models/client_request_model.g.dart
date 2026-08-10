// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClientRequestModel _$ClientRequestModelFromJson(Map<String, dynamic> json) =>
    ClientRequestModel(
      id: (json['Id'] as num?)?.toInt(),
      name: json['Name'] as String?,
      addresses: (json['Addresses'] as List<dynamic>?)
          ?.map(
            (e) =>
                ClientRequestAddressModel.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      phones: (json['Phones'] as List<dynamic>?)
          ?.map(
            (e) => ClientRequestPhoneModel.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      branches: (json['Branches'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
    );

Map<String, dynamic> _$ClientRequestModelToJson(ClientRequestModel instance) =>
    <String, dynamic>{
      'Id': ?instance.id,
      'Name': ?instance.name,
      'Addresses': ?instance.addresses?.map((e) => e.toJson()).toList(),
      'Phones': ?instance.phones?.map((e) => e.toJson()).toList(),
      'Branches': ?instance.branches,
    };

ClientRequestAddressModel _$ClientRequestAddressModelFromJson(
  Map<String, dynamic> json,
) => ClientRequestAddressModel(
  id: (json['Id'] as num?)?.toInt(),
  city: json['City'] as String?,
  street: json['Street'] as String?,
  district: json['District'] as String?,
  buildingNo: json['BuildingNo'] as String?,
  floor: json['Floor'] as String?,
  apartmentNo: json['ApartmentNo'] as String?,
  landmark: json['Landmark'] as String?,
  isDefault: json['IsDefault'] as bool?,
);

Map<String, dynamic> _$ClientRequestAddressModelToJson(
  ClientRequestAddressModel instance,
) => <String, dynamic>{
  'Id': ?instance.id,
  'City': ?instance.city,
  'Street': ?instance.street,
  'District': ?instance.district,
  'BuildingNo': ?instance.buildingNo,
  'Floor': ?instance.floor,
  'ApartmentNo': ?instance.apartmentNo,
  'Landmark': ?instance.landmark,
  'IsDefault': ?instance.isDefault,
};

ClientRequestPhoneModel _$ClientRequestPhoneModelFromJson(
  Map<String, dynamic> json,
) => ClientRequestPhoneModel(
  id: (json['Id'] as num?)?.toInt(),
  phoneNumber: json['PhoneNumber'] as String?,
  isDefault: json['IsDefault'] as bool?,
  personsId: (json['PersonsId'] as num?)?.toInt(),
);

Map<String, dynamic> _$ClientRequestPhoneModelToJson(
  ClientRequestPhoneModel instance,
) => <String, dynamic>{
  'Id': ?instance.id,
  'PhoneNumber': ?instance.phoneNumber,
  'IsDefault': ?instance.isDefault,
  'PersonsId': ?instance.personsId,
};

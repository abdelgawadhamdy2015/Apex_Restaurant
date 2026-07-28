import 'package:json_annotation/json_annotation.dart';

part 'client_request_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ClientRequestModel {
  @JsonKey(name: 'Id')
  final int? id;

  @JsonKey(name: 'Name')
  final String? name;

  @JsonKey(name: 'Addresses')
  final List<ClientRequestAddressModel>? addresses;

  @JsonKey(name: 'Phones')
  final List<ClientRequestPhoneModel>? phones;

  @JsonKey(name: 'Branches')
  final List<int>? branches;

  const ClientRequestModel({
    this.id,
    this.name,
    this.addresses,
    this.phones,
    this.branches,
  });

  factory ClientRequestModel.fromJson(Map<String, dynamic> json) =>
      _$ClientRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$ClientRequestModelToJson(this);
}

@JsonSerializable()
class ClientRequestAddressModel {
  @JsonKey(name: 'Id')
  final int? id;

  @JsonKey(name: 'City')
  final String? city;

  @JsonKey(name: 'Street')
  final String? street;

  @JsonKey(name: 'District')
  final String? district;

  @JsonKey(name: 'BuildingNo')
  final String? buildingNo;

  @JsonKey(name: 'Floor')
  final String? floor;

  @JsonKey(name: 'ApartmentNo')
  final String? apartmentNo;

  @JsonKey(name: 'Landmark')
  final String? landmark;

  @JsonKey(name: 'IsDefault')
  final bool? isDefault;

  const ClientRequestAddressModel({
    this.id = 0,
    this.city,
    this.street,
    this.district,
    this.buildingNo,
    this.floor,
    this.apartmentNo,
    this.landmark,
    this.isDefault,
  });

  factory ClientRequestAddressModel.fromJson(Map<String, dynamic> json) =>
      _$ClientRequestAddressModelFromJson(json);

  Map<String, dynamic> toJson() => _$ClientRequestAddressModelToJson(this);
}

@JsonSerializable()
class ClientRequestPhoneModel {
  @JsonKey(name: 'Id')
  final int? id;

  @JsonKey(name: 'PhoneNumber')
  final String? phoneNumber;

  @JsonKey(name: 'IsDefault')
  final bool? isDefault;

  @JsonKey(name: 'PersonsId')
  final int? personsId;

  const ClientRequestPhoneModel({
    this.id = 0,
    this.phoneNumber,
    this.isDefault,
    this.personsId = 0,
  });

  factory ClientRequestPhoneModel.fromJson(Map<String, dynamic> json) =>
      _$ClientRequestPhoneModelFromJson(json);

  Map<String, dynamic> toJson() => _$ClientRequestPhoneModelToJson(this);
}

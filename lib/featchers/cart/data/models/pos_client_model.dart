import 'package:json_annotation/json_annotation.dart';

part 'pos_client_model.g.dart';

@JsonSerializable(explicitToJson: true)
class PosClientModel {
  final int id;
  final String? code;
  final String? arabicName;
  final String? latinName;
  final int? type;
  final int? status;
  final SalesManModel? salesManId;
  final String? responsibleAr;
  final String? responsibleEn;
  final int? customerActivity;
  final String? phone;
  final String? fax;
  final String? email;
  final String? taxNumber;
  final String? addressAr;
  final String? addressEn;
  final bool? addToAnotherList;
  final bool? isSupplier;
  final bool? isCustomerAndSupplier;
  final bool? mainTypeIsCustomer;
  final List<int>? branches;
  final String? branchNameAr;
  final String? branchNameEn;
  final double? creditLimit;
  final int? creditPeriod;
  final double? discountRatio;
  final int? salesPriceId;
  final int? lessSalesPriceId;
  final bool? canDelete;
  final String? buildingNumber;
  final String? streetName;
  final String? neighborhood;
  final String? city;
  final String? country;
  final String? postalNumber;
  final FinancialAccountModel? financialAccountId;
  final String? statusAr;
  final String? statusEn;
  final String? typeAr;
  final String? typeEn;
  final bool? isUsedInInvoices;
  final List<ClientAddressModel>? personAddress;
  final List<ClientPhoneModel>? personPhones;

  const PosClientModel({
    required this.id,
    this.code,
    this.arabicName,
    this.latinName,
    this.type,
    this.status,
    this.salesManId,
    this.responsibleAr,
    this.responsibleEn,
    this.customerActivity,
    this.phone,
    this.fax,
    this.email,
    this.taxNumber,
    this.addressAr,
    this.addressEn,
    this.addToAnotherList,
    this.isSupplier,
    this.isCustomerAndSupplier,
    this.mainTypeIsCustomer,
    this.branches,
    this.branchNameAr,
    this.branchNameEn,
    this.creditLimit,
    this.creditPeriod,
    this.discountRatio,
    this.salesPriceId,
    this.lessSalesPriceId,
    this.canDelete,
    this.buildingNumber,
    this.streetName,
    this.neighborhood,
    this.city,
    this.country,
    this.postalNumber,
    this.financialAccountId,
    this.statusAr,
    this.statusEn,
    this.typeAr,
    this.typeEn,
    this.isUsedInInvoices,
    this.personAddress,
    this.personPhones,
  });

  factory PosClientModel.fromJson(Map<String, dynamic> json) =>
      _$PosClientModelFromJson(json);

  Map<String, dynamic> toJson() => _$PosClientModelToJson(this);
}

@JsonSerializable()
class FinancialAccountModel {
  final int id;
  final String? arabicName;
  final String? latinName;

  const FinancialAccountModel({
    required this.id,
    this.arabicName,
    this.latinName,
  });

  factory FinancialAccountModel.fromJson(Map<String, dynamic> json) =>
      _$FinancialAccountModelFromJson(json);

  Map<String, dynamic> toJson() => _$FinancialAccountModelToJson(this);
}

@JsonSerializable()
class ClientAddressModel {
  final int id;
  final String? city;
  final String? street;
  final String? district;
  final String? buildingNo;
  final String? floor;
  final String? apartmentNo;
  final String? landmark;
  final bool? isDefault;

  const ClientAddressModel({
    required this.id,
    this.city,
    this.street,
    this.district,
    this.buildingNo,
    this.floor,
    this.apartmentNo,
    this.landmark,
    this.isDefault,
  });

  factory ClientAddressModel.fromJson(Map<String, dynamic> json) =>
      _$ClientAddressModelFromJson(json);

  Map<String, dynamic> toJson() => _$ClientAddressModelToJson(this);

  String get fullAddress {
    final addressParts = [
      buildingNo,
      street,
      district,
      city,
    ].where((part) => part != null && part.isNotEmpty).toList();

    return addressParts.join(', ');
  }
}

@JsonSerializable()
class ClientPhoneModel {
  final int id;
  final String? phoneNumber;
  final bool? isDefault;
  final int personsId;

  const ClientPhoneModel({
    required this.id,
    required this.phoneNumber,
    required this.isDefault,
    required this.personsId,
  });

  factory ClientPhoneModel.fromJson(Map<String, dynamic> json) =>
      _$ClientPhoneModelFromJson(json);

  Map<String, dynamic> toJson() => _$ClientPhoneModelToJson(this);
}

@JsonSerializable()
class SalesManModel {
  final int id;
  final String? arabicName;
  final String? latinName;

  const SalesManModel({
    required this.id,
    required this.arabicName,
    required this.latinName,
  });

  factory SalesManModel.fromJson(Map<String, dynamic> json) =>
      _$SalesManModelFromJson(json);

  Map<String, dynamic> toJson() => _$SalesManModelToJson(this);
}

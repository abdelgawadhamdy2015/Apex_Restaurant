// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pos_client_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PosClientModel _$PosClientModelFromJson(Map<String, dynamic> json) =>
    PosClientModel(
      id: (json['id'] as num).toInt(),
      code: json['code'] as String?,
      arabicName: json['arabicName'] as String?,
      latinName: json['latinName'] as String?,
      type: (json['type'] as num?)?.toInt(),
      status: (json['status'] as num?)?.toInt(),
      salesManId: json['salesManId'] == null
          ? null
          : SalesManModel.fromJson(json['salesManId'] as Map<String, dynamic>),
      responsibleAr: json['responsibleAr'] as String?,
      responsibleEn: json['responsibleEn'] as String?,
      customerActivity: (json['customerActivity'] as num?)?.toInt(),
      phone: json['phone'] as String?,
      fax: json['fax'] as String?,
      email: json['email'] as String?,
      taxNumber: json['taxNumber'] as String?,
      addressAr: json['addressAr'] as String?,
      addressEn: json['addressEn'] as String?,
      addToAnotherList: json['addToAnotherList'] as bool?,
      isSupplier: json['isSupplier'] as bool?,
      isCustomerAndSupplier: json['isCustomerAndSupplier'] as bool?,
      mainTypeIsCustomer: json['mainTypeIsCustomer'] as bool?,
      branches: (json['branches'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      branchNameAr: json['branchNameAr'] as String?,
      branchNameEn: json['branchNameEn'] as String?,
      creditLimit: (json['creditLimit'] as num?)?.toDouble(),
      creditPeriod: (json['creditPeriod'] as num?)?.toInt(),
      discountRatio: (json['discountRatio'] as num?)?.toDouble(),
      salesPriceId: (json['salesPriceId'] as num?)?.toInt(),
      lessSalesPriceId: (json['lessSalesPriceId'] as num?)?.toInt(),
      canDelete: json['canDelete'] as bool?,
      buildingNumber: json['buildingNumber'] as String?,
      streetName: json['streetName'] as String?,
      neighborhood: json['neighborhood'] as String?,
      city: json['city'] as String?,
      country: json['country'] as String?,
      postalNumber: json['postalNumber'] as String?,
      financialAccountId: json['financialAccountId'] == null
          ? null
          : FinancialAccountModel.fromJson(
              json['financialAccountId'] as Map<String, dynamic>,
            ),
      statusAr: json['statusAr'] as String?,
      statusEn: json['statusEn'] as String?,
      typeAr: json['typeAr'] as String?,
      typeEn: json['typeEn'] as String?,
      isUsedInInvoices: json['isUsedInInvoices'] as bool?,
      personAddress: (json['personAddress'] as List<dynamic>?)
          ?.map((e) => ClientAddressModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      personPhones: (json['personPhones'] as List<dynamic>?)
          ?.map((e) => ClientPhoneModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PosClientModelToJson(PosClientModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'arabicName': instance.arabicName,
      'latinName': instance.latinName,
      'type': instance.type,
      'status': instance.status,
      'salesManId': instance.salesManId?.toJson(),
      'responsibleAr': instance.responsibleAr,
      'responsibleEn': instance.responsibleEn,
      'customerActivity': instance.customerActivity,
      'phone': instance.phone,
      'fax': instance.fax,
      'email': instance.email,
      'taxNumber': instance.taxNumber,
      'addressAr': instance.addressAr,
      'addressEn': instance.addressEn,
      'addToAnotherList': instance.addToAnotherList,
      'isSupplier': instance.isSupplier,
      'isCustomerAndSupplier': instance.isCustomerAndSupplier,
      'mainTypeIsCustomer': instance.mainTypeIsCustomer,
      'branches': instance.branches,
      'branchNameAr': instance.branchNameAr,
      'branchNameEn': instance.branchNameEn,
      'creditLimit': instance.creditLimit,
      'creditPeriod': instance.creditPeriod,
      'discountRatio': instance.discountRatio,
      'salesPriceId': instance.salesPriceId,
      'lessSalesPriceId': instance.lessSalesPriceId,
      'canDelete': instance.canDelete,
      'buildingNumber': instance.buildingNumber,
      'streetName': instance.streetName,
      'neighborhood': instance.neighborhood,
      'city': instance.city,
      'country': instance.country,
      'postalNumber': instance.postalNumber,
      'financialAccountId': instance.financialAccountId?.toJson(),
      'statusAr': instance.statusAr,
      'statusEn': instance.statusEn,
      'typeAr': instance.typeAr,
      'typeEn': instance.typeEn,
      'isUsedInInvoices': instance.isUsedInInvoices,
      'personAddress': instance.personAddress?.map((e) => e.toJson()).toList(),
      'personPhones': instance.personPhones?.map((e) => e.toJson()).toList(),
    };

FinancialAccountModel _$FinancialAccountModelFromJson(
  Map<String, dynamic> json,
) => FinancialAccountModel(
  id: (json['id'] as num).toInt(),
  arabicName: json['arabicName'] as String?,
  latinName: json['latinName'] as String?,
);

Map<String, dynamic> _$FinancialAccountModelToJson(
  FinancialAccountModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'arabicName': instance.arabicName,
  'latinName': instance.latinName,
};

ClientAddressModel _$ClientAddressModelFromJson(Map<String, dynamic> json) =>
    ClientAddressModel(
      id: (json['id'] as num).toInt(),
      city: json['city'] as String?,
      street: json['street'] as String?,
      district: json['district'] as String?,
      buildingNo: json['buildingNo'] as String?,
      floor: json['floor'] as String?,
      apartmentNo: json['apartmentNo'] as String?,
      landmark: json['landmark'] as String?,
      isDefault: json['isDefault'] as bool?,
    );

Map<String, dynamic> _$ClientAddressModelToJson(ClientAddressModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'city': instance.city,
      'street': instance.street,
      'district': instance.district,
      'buildingNo': instance.buildingNo,
      'floor': instance.floor,
      'apartmentNo': instance.apartmentNo,
      'landmark': instance.landmark,
      'isDefault': instance.isDefault,
    };

ClientPhoneModel _$ClientPhoneModelFromJson(Map<String, dynamic> json) =>
    ClientPhoneModel(
      id: (json['id'] as num).toInt(),
      phoneNumber: json['phoneNumber'] as String?,
      isDefault: json['isDefault'] as bool?,
      personsId: (json['personsId'] as num).toInt(),
    );

Map<String, dynamic> _$ClientPhoneModelToJson(ClientPhoneModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'phoneNumber': instance.phoneNumber,
      'isDefault': instance.isDefault,
      'personsId': instance.personsId,
    };

SalesManModel _$SalesManModelFromJson(Map<String, dynamic> json) =>
    SalesManModel(
      id: (json['id'] as num).toInt(),
      arabicName: json['arabicName'] as String?,
      latinName: json['latinName'] as String?,
    );

Map<String, dynamic> _$SalesManModelToJson(SalesManModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'arabicName': instance.arabicName,
      'latinName': instance.latinName,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_invoice_accrediting_data_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetInvoiceAccreditingDataRequest _$GetInvoiceAccreditingDataRequestFromJson(
  Map<String, dynamic> json,
) => GetInvoiceAccreditingDataRequest(
  employeesId: (json['employeesId'] as num?)?.toInt(),
  username: json['username'] as String?,
  password: json['password'] as String?,
);

Map<String, dynamic> _$GetInvoiceAccreditingDataRequestToJson(
  GetInvoiceAccreditingDataRequest instance,
) => <String, dynamic>{
  'employeesId': ?instance.employeesId,
  'username': ?instance.username,
  'password': ?instance.password,
};

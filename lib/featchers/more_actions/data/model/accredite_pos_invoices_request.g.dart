// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'accredite_pos_invoices_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccreditePOSInvoicesRequest _$AccreditePOSInvoicesRequestFromJson(
  Map<String, dynamic> json,
) => AccreditePOSInvoicesRequest(
  employeesId: (json['employeesId'] as num?)?.toInt(),
  username: json['username'] as String?,
  password: json['password'] as String?,
  drawerCash: (json['DrawerCash'] as num?)?.toDouble(),
  createCashDeficitReceipt: json['CreateCashDeficitReceipt'] as bool?,
  printRecsWithSaving: json['PrintRecsWithSaving'] as bool?,
);

Map<String, dynamic> _$AccreditePOSInvoicesRequestToJson(
  AccreditePOSInvoicesRequest instance,
) => <String, dynamic>{
  'employeesId': ?instance.employeesId,
  'username': ?instance.username,
  'password': ?instance.password,
  'DrawerCash': ?instance.drawerCash,
  'CreateCashDeficitReceipt': ?instance.createCashDeficitReceipt,
  'PrintRecsWithSaving': ?instance.printRecsWithSaving,
};

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_cash_transaction_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddCashTransactionRequest _$AddCashTransactionRequestFromJson(
  Map<String, dynamic> json,
) => AddCashTransactionRequest(
  cashAmount: (json['cashAmount'] as num).toDouble(),
  signal: (json['signal'] as num).toInt(),
  employeesId: (json['employeesId'] as num).toInt(),
  notes: json['notes'] as String?,
);

Map<String, dynamic> _$AddCashTransactionRequestToJson(
  AddCashTransactionRequest instance,
) => <String, dynamic>{
  'cashAmount': instance.cashAmount,
  'signal': instance.signal,
  'employeesId': instance.employeesId,
  'notes': instance.notes,
};

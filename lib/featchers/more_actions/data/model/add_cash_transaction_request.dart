import 'package:json_annotation/json_annotation.dart';

part 'add_cash_transaction_request.g.dart';

@JsonSerializable()
class AddCashTransactionRequest {
  final double cashAmount;
  final int signal;
  final int employeesId;
  final String? notes;

  AddCashTransactionRequest({
    required this.cashAmount,
    required this.signal,
    required this.employeesId,
    this.notes,
  });

  factory AddCashTransactionRequest.fromJson(Map<String, dynamic> json) =>
      _$AddCashTransactionRequestFromJson(json);

  Map<String, dynamic> toJson() => _$AddCashTransactionRequestToJson(this);
}

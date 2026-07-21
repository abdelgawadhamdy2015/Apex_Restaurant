import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'payment_request_model.g.dart';

enum PaymentMethodType {
  cash,
  card,
  split,
  visa,
  bankTransfer,
  loyalty,
  voucher,
  credit,
}

@JsonSerializable()
class PaymentMethodAmount extends Equatable {
  final PaymentMethodType method;
  final double amount;
  final String? referenceNumber;

  const PaymentMethodAmount({
    required this.method,
    required this.amount,
    this.referenceNumber,
  });
  factory PaymentMethodAmount.fromJson(Map<String, dynamic> json) =>
      _$PaymentMethodAmountFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentMethodAmountToJson(this);
  @override
  List<Object?> get props => [method, amount, referenceNumber];
}

@JsonSerializable()
class ProcessPaymentRequest extends Equatable {
  final String orderId;
  final double totalAmount;
  final double paidAmount;
  final List<PaymentMethodAmount> paymentMethods;

  const ProcessPaymentRequest({
    required this.orderId,
    required this.totalAmount,
    required this.paidAmount,
    required this.paymentMethods,
  });

  factory ProcessPaymentRequest.fromJson(Map<String, dynamic> json) =>
      _$ProcessPaymentRequestFromJson(json);
  Map<String, dynamic> toJson() => _$ProcessPaymentRequestToJson(this);

  @override
  List<Object?> get props => [orderId, totalAmount, paidAmount, paymentMethods];
}

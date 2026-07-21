import 'package:apex_restaurant/featchers/payment/data/model/payment_request_model.dart';
import 'package:equatable/equatable.dart';

abstract class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object?> get props => [];
}

class ChangePaymentMethodEvent extends PaymentEvent {
  final PaymentMethodType method;
  const ChangePaymentMethodEvent(this.method);

  @override
  List<Object?> get props => [method];
}

class UpdatePaidAmountEvent extends PaymentEvent {
  final double amount;
  const UpdatePaidAmountEvent(this.amount);

  @override
  List<Object?> get props => [amount];
}

class UpdateReferenceNumberEvent extends PaymentEvent {
  final String refNumber;
  const UpdateReferenceNumberEvent(this.refNumber);

  @override
  List<Object?> get props => [refNumber];
}

class SubmitPaymentEvent extends PaymentEvent {
  final String orderId;
  const SubmitPaymentEvent(this.orderId);

  @override
  List<Object?> get props => [orderId];
}

import 'package:apex_restaurant/featchers/cart/data/models/invoice_request_model.dart';
import 'package:apex_restaurant/featchers/payment/data/model/payment_request_model.dart';
import 'package:equatable/equatable.dart';

abstract class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object?> get props => [];
}

class InitializePaymentEvent extends PaymentEvent {
  final double totalAmount;
  const InitializePaymentEvent({required this.totalAmount});

  @override
  List<Object?> get props => [totalAmount];
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

class UpdateSplitAmountEvent extends PaymentEvent {
  final int paymentMethodId;
  final double amount;

  const UpdateSplitAmountEvent({
    required this.paymentMethodId,
    required this.amount,
  });

  @override
  List<Object?> get props => [paymentMethodId, amount];
}

class SubmitPaymentEvent extends PaymentEvent {
  final SaveInvoiceRequestModel invoiceRequest;
  const SubmitPaymentEvent(this.invoiceRequest);

  @override
  List<Object?> get props => [invoiceRequest];
}

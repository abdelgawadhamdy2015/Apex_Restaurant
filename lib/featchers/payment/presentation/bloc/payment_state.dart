import 'package:apex_restaurant/featchers/payment/data/model/payment_request_model.dart';
import 'package:apex_restaurant/featchers/payment/data/model/payment_success_model.dart';
import 'package:equatable/equatable.dart';

enum PaymentStatus { initial, loading, success, error }

class PaymentState extends Equatable {
  final PaymentStatus status;
  final double totalAmount;
  final double paidAmount;
  final PaymentMethodType selectedMethod;
  final String referenceNumber;
  final PaymentSuccessModel? successModel;
  final String? errorMessage;

  const PaymentState({
    this.status = PaymentStatus.initial,
    this.totalAmount = 207.00,
    this.paidAmount = 210.00,
    this.selectedMethod = PaymentMethodType.cash,
    this.referenceNumber = '',
    this.successModel,
    this.errorMessage,
  });

  double get remainingAmount =>
      (paidAmount - totalAmount) > 0 ? (paidAmount - totalAmount) : 0.0;

  PaymentState copyWith({
    PaymentStatus? status,
    double? totalAmount,
    double? paidAmount,
    PaymentMethodType? selectedMethod,
    String? referenceNumber,
    PaymentSuccessModel? successModel,
    String? errorMessage,
  }) {
    return PaymentState(
      status: status ?? this.status,
      totalAmount: totalAmount ?? this.totalAmount,
      paidAmount: paidAmount ?? this.paidAmount,
      selectedMethod: selectedMethod ?? this.selectedMethod,
      referenceNumber: referenceNumber ?? this.referenceNumber,
      successModel: successModel ?? this.successModel,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    totalAmount,
    paidAmount,
    selectedMethod,
    referenceNumber,
    successModel,
    errorMessage,
  ];
}

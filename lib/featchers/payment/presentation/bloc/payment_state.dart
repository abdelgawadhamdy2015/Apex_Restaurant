import 'package:apex_restaurant/featchers/payment/data/model/payment_method_response_model.dart';

import '../../data/model/payment_request_model.dart';
import '../../data/model/payment_success_model.dart';
import '../../data/model/success_response_model.dart';
import 'package:equatable/equatable.dart';

enum PaymentStatus { initial, loading, success, paymentMethodLoaded, error }

class PaymentState extends Equatable {
  final PaymentStatus status;
  final double totalAmount;
  final double paidAmount;
  final PaymentMethodType selectedMethod;
  final String referenceNumber;
  final Map<int, double> splitAmounts;
  final PaymentSuccessModel? successModel;
  final SuccessResponseModel? successResponseModel;
  final String? errorMessage;
  final List<PaymentMethodResponseModel>? paymentMethods;
  const PaymentState({
    this.status = PaymentStatus.initial,
    this.totalAmount = 0.0,
    this.paidAmount = 0.0,
    this.selectedMethod = PaymentMethodType.cash,
    this.referenceNumber = '',
    this.splitAmounts = const {},
    this.successModel,
    this.errorMessage,
    this.successResponseModel,
    this.paymentMethods,
  });

  double get remainingAmount =>
      (paidAmount - totalAmount) > 0 ? (paidAmount - totalAmount) : 0.0;

  PaymentState copyWith({
    PaymentStatus? status,
    double? totalAmount,
    double? paidAmount,
    PaymentMethodType? selectedMethod,
    String? referenceNumber,
    Map<int, double>? splitAmounts,
    PaymentSuccessModel? successModel,
    SuccessResponseModel? successResponseModel,
    String? errorMessage,
    List<PaymentMethodResponseModel>? paymentMethods,
  }) {
    return PaymentState(
      status: status ?? this.status,
      totalAmount: totalAmount ?? this.totalAmount,
      paidAmount: paidAmount ?? this.paidAmount,
      selectedMethod: selectedMethod ?? this.selectedMethod,
      referenceNumber: referenceNumber ?? this.referenceNumber,
      splitAmounts: splitAmounts ?? this.splitAmounts,
      successModel: successModel ?? this.successModel,
      successResponseModel: successResponseModel ?? this.successResponseModel,
      errorMessage: errorMessage ?? this.errorMessage,
      paymentMethods: paymentMethods ?? this.paymentMethods,
    );
  }

  @override
  List<Object?> get props => [
    status,
    totalAmount,
    paidAmount,
    selectedMethod,
    referenceNumber,
    splitAmounts,
    successModel,
    errorMessage,
    paymentMethods,
    successResponseModel,
  ];
}

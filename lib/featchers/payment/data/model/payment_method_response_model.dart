import 'package:json_annotation/json_annotation.dart';

part 'payment_method_response_model.g.dart';

@JsonSerializable()
class PaymentMethodResponseModel {
  final int? paymentMethodId;
  final int? code;
  final String? arabicName;
  final String? latinName;
  final int? safeOrBankId;
  final String? safeOrBankNameAr;
  final String? safeOrBankNameEn;
  final int? status;
  final bool? allowPaymentMachine;
  final String? paymentMachineAr;
  final String? paymentMachineEn;
  final bool? canDelete;

  const PaymentMethodResponseModel({
    this.paymentMethodId,
    this.code,
    this.arabicName,
    this.latinName,
    this.safeOrBankId,
    this.safeOrBankNameAr,
    this.safeOrBankNameEn,
    this.status,
    this.allowPaymentMachine,
    this.paymentMachineAr,
    this.paymentMachineEn,
    this.canDelete,
  });

  factory PaymentMethodResponseModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentMethodResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentMethodResponseModelToJson(this);
}

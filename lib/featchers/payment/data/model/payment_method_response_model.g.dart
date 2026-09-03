// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_method_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentMethodResponseModel _$PaymentMethodResponseModelFromJson(
  Map<String, dynamic> json,
) => PaymentMethodResponseModel(
  paymentMethodId: (json['paymentMethodId'] as num?)?.toInt(),
  code: (json['code'] as num?)?.toInt(),
  arabicName: json['arabicName'] as String?,
  latinName: json['latinName'] as String?,
  safeOrBankId: (json['safeOrBankId'] as num?)?.toInt(),
  safeOrBankNameAr: json['safeOrBankNameAr'] as String?,
  safeOrBankNameEn: json['safeOrBankNameEn'] as String?,
  status: (json['status'] as num?)?.toInt(),
  allowPaymentMachine: json['allowPaymentMachine'] as bool?,
  paymentMachineAr: json['paymentMachineAr'] as String?,
  paymentMachineEn: json['paymentMachineEn'] as String?,
  canDelete: json['canDelete'] as bool?,
);

Map<String, dynamic> _$PaymentMethodResponseModelToJson(
  PaymentMethodResponseModel instance,
) => <String, dynamic>{
  'paymentMethodId': instance.paymentMethodId,
  'code': instance.code,
  'arabicName': instance.arabicName,
  'latinName': instance.latinName,
  'safeOrBankId': instance.safeOrBankId,
  'safeOrBankNameAr': instance.safeOrBankNameAr,
  'safeOrBankNameEn': instance.safeOrBankNameEn,
  'status': instance.status,
  'allowPaymentMachine': instance.allowPaymentMachine,
  'paymentMachineAr': instance.paymentMachineAr,
  'paymentMachineEn': instance.paymentMachineEn,
  'canDelete': instance.canDelete,
};

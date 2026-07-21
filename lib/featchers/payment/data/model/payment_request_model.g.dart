// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentMethodAmount _$PaymentMethodAmountFromJson(Map<String, dynamic> json) =>
    PaymentMethodAmount(
      method: $enumDecode(_$PaymentMethodTypeEnumMap, json['method']),
      amount: (json['amount'] as num).toDouble(),
      referenceNumber: json['referenceNumber'] as String?,
    );

Map<String, dynamic> _$PaymentMethodAmountToJson(
  PaymentMethodAmount instance,
) => <String, dynamic>{
  'method': _$PaymentMethodTypeEnumMap[instance.method]!,
  'amount': instance.amount,
  'referenceNumber': instance.referenceNumber,
};

const _$PaymentMethodTypeEnumMap = {
  PaymentMethodType.cash: 'cash',
  PaymentMethodType.card: 'card',
  PaymentMethodType.split: 'split',
  PaymentMethodType.visa: 'visa',
  PaymentMethodType.bankTransfer: 'bankTransfer',
  PaymentMethodType.loyalty: 'loyalty',
  PaymentMethodType.voucher: 'voucher',
  PaymentMethodType.credit: 'credit',
};

ProcessPaymentRequest _$ProcessPaymentRequestFromJson(
  Map<String, dynamic> json,
) => ProcessPaymentRequest(
  orderId: json['orderId'] as String,
  totalAmount: (json['totalAmount'] as num).toDouble(),
  paidAmount: (json['paidAmount'] as num).toDouble(),
  paymentMethods: (json['paymentMethods'] as List<dynamic>)
      .map((e) => PaymentMethodAmount.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ProcessPaymentRequestToJson(
  ProcessPaymentRequest instance,
) => <String, dynamic>{
  'orderId': instance.orderId,
  'totalAmount': instance.totalAmount,
  'paidAmount': instance.paidAmount,
  'paymentMethods': instance.paymentMethods,
};

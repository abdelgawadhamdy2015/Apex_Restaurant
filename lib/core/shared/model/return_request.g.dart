// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'return_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReturnRequest _$ReturnRequestFromJson(Map<String, dynamic> json) =>
    ReturnRequest(
      originalInvoiceId: (json['OriginalInvoiceId'] as num).toInt(),
      financialYearId: (json['FinancialYearId'] as num?)?.toInt() ?? 1,
      reason: json['Reason'] as String?,
      notes: json['Notes'] as String?,
      canPrint: json['CanPrint'] as bool?,
      isArabic: json['IsArabic'] as bool? ?? true,
      totalInvoicePrice: (json['TotalInvoicePrice'] as num?)?.toDouble(),
      isTotalReturn: json['IsTotalReturn'] as bool?,
      returnedInvoiceItems: (json['ReturnedInvoiceItems'] as List<dynamic>?)
          ?.map((e) => ReturnedInvoiceItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      paymentMethods: (json['PaymentMethods'] as List<dynamic>?)
          ?.map((e) => PaymentMethod.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ReturnRequestToJson(ReturnRequest instance) =>
    <String, dynamic>{
      'OriginalInvoiceId': instance.originalInvoiceId,
      'FinancialYearId': ?instance.financialYearId,
      'Reason': ?instance.reason,
      'Notes': ?instance.notes,
      'CanPrint': ?instance.canPrint,
      'IsArabic': ?instance.isArabic,
      'TotalInvoicePrice': ?instance.totalInvoicePrice,
      'IsTotalReturn': ?instance.isTotalReturn,
      'ReturnedInvoiceItems': ?instance.returnedInvoiceItems,
      'PaymentMethods': ?instance.paymentMethods,
    };

ReturnedInvoiceItem _$ReturnedInvoiceItemFromJson(Map<String, dynamic> json) =>
    ReturnedInvoiceItem(
      invoiceDetailId: (json['InvoiceDetailId'] as num).toInt(),
      quantity: (json['Quantity'] as num).toDouble(),
    );

Map<String, dynamic> _$ReturnedInvoiceItemToJson(
  ReturnedInvoiceItem instance,
) => <String, dynamic>{
  'InvoiceDetailId': instance.invoiceDetailId,
  'Quantity': instance.quantity,
};

PaymentMethod _$PaymentMethodFromJson(Map<String, dynamic> json) =>
    PaymentMethod(
      paymentMethodId: (json['PaymentMethodId'] as num?)?.toInt(),
      value: (json['Value'] as num?)?.toDouble(),
      cheque: json['Cheque'] as String? ?? '',
    );

Map<String, dynamic> _$PaymentMethodToJson(PaymentMethod instance) =>
    <String, dynamic>{
      'PaymentMethodId': ?instance.paymentMethodId,
      'Value': ?instance.value,
      'Cheque': ?instance.cheque,
    };

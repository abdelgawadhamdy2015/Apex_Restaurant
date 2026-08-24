// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_success_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderItemModel _$OrderItemModelFromJson(Map<String, dynamic> json) =>
    OrderItemModel(
      name: json['name'] as String,
      quantity: (json['quantity'] as num).toInt(),
      price: (json['price'] as num).toDouble(),
    );

Map<String, dynamic> _$OrderItemModelToJson(OrderItemModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'quantity': instance.quantity,
      'price': instance.price,
    };

PaymentSuccessModel _$PaymentSuccessModelFromJson(Map<String, dynamic> json) =>
    PaymentSuccessModel(
      orderNumber: json['orderNumber'] as String,
      invoiceNumber: json['invoiceNumber'] as String,
      totalPaid: (json['totalPaid'] as num).toDouble(),
      paymentMethodName: json['paymentMethodName'] as String,
      transactionTime: DateTime.parse(json['transactionTime'] as String),
      items: (json['items'] as List<dynamic>)
          .map((e) => OrderItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PaymentSuccessModelToJson(
  PaymentSuccessModel instance,
) => <String, dynamic>{
  'orderNumber': instance.orderNumber,
  'invoiceNumber': instance.invoiceNumber,
  'totalPaid': instance.totalPaid,
  'paymentMethodName': instance.paymentMethodName,
  'transactionTime': instance.transactionTime.toIso8601String(),
  'items': instance.items,
};

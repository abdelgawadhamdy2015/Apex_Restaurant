import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'payment_success_model.g.dart';

@JsonSerializable()
class OrderItemModel extends Equatable {
  final String name;
  final int quantity;
  final double price;

  const OrderItemModel({
    required this.name,
    required this.quantity,
    required this.price,
  });
  factory OrderItemModel.fromJson(Map<String, dynamic> json) =>
      _$OrderItemModelFromJson(json);
  Map<String, dynamic> toJson() => _$OrderItemModelToJson(this);
  @override
  List<Object?> get props => [name, quantity, price];
}

@JsonSerializable()
class PaymentSuccessModel extends Equatable {
  final String orderNumber;
  final String invoiceNumber;
  final double totalPaid;
  final String paymentMethodName;
  final DateTime transactionTime;
  final List<OrderItemModel> items;

  const PaymentSuccessModel({
    required this.orderNumber,
    required this.invoiceNumber,
    required this.totalPaid,
    required this.paymentMethodName,
    required this.transactionTime,
    required this.items,
  });

  factory PaymentSuccessModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentSuccessModelFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentSuccessModelToJson(this);
  @override
  List<Object?> get props => [
    orderNumber,
    invoiceNumber,
    totalPaid,
    paymentMethodName,
    transactionTime,
    items,
  ];
}

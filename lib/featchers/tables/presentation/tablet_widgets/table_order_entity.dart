import 'package:equatable/equatable.dart';

import 'order_item_entity.dart';

class TableOrderEntity extends Equatable {
  final String orderNumber;
  final String invoiceNumber;
  final DateTime date;
  final List<OrderItemEntity> items;
  final double discountAmount;
  final String? couponCode;
  final double vatPercentage;
  final double vatAmount;

  const TableOrderEntity({
    required this.orderNumber,
    required this.invoiceNumber,
    required this.date,
    this.items = const [],
    this.discountAmount = 0,
    this.couponCode,
    this.vatPercentage = 15,
    this.vatAmount = 0,
  });

  /// An empty order used when a table has no invoice yet
  /// (e.g. tapping an available table to start a new one).
  factory TableOrderEntity.empty() => TableOrderEntity(
    orderNumber: '',
    invoiceNumber: '',
    date: DateTime.now(),
  );

  bool get isEmpty => items.isEmpty;

  double get subtotal => items.fold(0, (sum, item) => sum + item.totalPrice);

  double get total => subtotal - discountAmount + vatAmount;

  TableOrderEntity copyWith({
    List<OrderItemEntity>? items,
    double? discountAmount,
    String? couponCode,
    double? vatAmount,
  }) {
    return TableOrderEntity(
      orderNumber: orderNumber,
      invoiceNumber: invoiceNumber,
      date: date,
      items: items ?? this.items,
      discountAmount: discountAmount ?? this.discountAmount,
      couponCode: couponCode ?? this.couponCode,
      vatPercentage: vatPercentage,
      vatAmount: vatAmount ?? this.vatAmount,
    );
  }

  @override
  List<Object?> get props => [
    orderNumber,
    invoiceNumber,
    date,
    items,
    discountAmount,
    couponCode,
    vatPercentage,
    vatAmount,
  ];
}

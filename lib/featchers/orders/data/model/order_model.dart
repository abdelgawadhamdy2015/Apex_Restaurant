import '../../../payment/data/model/payment_success_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'order_model.g.dart';

enum OrderTab { previous, held }

@JsonSerializable()
class OrderModel {
  final String id;
  final String invoiceNumber;
  final String? orderQueueNumber;
  final String? customerName;
  final DateTime dateTime;
  final double totalAmount;
  final int itemsCount;
  final List<OrderItemModel> items;
  final bool isHeld;

  const OrderModel({
    required this.id,
    required this.invoiceNumber,
    this.orderQueueNumber,
    this.customerName,
    required this.dateTime,
    required this.totalAmount,
    required this.itemsCount,
    this.items = const [],
    this.isHeld = false,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) =>
      _$OrderModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderModelToJson(this);
}

class OrderFilterModel {
  final String? invoiceNumber;
  final String? customerName;
  final DateTime? fromDate;
  final DateTime? toDate;

  const OrderFilterModel({
    this.invoiceNumber,
    this.customerName,
    this.fromDate,
    this.toDate,
  });
}

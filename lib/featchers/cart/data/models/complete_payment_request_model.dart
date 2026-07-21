import 'package:apex_restaurant/featchers/cart/data/enums/cart_enum.dart';
import 'package:apex_restaurant/featchers/pos/domain/entities/menu_item.dart';

class CompletePaymentRequestModel {
  const CompletePaymentRequestModel({
    required this.order,
    required this.orderType,
    required this.paymentMethod,
    required this.subtotal,
    required this.discountAmount,
    required this.vatAmount,
    required this.totalAmount,
    this.deliveryFee,
    this.tableId,
    this.waiterId,
    this.deliveryAgentId,
    this.deliveryCompanyId,
    this.discountCode,
  });

  final Order order;
  final CartOrderType orderType;
  final PaymentMethod paymentMethod;

  final double subtotal;
  final double discountAmount;
  final double vatAmount;
  final double totalAmount;
  final double? deliveryFee;

  final String? tableId;
  final int? waiterId;
  final int? deliveryAgentId;
  final int? deliveryCompanyId;
  final String? discountCode;

  Map<String, dynamic> toJson() => {
    'items': order.items
        .map((i) => {'itemId': i.menuItem.itemId, 'quantity': i.quantity})
        .toList(),
    'orderType': orderType.apiValue,
    'paymentMethod': paymentMethod.name,
    'subtotal': subtotal,
    'discountAmount': discountAmount,
    'vatAmount': vatAmount,
    'totalAmount': totalAmount,
    if (deliveryFee != null) 'deliveryFee': deliveryFee,
    if (tableId != null) 'tableId': tableId,
    if (waiterId != null) 'waiterId': waiterId,
    if (deliveryAgentId != null) 'deliveryAgentId': deliveryAgentId,
    if (deliveryCompanyId != null) 'deliveryCompanyId': deliveryCompanyId,
    if (discountCode != null) 'discountCode': discountCode,
  };
}

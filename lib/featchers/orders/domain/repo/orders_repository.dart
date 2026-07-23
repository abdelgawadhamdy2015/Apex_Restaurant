import 'package:apex_restaurant/featchers/orders/data/model/order_model.dart';

abstract class OrdersRepository {
  Future<List<OrderModel>> getPreviousOrders(OrderFilterModel? filter);
  Future<List<OrderModel>> getHeldOrders();
  Future<void> restoreHeldOrder(String orderId);
  Future<void> deleteHeldOrder(String orderId);
}

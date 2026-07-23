import 'package:apex_restaurant/featchers/orders/data/model/order_model.dart';

abstract class OrdersEvent {}

class SwitchTabEvent extends OrdersEvent {
  final OrderTab tab;
  SwitchTabEvent(this.tab);
}

class FetchOrdersEvent extends OrdersEvent {
  final OrderFilterModel? filter;
  FetchOrdersEvent({this.filter});
}

class RestoreOrderEvent extends OrdersEvent {
  final String orderId;
  RestoreOrderEvent(this.orderId);
}

class DeleteOrderEvent extends OrdersEvent {
  final String orderId;
  DeleteOrderEvent(this.orderId);
}

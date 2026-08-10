import 'package:apex_restaurant/featchers/orders/data/model/get_pinding_invoice.dart';
import 'package:apex_restaurant/featchers/orders/data/model/get_previous_invoice_request.dart';
import 'package:apex_restaurant/featchers/orders/data/model/order_model.dart';
import 'package:equatable/equatable.dart';

abstract class OrdersEvent extends Equatable {
  const OrdersEvent();

  @override
  List<Object?> get props => [];
}

class SwitchTabEvent extends OrdersEvent {
  final OrderTab tab;
  const SwitchTabEvent(this.tab);
}

class FetchPindingInvoicesEvent extends OrdersEvent {
  final GetPindingInvoicesRequest? request;
  const FetchPindingInvoicesEvent({this.request});
}

class FetchPreviousInvoicesEvent extends OrdersEvent {
  final GetPreviousInvoiceRequest request;
  const FetchPreviousInvoicesEvent({required this.request});
}

class FetchRestaurantPosBookingTableEvent extends OrdersEvent {
  final GetPindingInvoicesRequest? request;
  const FetchRestaurantPosBookingTableEvent({this.request});
}

class RestoreOrderEvent extends OrdersEvent {
  final String orderId;
  const RestoreOrderEvent(this.orderId);
}

class DeleteOrderEvent extends OrdersEvent {
  final String orderId;
  const DeleteOrderEvent(this.orderId);
}

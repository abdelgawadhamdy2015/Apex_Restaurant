import '../../data/model/get_pinding_invoice.dart';
import '../../data/model/get_previous_invoice_request.dart';
import '../../data/model/order_model.dart';
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

/// Fetches the next page of held/pending orders and appends it.
class LoadMorePindingInvoicesEvent extends OrdersEvent {
  const LoadMorePindingInvoicesEvent();
}

class ClearRestoredInvoiceEvent extends OrdersEvent {
  const ClearRestoredInvoiceEvent();
}

class FetchPreviousInvoicesEvent extends OrdersEvent {
  final GetPreviousInvoiceRequest request;
  const FetchPreviousInvoicesEvent({required this.request});
}

/// Fetches the next page of previous orders (using the last-applied
/// filters) and appends it.
class LoadMorePreviousInvoicesEvent extends OrdersEvent {
  const LoadMorePreviousInvoicesEvent();
}

class RestoreOrderEvent extends OrdersEvent {
  final int invoiceId;
  final bool canEdite;
  const RestoreOrderEvent({required this.invoiceId, this.canEdite = true});
}

class DeleteOrderEvent extends OrdersEvent {
  final String? foodTableId;
  final int? id;
  const DeleteOrderEvent({this.foodTableId, this.id});
}

import 'package:apex_restaurant/featchers/more_actions/data/model/add_pos_total_return_invoice_request.dart';
import 'package:apex_restaurant/featchers/more_actions/data/model/get_all_pos_invoice_request.dart';

import 'package:equatable/equatable.dart';

abstract class MoreActionsEvent extends Equatable {
  const MoreActionsEvent();

  @override
  List<Object?> get props => [];
}

class FetchAllInvoicesEvent extends MoreActionsEvent {
  final GetAllPosInvoiceRequest request;
  const FetchAllInvoicesEvent({required this.request});
  @override
  List<Object?> get props => [request];
}

class FetchInvoiceByIdEvent extends MoreActionsEvent {
  final int invoiceId;
  const FetchInvoiceByIdEvent({required this.invoiceId});
  @override
  List<Object?> get props => [invoiceId];
}

class AddPOSTotalReturnEvent extends MoreActionsEvent {
  final AddPOSTotalReturnInvoiceRequest request;
  const AddPOSTotalReturnEvent({required this.request});
  @override
  List<Object?> get props => [request];
}

class AddPOSTReturnEvent extends MoreActionsEvent {
  final AddPOSTotalReturnInvoiceRequest request;
  const AddPOSTReturnEvent({required this.request});
  @override
  List<Object?> get props => [request];
}

class LoadMoreAllInvoicesEvent extends MoreActionsEvent {
  const LoadMoreAllInvoicesEvent();
}

class SelectInvoiceDateEvent extends MoreActionsEvent {
  final DateTime invoiceDate;
  const SelectInvoiceDateEvent({required this.invoiceDate});
  @override
  List<Object?> get props => [invoiceDate];
}

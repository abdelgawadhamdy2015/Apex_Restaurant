import 'package:apex_restaurant/featchers/more_actions/data/model/add_cash_transaction_request.dart';
import 'package:apex_restaurant/featchers/more_actions/data/model/add_pos_total_return_invoice_request.dart';
import 'package:apex_restaurant/featchers/more_actions/data/model/get_all_pos_invoice_request.dart';
import 'package:apex_restaurant/featchers/more_actions/presentation/screens/responsibility_shared_widgets.dart';

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

class AddCashTransactionForSessionEvent extends MoreActionsEvent {
  final AddCashTransactionRequest cashTransaction;
  const AddCashTransactionForSessionEvent({required this.cashTransaction});
  @override
  List<Object?> get props => [cashTransaction];
}

class FetchCashTransactionForSessionEvent extends MoreActionsEvent {
  final int employeeId;
  const FetchCashTransactionForSessionEvent({required this.employeeId});
  @override
  List<Object?> get props => [employeeId];
}

class ChangeActiveTabEvent extends MoreActionsEvent {
  final ResponsibilityTab activeTab;
  const ChangeActiveTabEvent({required this.activeTab});
  @override
  List<Object?> get props => [activeTab];
}

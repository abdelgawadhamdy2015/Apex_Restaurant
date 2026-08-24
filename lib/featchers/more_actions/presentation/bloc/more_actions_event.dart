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
}

class LoadMoreAllInvoicesEvent extends MoreActionsEvent {
  const LoadMoreAllInvoicesEvent();
}

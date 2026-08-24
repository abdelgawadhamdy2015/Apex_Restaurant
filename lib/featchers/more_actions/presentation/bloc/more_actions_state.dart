import 'package:apex_restaurant/featchers/more_actions/data/model/pos_invoice_data.dart';
import 'package:equatable/equatable.dart';

enum MoreActionsStatus { loading, failure, sussess }

/// Shared page size for both paginated lists on this screen.
const int kOrdersPageSize = 10;

class MoreActionsState extends Equatable {
  final MoreActionsStatus? status;
  final List<PosInvoiceData> invoices;
  final String? errorMessage;
  final DateTime? invoiceDate;
  final String? invoiceType;

  const MoreActionsState({
    this.status,
    this.invoices = const [],
    this.errorMessage,
    this.invoiceDate,
    this.invoiceType,
  });

  MoreActionsState copyWith({
    MoreActionsStatus? status,
    List<PosInvoiceData>? invoices,
    String? errorMessage,
    DateTime? invoiceDate,
    String? invoiceType,
  }) {
    return MoreActionsState(
      status: status ?? this.status,
      invoices: invoices ?? this.invoices,
      errorMessage: errorMessage,
      invoiceType: invoiceType ?? this.invoiceType,
      invoiceDate: invoiceDate ?? this.invoiceDate,
    );
  }

  @override
  List<Object?> get props => [
    status,
    invoiceDate,
    invoiceType,
    invoices,
    errorMessage,
  ];
}

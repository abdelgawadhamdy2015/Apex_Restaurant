import 'package:apex_restaurant/featchers/more_actions/data/model/pos_invoice_data.dart';

enum MoreActionsStatus { loading, failure, sussess }

/// Shared page size for both paginated lists on this screen.
const int kOrdersPageSize = 10;

class MoreActionsState {
  final MoreActionsStatus? status;
  final List<PosInvoiceData> invoices;
  final String? errorMessage;
  final DateTime? fromDate;
  final String? invoiceType;

  const MoreActionsState({
    this.status,
    this.invoices = const [],
    this.errorMessage,
    this.fromDate,
    this.invoiceType,
  });

  MoreActionsState copyWith({
    MoreActionsStatus? status,
    List<PosInvoiceData>? invoices,
    String? errorMessage,
    DateTime? fromDate,
    String? invoiceType,
  }) {
    return MoreActionsState(
      status: status ?? this.status,
      invoices: invoices ?? this.invoices,
      errorMessage: errorMessage,
      invoiceType: invoiceType ?? this.invoiceType,
      fromDate: fromDate ?? this.fromDate,
    );
  }
}

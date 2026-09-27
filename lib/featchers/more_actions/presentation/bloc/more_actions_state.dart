import 'package:apex_restaurant/featchers/more_actions/data/model/invoice_return_response.dart';
import 'package:apex_restaurant/featchers/more_actions/data/model/pos_invoice_data.dart';
import 'package:apex_restaurant/featchers/more_actions/data/model/restaurant_invoice_accrediting_data.dart';
import 'package:apex_restaurant/featchers/more_actions/data/model/transactions_response.dart';
import 'package:apex_restaurant/featchers/more_actions/presentation/screens/responsibility_shared_widgets.dart';
import 'package:apex_restaurant/featchers/orders/data/model/restored_invoice_model.dart';
import 'package:equatable/equatable.dart';

enum MoreActionsStatus { loading, failure, success, successAcredit }

/// Shared page size for both paginated lists on this screen.
const int kOrdersPageSize = 10;

class MoreActionsState extends Equatable {
  final MoreActionsStatus? status;
  final List<PosInvoiceData> invoices;
  final String? message;
  final DateTime? invoiceDate;
  final String? invoiceType;
  final RestoredInvoiceModel? returnedInvoice;
  final InvoiceReturnResponse? invoiceReturnResponse;
  final ResponsibilityTab? activeTab;
  final TransactionsResponse? transactionsResponse;
  final bool? isFullReturn;
  final RestaurantInvoiceAccreditingData? acreditData;

  const MoreActionsState({
    this.status,
    this.invoices = const [],
    this.message,
    this.invoiceDate,
    this.invoiceType,
    this.returnedInvoice,
    this.invoiceReturnResponse,
    this.activeTab = ResponsibilityTab.custody,
    this.transactionsResponse,
    this.isFullReturn,
    this.acreditData,
  });

  MoreActionsState copyWith({
    MoreActionsStatus? status,
    List<PosInvoiceData>? invoices,
    String? errorMessage,
    DateTime? invoiceDate,
    String? invoiceType,
    RestoredInvoiceModel? returnedInvoice,
    InvoiceReturnResponse? invoiceReturnResponse,
    bool? clearReturned,
    ResponsibilityTab? activeTab,
    TransactionsResponse? transactionsResponse,
    bool? isFullReturn,
    RestaurantInvoiceAccreditingData? acreditData,
  }) {
    return MoreActionsState(
      status: status ?? this.status,
      invoices: invoices ?? this.invoices,
      message: errorMessage,
      invoiceType: invoiceType ?? this.invoiceType,
      invoiceDate: invoiceDate ?? this.invoiceDate,
      activeTab: activeTab ?? this.activeTab,
      isFullReturn: isFullReturn ?? this.isFullReturn,
      acreditData: acreditData ?? this.acreditData,
      transactionsResponse: transactionsResponse ?? this.transactionsResponse,
      returnedInvoice: clearReturned == true
          ? null
          : returnedInvoice ?? this.returnedInvoice,
      invoiceReturnResponse: clearReturned == true
          ? null
          : invoiceReturnResponse ?? this.invoiceReturnResponse,
    );
  }

  @override
  List<Object?> get props => [
    status,
    invoiceDate,
    invoiceType,
    invoices,
    message,
    returnedInvoice,
    invoiceReturnResponse,
    activeTab,
  ];
}

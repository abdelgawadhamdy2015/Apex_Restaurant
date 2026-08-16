import '../../data/model/get_pinding_invoice.dart';
import '../../data/model/get_previous_invoice_request.dart';
import '../../data/model/order_model.dart';
import '../../data/model/pinding_invoice_model.dart';
import '../../data/model/previous_invoice_model.dart';
import '../../data/model/restored_invoice_model.dart';

enum OrdersStatus { loading, failure, sussess }

/// Shared page size for both paginated lists on this screen.
const int kOrdersPageSize = 10;

class OrdersState {
  final OrdersStatus? status;
  final OrderTab activeTab;
  final bool isLoading;
  final List<PreviousInvoiceModel> previousOrders;
  final List<PindingInvoiceModel> pindingInvoices;
  final String? errorMessage;
  final bool canEdite;

  /// Set while a specific held order's restore call is in flight —
  /// lets the card for that exact invoice show a spinner / disable itself.
  final int? restoringInvoiceId;

  /// Populated once a restore call succeeds. The listener (screen level)
  /// consumes this once, pushes it into CartBloc + navigates, then clears it.
  final RestoredInvoiceModel? restoredInvoice;

  // ---------------- Pagination: Previous Orders ----------------
  final int previousOrdersPage;
  final bool previousOrdersHasMore;
  final bool isLoadingMorePrevious;

  /// Last filters used (invoice code / customer / date range) so
  /// "load more" can request the next page with the same filters.
  final GetPreviousInvoiceRequest? previousOrdersFilter;

  // ---------------- Pagination: Held / Pinding Orders ----------------
  final int pindingInvoicesPage;
  final bool pindingInvoicesHasMore;
  final bool isLoadingMorePinding;
  final GetPindingInvoicesRequest? pindingInvoicesFilter;

  const OrdersState({
    this.activeTab = OrderTab.previous,
    this.isLoading = false,
    this.previousOrders = const [],
    this.pindingInvoices = const [],
    this.status,
    this.errorMessage,
    this.restoringInvoiceId,
    this.restoredInvoice,
    this.canEdite = false,
    this.previousOrdersPage = 1,
    this.previousOrdersHasMore = true,
    this.isLoadingMorePrevious = false,
    this.previousOrdersFilter,
    this.pindingInvoicesPage = 1,
    this.pindingInvoicesHasMore = true,
    this.isLoadingMorePinding = false,
    this.pindingInvoicesFilter,
  });

  OrdersState copyWith({
    OrdersStatus? status,
    OrderTab? activeTab,
    bool? isLoading,
    List<PreviousInvoiceModel>? previousOrders,
    List<PindingInvoiceModel>? pindingInvoices,
    String? errorMessage,
    int? restoringInvoiceId,
    RestoredInvoiceModel? restoredInvoice,
    bool clearRestoringId = false,
    bool clearRestoredInvoice = false,
    bool? canEdite,
    int? previousOrdersPage,
    bool? previousOrdersHasMore,
    bool? isLoadingMorePrevious,
    GetPreviousInvoiceRequest? previousOrdersFilter,
    int? pindingInvoicesPage,
    bool? pindingInvoicesHasMore,
    bool? isLoadingMorePinding,
    GetPindingInvoicesRequest? pindingInvoicesFilter,
  }) {
    return OrdersState(
      status: status ?? this.status,
      activeTab: activeTab ?? this.activeTab,
      isLoading: isLoading ?? this.isLoading,
      previousOrders: previousOrders ?? this.previousOrders,
      pindingInvoices: pindingInvoices ?? this.pindingInvoices,
      errorMessage: errorMessage ?? this.errorMessage,
      canEdite: canEdite ?? this.canEdite,
      restoringInvoiceId: clearRestoringId
          ? null
          : (restoringInvoiceId ?? this.restoringInvoiceId),
      restoredInvoice: clearRestoredInvoice
          ? null
          : (restoredInvoice ?? this.restoredInvoice),
      previousOrdersPage: previousOrdersPage ?? this.previousOrdersPage,
      previousOrdersHasMore:
          previousOrdersHasMore ?? this.previousOrdersHasMore,
      isLoadingMorePrevious:
          isLoadingMorePrevious ?? this.isLoadingMorePrevious,
      previousOrdersFilter: previousOrdersFilter ?? this.previousOrdersFilter,
      pindingInvoicesPage: pindingInvoicesPage ?? this.pindingInvoicesPage,
      pindingInvoicesHasMore:
          pindingInvoicesHasMore ?? this.pindingInvoicesHasMore,
      isLoadingMorePinding: isLoadingMorePinding ?? this.isLoadingMorePinding,
      pindingInvoicesFilter:
          pindingInvoicesFilter ?? this.pindingInvoicesFilter,
    );
  }
}

import 'package:apex_restaurant/featchers/orders/data/model/order_model.dart';
import 'package:apex_restaurant/featchers/orders/data/model/pinding_invoice_model.dart';
import 'package:apex_restaurant/featchers/orders/data/model/previous_invoice_model.dart';
import 'package:apex_restaurant/featchers/orders/data/model/restored_invoice_model.dart';

enum OrdersStatus { loading, failure, sussess }

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
    );
  }
}

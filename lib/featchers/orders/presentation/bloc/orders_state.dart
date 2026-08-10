// State
import 'package:apex_restaurant/featchers/orders/data/model/order_model.dart';
import 'package:apex_restaurant/featchers/orders/data/model/pinding_invoice_model.dart';
import 'package:apex_restaurant/featchers/orders/data/model/previous_invoice_model.dart';

enum OrdersStatus { loading, failure, sussess }

class OrdersState {
  final OrdersStatus? status;
  final OrderTab activeTab;
  final bool isLoading;
  final List<PreviousInvoiceModel> previousOrders;
  final List<PindingInvoiceModel> pindingInvoices;
  final String? errorMessage;
  const OrdersState({
    this.activeTab = OrderTab.previous,
    this.isLoading = false,
    this.previousOrders = const [],
    this.pindingInvoices = const [],
    this.status,
    this.errorMessage,
  });

  OrdersState copyWith({
    OrdersStatus? status,
    OrderTab? activeTab,
    bool? isLoading,
    List<PreviousInvoiceModel>? previousOrders,
    List<PindingInvoiceModel>? pindingInvoices,
    String? errorMessage,
  }) {
    return OrdersState(
      status: status ?? this.status,
      activeTab: activeTab ?? this.activeTab,
      isLoading: isLoading ?? this.isLoading,
      previousOrders: previousOrders ?? this.previousOrders,
      pindingInvoices: pindingInvoices ?? this.pindingInvoices,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

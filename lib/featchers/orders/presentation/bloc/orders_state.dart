// State
import 'package:apex_restaurant/featchers/orders/data/model/order_model.dart';

class OrdersState {
  final OrderTab activeTab;
  final bool isLoading;
  final List<OrderModel> previousOrders;
  final List<OrderModel> heldOrders;
  final OrderFilterModel? filter;

  const OrdersState({
    this.activeTab = OrderTab.previous,
    this.isLoading = false,
    this.previousOrders = const [],
    this.heldOrders = const [],
    this.filter,
  });

  OrdersState copyWith({
    OrderTab? activeTab,
    bool? isLoading,
    List<OrderModel>? previousOrders,
    List<OrderModel>? heldOrders,
    OrderFilterModel? filter,
  }) {
    return OrdersState(
      activeTab: activeTab ?? this.activeTab,
      isLoading: isLoading ?? this.isLoading,
      previousOrders: previousOrders ?? this.previousOrders,
      heldOrders: heldOrders ?? this.heldOrders,
      filter: filter ?? this.filter,
    );
  }
}

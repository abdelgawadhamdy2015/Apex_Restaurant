import 'package:apex_restaurant/featchers/orders/data/model/order_model.dart';
import 'package:apex_restaurant/featchers/orders/domain/usescase/orders_usescase.dart';
import 'package:apex_restaurant/featchers/orders/presentation/bloc/orders_event.dart';
import 'package:apex_restaurant/featchers/orders/presentation/bloc/orders_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Events

// Bloc
class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final GetPreviousOrdersUseCase getPreviousOrdersUseCase;
  final GetHeldOrdersUseCase getHeldOrdersUseCase;
  final RestoreHeldOrderUseCase restoreHeldOrderUseCase;
  final DeleteHeldOrderUseCase deleteHeldOrderUseCase;

  OrdersBloc({
    required this.getPreviousOrdersUseCase,
    required this.getHeldOrdersUseCase,
    required this.restoreHeldOrderUseCase,
    required this.deleteHeldOrderUseCase,
  }) : super(const OrdersState()) {
    on<SwitchTabEvent>((event, emit) {
      emit(state.copyWith(activeTab: event.tab));
      add(FetchOrdersEvent());
    });

    on<FetchOrdersEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true, filter: event.filter));
      if (state.activeTab == OrderTab.previous) {
        final orders = await getPreviousOrdersUseCase(event.filter);
        emit(state.copyWith(previousOrders: orders, isLoading: false));
      } else {
        final orders = await getHeldOrdersUseCase();
        emit(state.copyWith(heldOrders: orders, isLoading: false));
      }
    });

    on<RestoreOrderEvent>((event, emit) async {
      await restoreHeldOrderUseCase(event.orderId);
      add(FetchOrdersEvent());
    });

    on<DeleteOrderEvent>((event, emit) async {
      await deleteHeldOrderUseCase(event.orderId);
      add(FetchOrdersEvent());
    });
  }
}

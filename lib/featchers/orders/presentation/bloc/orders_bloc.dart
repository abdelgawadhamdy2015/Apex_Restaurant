import 'package:apex_restaurant/core/service/api_result.dart';
import 'package:apex_restaurant/featchers/orders/data/model/order_model.dart';
import 'package:apex_restaurant/featchers/orders/domain/usescase/orders_usescase.dart';
import 'package:apex_restaurant/featchers/orders/presentation/bloc/orders_event.dart';
import 'package:apex_restaurant/featchers/orders/presentation/bloc/orders_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Events

// Bloc
class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final GetRestaurantPosBookingTableUseCase getRestaurantPosBookingTableUseCase;
  final GetPindingInvoicesUseCase getPindingInvoicesUseCase;
  final GetPreviousOrdersUseCase getPreviousOrdersUseCase;

  final RestoreHeldOrderUseCase restoreHeldOrderUseCase;
  final DeleteHeldOrderUseCase deleteHeldOrderUseCase;

  OrdersBloc({
    required this.getPindingInvoicesUseCase,
    required this.getRestaurantPosBookingTableUseCase,
    required this.restoreHeldOrderUseCase,
    required this.deleteHeldOrderUseCase,
    required this.getPreviousOrdersUseCase,
  }) : super(const OrdersState()) {
    on<SwitchTabEvent>((event, emit) {
      emit(state.copyWith(activeTab: event.tab));
      if (state.activeTab == OrderTab.held) {
        add(FetchPindingInvoicesEvent());
      }
    });
    on<FetchPreviousInvoicesEvent>(_onPreviousInvoices);

    on<FetchPindingInvoicesEvent>(_onPindingInvoices);

    on<FetchRestaurantPosBookingTableEvent>(_onRestaurantPosBookingTable);

    on<DeleteOrderEvent>((event, emit) async {
      await deleteHeldOrderUseCase(event.orderId);
      add(FetchPindingInvoicesEvent());
    });
    on<RestoreOrderEvent>(_onRestoreOrder);
    on<ClearRestoredInvoiceEvent>((event, emit) {
      emit(state.copyWith(clearRestoredInvoice: true));
    });
  }

  Future<void> _onPreviousInvoices(
    FetchPreviousInvoicesEvent event,
    Emitter<OrdersState> emit,
  ) async {
    emit(state.copyWith(status: OrdersStatus.loading));
    try {
      final response = await getPreviousOrdersUseCase(request: event.request);
      response.when(
        success: (data) {
          if (data.result == 1) {
            emit(
              state.copyWith(
                previousOrders: data.data,
                isLoading: false,
                status: OrdersStatus.sussess,
              ),
            );
          } else {
            state.copyWith(
              errorMessage: data.errorMessageAr,
              isLoading: false,
              status: OrdersStatus.failure,
            );
          }
        },
        failure: (errorHandler) {
          state.copyWith(
            errorMessage: errorHandler.apiErrorModel.errorMessageAr,
            isLoading: false,
            status: OrdersStatus.failure,
          );
        },
      );
    } catch (e) {
      state.copyWith(
        pindingInvoices: [],
        isLoading: false,
        status: OrdersStatus.failure,
      );
    }
  }

  Future<void> _onPindingInvoices(
    FetchPindingInvoicesEvent event,
    Emitter<OrdersState> emit,
  ) async {
    emit(state.copyWith(status: OrdersStatus.loading));
    try {
      final response = await getPindingInvoicesUseCase(request: event.request);
      response.when(
        success: (data) {
          if (data.result == 1) {
            emit(
              state.copyWith(
                pindingInvoices: data.data ?? [],
                isLoading: false,
                status: OrdersStatus.sussess,
              ),
            );
          } else {
            state.copyWith(
              errorMessage: data.errorMessageAr,
              isLoading: false,
              status: OrdersStatus.failure,
            );
          }
        },
        failure: (errorHandler) {
          state.copyWith(
            errorMessage: errorHandler.apiErrorModel.errorMessageAr,
            isLoading: false,
            status: OrdersStatus.failure,
          );
        },
      );
    } catch (e) {
      state.copyWith(
        pindingInvoices: [],
        isLoading: false,
        status: OrdersStatus.failure,
      );
    }
  }

  Future<void> _onRestaurantPosBookingTable(
    FetchRestaurantPosBookingTableEvent event,
    Emitter<OrdersState> emit,
  ) async {
    emit(state.copyWith(status: OrdersStatus.loading));
    try {
      final response = await getRestaurantPosBookingTableUseCase(
        request: event.request,
      );
      response.when(
        success: (data) {
          if (data.result == 1) {
            emit(
              state.copyWith(
                pindingInvoices: data.data,
                isLoading: false,
                status: OrdersStatus.sussess,
              ),
            );
          } else {
            state.copyWith(
              errorMessage: data.errorMessageAr,
              isLoading: false,
              status: OrdersStatus.failure,
            );
          }
        },
        failure: (errorHandler) {
          state.copyWith(
            errorMessage: errorHandler.apiErrorModel.errorMessageAr,
            isLoading: false,
            status: OrdersStatus.failure,
          );
        },
      );
    } catch (e) {
      state.copyWith(
        pindingInvoices: [],
        isLoading: false,
        status: OrdersStatus.failure,
      );
    }
  }

  Future<void> _onRestoreOrder(
    RestoreOrderEvent event,
    Emitter<OrdersState> emit,
  ) async {
    emit(state.copyWith(restoringInvoiceId: event.invoiceId));

    try {
      final response = await restoreHeldOrderUseCase(event.invoiceId);
      response.when(
        success: (data) {
          if (data.result == 1 && data.data != null) {
            emit(
              state.copyWith(
                status: OrdersStatus.sussess,
                restoredInvoice: data.data,
                clearRestoringId: true,
                canEdite: event.canEdite,
              ),
            );
          } else {
            emit(
              state.copyWith(
                status: OrdersStatus.failure,
                errorMessage: data.errorMessageAr ?? 'فشل استرجاع الفاتورة',
                clearRestoringId: true,
              ),
            );
          }
        },
        failure: (err) {
          emit(
            state.copyWith(
              status: OrdersStatus.failure,
              errorMessage:
                  err.apiErrorModel.errorMessageAr ?? 'خطأ في الاتصال بالخادم',
              clearRestoringId: true,
            ),
          );
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: OrdersStatus.failure,
          errorMessage: 'حدث خطأ غير متوقع أثناء استرجاع الفاتورة',
          clearRestoringId: true,
        ),
      );
    }

    add(FetchPindingInvoicesEvent());
  }
}

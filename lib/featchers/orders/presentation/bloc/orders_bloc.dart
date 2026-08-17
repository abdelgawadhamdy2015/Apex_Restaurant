import '../../../../core/service/api_result.dart';
import '../../data/model/get_pinding_invoice.dart';
import '../../data/model/get_previous_invoice_request.dart';
import '../../data/model/order_model.dart';
import '../../domain/usescase/orders_usescase.dart';
import 'orders_event.dart';
import 'orders_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final GetPindingInvoicesUseCase getPindingInvoicesUseCase;
  final GetPreviousOrdersUseCase getPreviousOrdersUseCase;

  final RestoreHeldOrderUseCase restoreHeldOrderUseCase;
  final DeleteHeldOrderUseCase deleteHeldOrderUseCase;

  OrdersBloc({
    required this.getPindingInvoicesUseCase,
    required this.restoreHeldOrderUseCase,
    required this.deleteHeldOrderUseCase,
    required this.getPreviousOrdersUseCase,
  }) : super(const OrdersState()) {
    on<SwitchTabEvent>((event, emit) {
      emit(state.copyWith(activeTab: event.tab));
      if (state.activeTab == OrderTab.held) {
        add(FetchPindingInvoicesEvent(request: state.pindingInvoicesFilter));
      }
    });

    on<FetchPreviousInvoicesEvent>(_onPreviousInvoices);
    on<LoadMorePreviousInvoicesEvent>(_onLoadMorePrevious);

    on<FetchPindingInvoicesEvent>(_onPindingInvoices);
    on<LoadMorePindingInvoicesEvent>(_onLoadMorePinding);

    on<DeleteOrderEvent>((event, emit) async {
      await deleteHeldOrderUseCase(event.orderId);
      add(FetchPindingInvoicesEvent(request: state.pindingInvoicesFilter));
    });
    on<RestoreOrderEvent>(_onRestoreOrder);
    on<ClearRestoredInvoiceEvent>((event, emit) {
      emit(state.copyWith(clearRestoredInvoice: true));
    });
  }

  // ---------------------------------------------------------------------
  // Previous Orders (paginated)
  // ---------------------------------------------------------------------

  GetPreviousInvoiceRequest _withPage(
    GetPreviousInvoiceRequest? base,
    int page,
  ) {
    return GetPreviousInvoiceRequest(
      pageNumber: page,
      pageSize: kOrdersPageSize,
      fromDate: base?.fromDate,
      toDate: base?.toDate,
      invoiceCode: base?.invoiceCode,
      personName: base?.personName,
    );
  }

  Future<void> _onPreviousInvoices(
    FetchPreviousInvoicesEvent event,
    Emitter<OrdersState> emit,
  ) async {
    final request = _withPage(event.request, 1);
    emit(
      state.copyWith(
        status: OrdersStatus.loading,
        previousOrdersFilter: request,
        previousOrdersPage: 1,
        previousOrdersHasMore: true,
      ),
    );
    try {
      final response = await getPreviousOrdersUseCase(request: request);
      response.when(
        success: (data) {
          if (data.result == 1) {
            final items = data.data ?? [];
            emit(
              state.copyWith(
                previousOrders: items,
                isLoading: false,
                status: OrdersStatus.sussess,
                previousOrdersHasMore: items.length >= kOrdersPageSize,
              ),
            );
          } else {
            emit(
              state.copyWith(
                errorMessage: data.errorMessageAr,
                isLoading: false,
                status: OrdersStatus.failure,
              ),
            );
          }
        },
        failure: (errorHandler) {
          emit(
            state.copyWith(
              errorMessage: errorHandler.apiErrorModel.errorMessageAr,
              isLoading: false,
              status: OrdersStatus.failure,
            ),
          );
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          previousOrders: const [],
          isLoading: false,
          status: OrdersStatus.failure,
        ),
      );
    }
  }

  Future<void> _onLoadMorePrevious(
    LoadMorePreviousInvoicesEvent event,
    Emitter<OrdersState> emit,
  ) async {
    if (state.isLoadingMorePrevious || !state.previousOrdersHasMore) return;

    final nextPage = state.previousOrdersPage + 1;
    final request = _withPage(state.previousOrdersFilter, nextPage);

    emit(state.copyWith(isLoadingMorePrevious: true));
    try {
      final response = await getPreviousOrdersUseCase(request: request);
      response.when(
        success: (data) {
          if (data.result == 1) {
            final newItems = data.data ?? [];
            emit(
              state.copyWith(
                previousOrders: [...state.previousOrders, ...newItems],
                previousOrdersPage: nextPage,
                previousOrdersHasMore: newItems.length >= kOrdersPageSize,
                isLoadingMorePrevious: false,
              ),
            );
          } else {
            emit(
              state.copyWith(
                isLoadingMorePrevious: false,
                previousOrdersHasMore: false,
                errorMessage: data.errorMessageAr,
              ),
            );
          }
        },
        failure: (errorHandler) {
          emit(
            state.copyWith(
              isLoadingMorePrevious: false,
              errorMessage: errorHandler.apiErrorModel.errorMessageAr,
            ),
          );
        },
      );
    } catch (e) {
      emit(state.copyWith(isLoadingMorePrevious: false));
    }
  }

  // ---------------------------------------------------------------------
  // Held / Pinding Orders (paginated)
  // ---------------------------------------------------------------------

  GetPindingInvoicesRequest _withPindingPage(
    GetPindingInvoicesRequest? base,
    int page,
  ) {
    return GetPindingInvoicesRequest(
      foodTableId: base?.foodTableId,
      pageNumber: page,
      pageSize: kOrdersPageSize,
    );
  }

  Future<void> _onPindingInvoices(
    FetchPindingInvoicesEvent event,
    Emitter<OrdersState> emit,
  ) async {
    final request = _withPindingPage(event.request, 1);
    emit(
      state.copyWith(
        status: OrdersStatus.loading,
        pindingInvoicesFilter: request,
        pindingInvoicesPage: 1,
        pindingInvoicesHasMore: true,
      ),
    );
    try {
      final response = await getPindingInvoicesUseCase(request: request);
      response.when(
        success: (data) {
          if (data.result == 1) {
            final items = data.data ?? [];
            emit(
              state.copyWith(
                pindingInvoices: items,
                isLoading: false,
                status: OrdersStatus.sussess,
                pindingInvoicesHasMore: items.length >= kOrdersPageSize,
              ),
            );
          } else {
            emit(
              state.copyWith(
                errorMessage: data.errorMessageAr,
                isLoading: false,
                status: OrdersStatus.failure,
              ),
            );
          }
        },
        failure: (errorHandler) {
          emit(
            state.copyWith(
              errorMessage: errorHandler.apiErrorModel.errorMessageAr,
              isLoading: false,
              status: OrdersStatus.failure,
            ),
          );
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          pindingInvoices: const [],
          isLoading: false,
          status: OrdersStatus.failure,
        ),
      );
    }
  }

  Future<void> _onLoadMorePinding(
    LoadMorePindingInvoicesEvent event,
    Emitter<OrdersState> emit,
  ) async {
    if (state.isLoadingMorePinding || !state.pindingInvoicesHasMore) return;

    final nextPage = state.pindingInvoicesPage + 1;
    final request = _withPindingPage(state.pindingInvoicesFilter, nextPage);

    emit(state.copyWith(isLoadingMorePinding: true));
    try {
      final response = await getPindingInvoicesUseCase(request: request);
      response.when(
        success: (data) {
          if (data.result == 1) {
            final newItems = data.data ?? [];
            emit(
              state.copyWith(
                pindingInvoices: [...state.pindingInvoices, ...newItems],
                pindingInvoicesPage: nextPage,
                pindingInvoicesHasMore: newItems.length >= kOrdersPageSize,
                isLoadingMorePinding: false,
              ),
            );
          } else {
            emit(
              state.copyWith(
                isLoadingMorePinding: false,
                pindingInvoicesHasMore: false,
                errorMessage: data.errorMessageAr,
              ),
            );
          }
        },
        failure: (errorHandler) {
          emit(
            state.copyWith(
              isLoadingMorePinding: false,
              errorMessage: errorHandler.apiErrorModel.errorMessageAr,
            ),
          );
        },
      );
    } catch (e) {
      emit(state.copyWith(isLoadingMorePinding: false));
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

    add(FetchPindingInvoicesEvent(request: state.pindingInvoicesFilter));
  }
}

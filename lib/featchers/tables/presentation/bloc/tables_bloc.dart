// presentation/bloc/tables_bloc.dart

import 'package:apex_restaurant/core/service/api_result.dart';
import 'package:apex_restaurant/featchers/orders/domain/usescase/orders_usescase.dart';
import 'package:apex_restaurant/featchers/tables/data/models/get_table_request.dart';
import 'package:apex_restaurant/featchers/tables/domain/usescase/tables_usecase.dart';
import 'package:apex_restaurant/featchers/tables/presentation/bloc/tables_event.dart';
import 'package:apex_restaurant/featchers/tables/presentation/bloc/tables_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TablesBloc extends Bloc<TablesEvent, TablesState> {
  final GetReservationsUseCase getReservationsUseCase;
  final CreateReservationUseCase createReservationUseCase;
  final CancelReservationUseCase cancelReservationUseCase;
  final GetFloorsUseCase getFloorsUseCase;
  final GetTablesUseCase getTablesUseCase;
  final GetPindingTableInvoiceUseCase getPindingTableInvoiceUseCase;
  final RestoreHeldOrderUseCase restoreHeldOrderUseCase;

  TablesBloc({
    required this.getReservationsUseCase,
    required this.createReservationUseCase,
    required this.cancelReservationUseCase,
    required this.getFloorsUseCase,
    required this.getTablesUseCase,
    required this.getPindingTableInvoiceUseCase,
    required this.restoreHeldOrderUseCase,
  }) : super(const TablesState()) {
    on<FetchReservationsEvent>(_onFetchReservations);
    on<SwitchMainTabEvent>(_onSwitchMainTab);
    on<AddReservationEvent>(_onAddReservation);
    on<CancelReservationEvent>(_onCancelReservation);
    on<FetchFloorsEvent>(_onFetchFloors);
    on<FetchTablesEvent>(_onFetchTables);
    on<FetchRestaurantPosBookingTableEvent>(_onRestaurantPosBookingTable);
    on<RestoreOrderEvent>(_onRestoreOrder);
    on<ClearRestoredInvoiceEvent>((event, emit) {
      emit(state.copyWith());
    });
  }

  Future<void> _handleApiCall<T>({
    required Emitter<TablesState> emit,
    required Future<ApiResult<T>> Function() call,
    required bool Function(T data) isSuccessful,
    required void Function(T data) onSuccess,
    required String? Function(T data) errorMessage,
    bool emitLoading = false,
  }) async {
    if (emitLoading) {
      emit(state.copyWith(status: TablesStatus.loading));
    }
    try {
      final response = await call();
      response.when(
        success: (data) {
          if (isSuccessful(data)) {
            onSuccess(data);
          } else {
            emit(
              state.copyWith(
                status: TablesStatus.failure,
                reservations: [],
                errorMessage: errorMessage(data),
              ),
            );
          }
        },
        failure: (errorHandler) {
          emit(
            state.copyWith(
              status: TablesStatus.failure,
              errorMessage: errorHandler.apiErrorModel.errorMessageAr,
            ),
          );
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: TablesStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onRestaurantPosBookingTable(
    FetchRestaurantPosBookingTableEvent event,
    Emitter<TablesState> emit,
  ) async {
    emit(state.copyWith(status: TablesStatus.loading));
    try {
      final response = await getPindingTableInvoiceUseCase(
        request: event.request,
      );
      response.when(
        success: (data) {
          if (data.result == 1) {
            emit(
              state.copyWith(
                pindingInvoices: data.data,
                status: TablesStatus.pindingSussess,
              ),
            );
          } else {
            emit(
              state.copyWith(
                errorMessage: data.errorMessageAr,
                status: TablesStatus.failure,
              ),
            );
          }
        },
        failure: (errorHandler) {
          emit(
            state.copyWith(
              errorMessage: errorHandler.apiErrorModel.errorMessageAr,
              status: TablesStatus.failure,
            ),
          );
        },
      );
    } catch (e) {
      emit(state.copyWith(pindingInvoices: [], status: TablesStatus.failure));
    }
  }

  Future<void> _onRestoreOrder(
    RestoreOrderEvent event,
    Emitter<TablesState> emit,
  ) async {
    emit(state.copyWith(restoringInvoiceId: event.invoiceId));

    try {
      final response = await restoreHeldOrderUseCase(event.invoiceId);
      response.when(
        success: (data) {
          if (data.result == 1 && data.data != null) {
            emit(
              state.copyWith(
                status: TablesStatus.success,
                restoredInvoiceModel: data.data,
                clearRestoringId: true,
                canEdit: event.canEdite,
              ),
            );
          } else {
            emit(
              state.copyWith(
                status: TablesStatus.failure,
                errorMessage: data.errorMessageAr ?? 'فشل استرجاع الفاتورة',
                clearRestoringId: true,
              ),
            );
          }
        },
        failure: (err) {
          emit(
            state.copyWith(
              status: TablesStatus.failure,
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
          status: TablesStatus.failure,
          errorMessage: 'حدث خطأ غير متوقع أثناء استرجاع الفاتورة',
          clearRestoringId: true,
        ),
      );
    }

    //add(FetchPindingInvoicesEvent(request: state.pindingInvoicesFilter));
  }

  Future<void> _onFetchReservations(
    FetchReservationsEvent event,
    Emitter<TablesState> emit,
  ) {
    return _handleApiCall(
      emit: emit,
      emitLoading: true,
      call: () => getReservationsUseCase(event.request),
      isSuccessful: (data) => data.result == 1,
      errorMessage: (data) => data.errorMessageAr,
      onSuccess: (data) => emit(
        state.copyWith(
          status: TablesStatus.success,
          reservations: data.data?.data,
        ),
      ),
    );
  }

  void _onSwitchMainTab(SwitchMainTabEvent event, Emitter<TablesState> emit) {
    emit(state.copyWith(activeTab: event.tabIndex));
  }

  Future<void> _onAddReservation(
    AddReservationEvent event,
    Emitter<TablesState> emit,
  ) {
    return _handleApiCall(
      emit: emit,
      emitLoading: true,
      call: () => createReservationUseCase(event.reservation),
      isSuccessful: (data) => data.result == 1,
      errorMessage: (data) => data.errorMessageAr,
      onSuccess: (_) => emit(state.copyWith(status: TablesStatus.success)),
    );
  }

  Future<void> _onCancelReservation(
    CancelReservationEvent event,
    Emitter<TablesState> emit,
  ) {
    return _handleApiCall(
      emit: emit,
      call: () => cancelReservationUseCase(event.id),
      isSuccessful: (data) => data.result == 1,
      errorMessage: (data) => data.errorMessageAr,
      onSuccess: (_) => emit(state.copyWith(status: TablesStatus.success)),
    );
  }

  Future<void> _onFetchFloors(
    FetchFloorsEvent event,
    Emitter<TablesState> emit,
  ) {
    return _handleApiCall(
      emit: emit,
      emitLoading: true,
      call: () => getFloorsUseCase(request: event.request),
      isSuccessful: (data) => data.result == 1,
      errorMessage: (data) => data.errorMessageAr,
      onSuccess: (data) {
        final floorsList = data.data ?? [];
        emit(state.copyWith(status: TablesStatus.success, floors: floorsList));
        if (floorsList.isNotEmpty) {
          add(
            FetchTablesEvent(
              GetTablesRequest(
                pageNumber: 1,
                pageSize: 100,
                floorID: floorsList.first.id,
                forPOS: false,
              ),
            ),
          );
        }
      },
    );
  }

  Future<void> _onFetchTables(
    FetchTablesEvent event,
    Emitter<TablesState> emit,
  ) {
    return _handleApiCall(
      emit: emit,
      emitLoading: true,
      call: () => getTablesUseCase(request: event.request),
      isSuccessful: (data) => data.result == 1,
      errorMessage: (data) => data.errorMessageAr,
      onSuccess: (data) => emit(
        state.copyWith(status: TablesStatus.success, tables: data.data ?? []),
      ),
    );
  }
}

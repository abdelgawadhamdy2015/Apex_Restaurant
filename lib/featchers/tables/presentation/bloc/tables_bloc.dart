// presentation/bloc/tables_bloc.dart

import 'package:apex_restaurant/core/service/api_result.dart';
import 'package:apex_restaurant/featchers/tables/data/models/get_table_request.dart';
import 'package:apex_restaurant/featchers/tables/domain/usescase/get_reservations_usecase.dart';
import 'package:apex_restaurant/featchers/tables/presentation/bloc/tables_event.dart';
import 'package:apex_restaurant/featchers/tables/presentation/bloc/tables_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TablesBloc extends Bloc<TablesEvent, TablesState> {
  final GetReservationsUseCase getReservationsUseCase;
  final CreateReservationUseCase createReservationUseCase;
  final CancelReservationUseCase cancelReservationUseCase;
  final GetFloorsUseCase getFloorsUseCase;
  final GetTablesUseCase getTablesUseCase;

  TablesBloc({
    required this.getReservationsUseCase,
    required this.createReservationUseCase,
    required this.cancelReservationUseCase,
    required this.getFloorsUseCase,
    required this.getTablesUseCase,
  }) : super(const TablesState()) {
    on<FetchReservationsEvent>(_onFetchReservations);
    on<SwitchMainTabEvent>(_onSwitchMainTab);
    on<AddReservationEvent>(_onAddReservation);
    on<CancelReservationEvent>(_onCancelReservation);
    on<FetchFloorsEvent>(_onFetchFloors);
    on<FetchTablesEvent>(_onFetchTables);
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

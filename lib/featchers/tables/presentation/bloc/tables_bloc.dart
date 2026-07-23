// presentation/bloc/tables_bloc.dart
import 'dart:developer';

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

  Future<void> _onFetchReservations(
    FetchReservationsEvent event,
    Emitter<TablesState> emit,
  ) async {
    emit(state.copyWith(status: TablesStatus.loading));
    try {
      final response = await getReservationsUseCase(event.request);

      response.when(
        success: (data) {
          emit(
            state.copyWith(
              status: TablesStatus.success,
              reservations: (data.data?.data ?? const []).cast(),
            ),
          );
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

  void _onSwitchMainTab(SwitchMainTabEvent event, Emitter<TablesState> emit) {
    emit(state.copyWith(activeTab: event.tabIndex));
  }

  Future<void> _onAddReservation(
    AddReservationEvent event,
    Emitter<TablesState> emit,
  ) async {
    try {
      await createReservationUseCase(event.reservation);
    } catch (e) {
      emit(
        state.copyWith(
          status: TablesStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onCancelReservation(
    CancelReservationEvent event,
    Emitter<TablesState> emit,
  ) async {
    try {
      await cancelReservationUseCase(event.id);
    } catch (e) {
      emit(
        state.copyWith(
          status: TablesStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onFetchFloors(
    FetchFloorsEvent event,
    Emitter<TablesState> emit,
  ) async {
    emit(state.copyWith(status: TablesStatus.loading));
    try {
      final response = await getFloorsUseCase(request: event.request);
      response.when(
        success: (data) {
          final floorsList = data.data ?? [];
          log("Floors count: ${floorsList.length}");

          emit(
            state.copyWith(status: TablesStatus.success, floors: floorsList),
          );

          // Delegate fetching tables to FetchTablesEvent to prevent state clobbering
          if (floorsList.isNotEmpty) {
            add(
              FetchTablesEvent(
                GetTablesRequest(floorID: floorsList.first.id, forPOS: true),
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

  Future<void> _onFetchTables(
    FetchTablesEvent event,
    Emitter<TablesState> emit,
  ) async {
    emit(state.copyWith(status: TablesStatus.loading));
    try {
      final response = await getTablesUseCase(request: event.request);
      response.when(
        success: (data) {
          log("Tables count: ${data.data?.length}");
          emit(
            state.copyWith(
              status: TablesStatus.success,
              tables: data.data ?? [],
            ),
          );
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
}

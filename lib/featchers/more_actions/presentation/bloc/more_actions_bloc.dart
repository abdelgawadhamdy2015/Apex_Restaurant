import 'dart:async';

import 'package:apex_restaurant/core/service/api_error_handler.dart';
import 'package:apex_restaurant/featchers/more_actions/domain/usescase/more_actions_usescase.dart';
import 'package:apex_restaurant/featchers/more_actions/presentation/bloc/more_actions_event.dart';
import 'package:apex_restaurant/featchers/more_actions/presentation/bloc/more_actions_state.dart';
import 'package:apex_restaurant/featchers/orders/domain/usescase/orders_usescase.dart';

import '../../../../core/service/api_result.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class MoreActionsBloc extends Bloc<MoreActionsEvent, MoreActionsState> {
  final GetAllPOSInvoicesUseCase getAllPOSInvoicesUseCase;
  final AddPOSResturnInvoiceUseCase addPOSResturnInvoiceUseCase;
  final GetPosInvoiceDataByIdUseCase getPosInvoiceDataByIdUseCase;
  final AddPOSTotalReturnInvoiceUseCase addPOSTotalReturnInvoiceUseCase;
  final AddCashTransactionForSessionUseCase addCashTransactionForSessionUseCase;
  final GetCashTransactionForSessionUseCase getCashTransactionForSessionUseCase;
  MoreActionsBloc({
    required this.getAllPOSInvoicesUseCase,
    required this.addPOSResturnInvoiceUseCase,
    required this.addPOSTotalReturnInvoiceUseCase,
    required this.getPosInvoiceDataByIdUseCase,
    required this.addCashTransactionForSessionUseCase,
    required this.getCashTransactionForSessionUseCase,
  }) : super(const MoreActionsState()) {
    on<FetchAllInvoicesEvent>(_onFetchInvoices);
    on<FetchInvoiceByIdEvent>(_onFetchInvoiceById);
    on<AddPOSTotalReturnEvent>(_onAddPOSTotalReturn);
    on<SelectInvoiceDateEvent>(
      (event, emit) => emit(state.copyWith(invoiceDate: event.invoiceDate)),
    );
    on<AddCashTransactionForSessionEvent>(_onAddCashTransactionForSession);

    on<FetchCashTransactionForSessionEvent>(_onFetchCashTransactionForSession);
    on<ChangeActiveTabEvent>(
      (event, emit) => emit(state.copyWith(activeTab: event.activeTab)),
    );
  }

  Future<void> _onFetchInvoiceById(
    FetchInvoiceByIdEvent event,
    Emitter<MoreActionsState> emit,
  ) async {
    emit(state.copyWith(status: MoreActionsStatus.loading));
    try {
      final response = await getPosInvoiceDataByIdUseCase(event.invoiceId);
      response.when(
        success: (data) {
          if (data.result == 1) {
            final invoice = data.data;
            emit(
              state.copyWith(
                returnedInvoice: invoice,
                status: MoreActionsStatus.success,
                isFullReturn: false,
                errorMessage: null,
              ),
            );
          } else {
            emit(
              state.copyWith(
                errorMessage: data.errorMessageAr,
                returnedInvoice: null,
                status: MoreActionsStatus.failure,
              ),
            );
          }
        },
        failure: (errorHandler) {
          emit(
            state.copyWith(
              errorMessage: errorHandler.apiErrorModel.errorMessageAr,
              status: MoreActionsStatus.failure,
              isFullReturn: false,
            ),
          );
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          returnedInvoice: null,
          errorMessage: ErrorHandler.handle(e).apiErrorModel.errorMessageAr,
          status: MoreActionsStatus.failure,
          isFullReturn: false,
        ),
      );
    }
  }

  Future<void> _onAddPOSTotalReturn(
    AddPOSTotalReturnEvent event,
    Emitter<MoreActionsState> emit,
  ) async {
    emit(state.copyWith(status: MoreActionsStatus.loading));

    try {
      final response = await addPOSTotalReturnInvoiceUseCase(
        request: event.request,
      );
      response.when(
        success: (data) {
          if (data?.result == 1) {
            final invoices = state.invoices
                .where((invoice) => invoice.invoiceId != event.request.id)
                .toList();
            emit(
              state.copyWith(
                invoices: invoices,
                invoiceReturnResponse: data?.data,
                status: MoreActionsStatus.success,
                isFullReturn: true,
                errorMessage: null,
              ),
            );
          } else {
            emit(
              state.copyWith(
                errorMessage: data?.errorMessageAr,
                returnedInvoice: null,
                status: MoreActionsStatus.failure,
                isFullReturn: false,
              ),
            );
          }
        },
        failure: (errorHandler) {
          emit(
            state.copyWith(
              errorMessage: errorHandler.apiErrorModel.errorMessageAr,
              status: MoreActionsStatus.failure,
              isFullReturn: false,
            ),
          );
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          returnedInvoice: null,
          errorMessage: ErrorHandler.handle(e).apiErrorModel.errorMessageAr,
          status: MoreActionsStatus.failure,
          isFullReturn: false,
        ),
      );
    }
  }

  Future<void> _onFetchInvoices(
    FetchAllInvoicesEvent event,
    Emitter<MoreActionsState> emit,
  ) async {
    emit(state.copyWith(status: MoreActionsStatus.loading));

    try {
      final response = await getAllPOSInvoicesUseCase(request: event.request);
      response.when(
        success: (data) {
          if (data.result == 1) {
            final items = data.data ?? [];
            emit(
              state.copyWith(
                invoices: items,
                clearReturned: true,
                status: MoreActionsStatus.success,
                isFullReturn: false,
                errorMessage: null,
              ),
            );
          } else {
            emit(
              state.copyWith(
                errorMessage: data.errorMessageAr,
                invoices: [],
                status: MoreActionsStatus.failure,
                isFullReturn: false,
              ),
            );
          }
        },
        failure: (errorHandler) {
          emit(
            state.copyWith(
              errorMessage: errorHandler.apiErrorModel.errorMessageAr,
              status: MoreActionsStatus.failure,
              isFullReturn: false,
            ),
          );
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          invoices: const [],
          errorMessage: ErrorHandler.handle(e).apiErrorModel.errorMessageAr,
          status: MoreActionsStatus.failure,
          isFullReturn: false,
        ),
      );
    }
  }

  FutureOr<void> _onAddCashTransactionForSession(
    AddCashTransactionForSessionEvent event,
    Emitter<MoreActionsState> emit,
  ) async {
    emit(state.copyWith(status: MoreActionsStatus.loading));
    try {
      final response = await addCashTransactionForSessionUseCase(
        request: event.cashTransaction,
      );
      response.when(
        success: (data) {
          if (data.result == 1) {
            emit(
              state.copyWith(
                status: MoreActionsStatus.success,
                isFullReturn: false,
                errorMessage: null,
              ),
            );
          } else {
            emit(
              state.copyWith(
                errorMessage: data.errorMessageAr,
                status: MoreActionsStatus.failure,
                isFullReturn: false,
              ),
            );
          }
        },
        failure: (errorHandler) {
          emit(
            state.copyWith(
              errorMessage: errorHandler.apiErrorModel.errorMessageAr,
              status: MoreActionsStatus.failure,
              isFullReturn: false,
            ),
          );
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          errorMessage: ErrorHandler.handle(e).apiErrorModel.errorMessageAr,
          status: MoreActionsStatus.failure,
          isFullReturn: false,
        ),
      );
    }
  }

  FutureOr<void> _onFetchCashTransactionForSession(
    FetchCashTransactionForSessionEvent event,
    Emitter<MoreActionsState> emit,
  ) async {
    emit(state.copyWith(status: MoreActionsStatus.loading));
    try {
      final response = await getCashTransactionForSessionUseCase(
        employeesId: event.employeeId,
      );
      response.when(
        success: (data) {
          if (data.result == 1) {
            emit(
              state.copyWith(
                transactionsResponse: data.data,
                status: MoreActionsStatus.success,
                errorMessage: null,
                isFullReturn: false,
              ),
            );
          } else {
            emit(
              state.copyWith(
                errorMessage: data.errorMessageAr,
                status: MoreActionsStatus.failure,
                isFullReturn: false,
              ),
            );
          }
        },
        failure: (errorHandler) {
          emit(
            state.copyWith(
              errorMessage: errorHandler.apiErrorModel.errorMessageAr,
              status: MoreActionsStatus.failure,
              isFullReturn: false,
            ),
          );
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          errorMessage: ErrorHandler.handle(e).apiErrorModel.errorMessageAr,
          status: MoreActionsStatus.failure,
          isFullReturn: false,
        ),
      );
    }
  }
}

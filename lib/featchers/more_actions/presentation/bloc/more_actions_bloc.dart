import 'package:apex_restaurant/core/service/api_error_handler.dart';
import 'package:apex_restaurant/featchers/more_actions/domain/usescase/more_actions_usescase.dart';
import 'package:apex_restaurant/featchers/more_actions/presentation/bloc/more_actions_event.dart';
import 'package:apex_restaurant/featchers/more_actions/presentation/bloc/more_actions_state.dart';

import '../../../../core/service/api_result.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class MoreActionsBloc extends Bloc<MoreActionsEvent, MoreActionsState> {
  final GetAllPOSInvoicesUseCase getAllPOSInvoicesUseCase;
  final AddPOSResturnInvoiceUseCase addPOSResturnInvoiceUseCase;

  final AddPOSTotalReturnInvoiceUseCase addPOSTotalReturnInvoiceUseCase;

  MoreActionsBloc({
    required this.getAllPOSInvoicesUseCase,
    required this.addPOSResturnInvoiceUseCase,
    required this.addPOSTotalReturnInvoiceUseCase,
  }) : super(const MoreActionsState()) {
    on<FetchAllInvoicesEvent>(_onFetchInvoices);
  }

  Future<void> _onFetchInvoices(
    FetchAllInvoicesEvent event,
    Emitter<MoreActionsState> emit,
  ) async {
    try {
      final response = await getAllPOSInvoicesUseCase(request: event.request);
      response.when(
        success: (data) {
          if (data.result == 1) {
            final items = data.data ?? [];
            emit(
              state.copyWith(
                invoices: items,

                status: MoreActionsStatus.sussess,
              ),
            );
          } else {
            emit(
              state.copyWith(
                errorMessage: data.errorMessageAr,
                invoices: [],
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
        ),
      );
    }
  }
}

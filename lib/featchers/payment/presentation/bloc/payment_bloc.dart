import 'dart:async';

import '../../../../core/service/api_result.dart';
import '../../data/model/payment_success_model.dart';
import '../../domain/usecase/process_payment_usecase.dart';
import 'payment_event.dart';
import 'payment_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final SavePaymentRestaurantPosInvoiceUseCase processPaymentUseCase;
  final PaymentMethodsUseCase paymentMethodsUseCase;
  PaymentBloc({
    required this.processPaymentUseCase,
    required this.paymentMethodsUseCase,
  }) : super(const PaymentState()) {
    on<InitializePaymentEvent>(_onInitializePayment);
    on<ChangePaymentMethodEvent>(_onChangePaymentMethod);
    on<UpdatePaidAmountEvent>(_onUpdatePaidAmount);
    on<UpdateReferenceNumberEvent>(_onUpdateReferenceNumber);
    on<UpdateSplitAmountEvent>(_onUpdateSplitAmount);
    on<SubmitPaymentEvent>(_onSubmitPayment);
    on<ClearPaymentEvent>((event, emit) {
      emit(state.copyWith(status: PaymentStatus.initial, successModel: null));
    });
    on<FetchPaymentMethodsEvent>(_onFetchPaymentMethods);
  }

  void _onInitializePayment(
    InitializePaymentEvent event,
    Emitter<PaymentState> emit,
  ) {
    emit(
      state.copyWith(
        status: PaymentStatus.initial,
        totalAmount: event.totalAmount,
        paidAmount: event.totalAmount,
      ),
    );
  }

  void _onChangePaymentMethod(
    ChangePaymentMethodEvent event,
    Emitter<PaymentState> emit,
  ) {
    emit(state.copyWith(selectedMethod: event.method));
  }

  void _onUpdatePaidAmount(
    UpdatePaidAmountEvent event,
    Emitter<PaymentState> emit,
  ) {
    emit(state.copyWith(paidAmount: event.amount));
  }

  void _onUpdateReferenceNumber(
    UpdateReferenceNumberEvent event,
    Emitter<PaymentState> emit,
  ) {
    emit(state.copyWith(referenceNumber: event.refNumber));
  }

  void _onUpdateSplitAmount(
    UpdateSplitAmountEvent event,
    Emitter<PaymentState> emit,
  ) {
    final updatedMap = Map<int, double>.from(state.splitAmounts);
    updatedMap[event.paymentMethodId] = event.amount;
    emit(state.copyWith(splitAmounts: updatedMap));
  }

  Future<void> _onSubmitPayment(
    SubmitPaymentEvent event,
    Emitter<PaymentState> emit,
  ) async {
    emit(state.copyWith(status: PaymentStatus.loading));

    // Submit complete SaveRestaurantPosInvoiceRequest to UseCase
    final result = await processPaymentUseCase(event.invoiceRequest);

    result.when(
      success: (response) {
        if (response.result != 1) {
          emit(
            state.copyWith(
              status: PaymentStatus.error,
              errorMessage:
                  response.errorMessageAr ??
                  'فشلت عملية الدفع. يرجى المحاولة مرة أخرى.',
            ),
          );
          return;
        }
        emit(
          state.copyWith(
            status: PaymentStatus.success,
            successResponseModel: response.data,
            successModel: PaymentSuccessModel(
              orderNumber: response.result?.toString() ?? '',
              invoiceNumber: "",
              totalPaid: event.invoiceRequest.invoice.paidAmount,
              paymentMethodName: event
                  .invoiceRequest
                  .payments
                  .first
                  .paymentMethodId
                  .toString(),
              transactionTime: DateTime.now(),
              items: event.invoiceRequest.items
                  .map(
                    (item) => OrderItemModel(
                      name: item.itemId.toString(),
                      quantity: 1,
                      price: 0.0,
                    ),
                  )
                  .toList(),
            ),
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            status: PaymentStatus.error,
            errorMessage:
                error.apiErrorModel.errorMessageAr ??
                'فشلت عملية الدفع. يرجى المحاولة مرة أخرى.',
          ),
        );
      },
    );
  }

  FutureOr<void> _onFetchPaymentMethods(
    FetchPaymentMethodsEvent event,
    Emitter<PaymentState> emit,
  ) async {
    emit(state.copyWith(status: PaymentStatus.loading));
    try {
      final result = await paymentMethodsUseCase();

      result.when(
        success: (response) {
          if (response.result != 1) {
            emit(
              state.copyWith(
                status: PaymentStatus.error,
                errorMessage:
                    response.errorMessageAr ??
                    'فشلت عملية جلب طرق الدفع. يرجى المحاولة مرة أخرى.',
              ),
            );
            return;
          }
          emit(
            state.copyWith(
              status: PaymentStatus.paymentMethodLoaded,
              paymentMethods: response.data ?? [],
            ),
          );
        },
        failure: (error) {
          emit(
            state.copyWith(
              status: PaymentStatus.error,
              errorMessage:
                  error.apiErrorModel.errorMessageAr ??
                  'فشلت عملية جلب طرق الدفع. يرجى المحاولة مرة أخرى.',
            ),
          );
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: PaymentStatus.error,
          errorMessage: 'فشلت عملية جلب طرق الدفع. يرجى المحاولة مرة أخرى.',
        ),
      );
    }
  }
}

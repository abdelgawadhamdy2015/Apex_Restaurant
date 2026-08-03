import 'package:apex_restaurant/core/service/api_result.dart';
import 'package:apex_restaurant/featchers/payment/data/model/payment_success_model.dart';
import 'package:apex_restaurant/featchers/payment/domain/usecase/process_payment_usecase.dart';
import 'package:apex_restaurant/featchers/payment/presentation/bloc/payment_event.dart';
import 'package:apex_restaurant/featchers/payment/presentation/bloc/payment_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final SaveRestaurantPosInvoice processPaymentUseCase;

  PaymentBloc({required this.processPaymentUseCase})
    : super(const PaymentState()) {
    on<InitializePaymentEvent>(_onInitializePayment);
    on<ChangePaymentMethodEvent>(_onChangePaymentMethod);
    on<UpdatePaidAmountEvent>(_onUpdatePaidAmount);
    on<UpdateReferenceNumberEvent>(_onUpdateReferenceNumber);
    on<UpdateSplitAmountEvent>(_onUpdateSplitAmount);
    on<SubmitPaymentEvent>(_onSubmitPayment);
  }

  void _onInitializePayment(
    InitializePaymentEvent event,
    Emitter<PaymentState> emit,
  ) {
    emit(
      state.copyWith(
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

    // Submit complete SaveInvoiceRequestModel to UseCase
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
            successModel: PaymentSuccessModel(
              orderNumber: response.result?.toString() ?? '',
              invoiceNumber: "",
              totalPaid: event.invoiceRequest.invoice?.paidAmount ?? 0,
              paymentMethodName:
                  event.invoiceRequest.payments?.first.paymentMethodId
                      .toString() ??
                  '',
              transactionTime: DateTime.now(),
              items: event.invoiceRequest.items!
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
}

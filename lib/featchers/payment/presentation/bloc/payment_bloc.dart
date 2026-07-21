import 'package:apex_restaurant/core/service/api_result.dart';
import 'package:apex_restaurant/featchers/payment/data/model/payment_request_model.dart';
import 'package:apex_restaurant/featchers/payment/domain/usecase/process_payment_usecase.dart';
import 'package:apex_restaurant/featchers/payment/presentation/bloc/payment_event.dart';
import 'package:apex_restaurant/featchers/payment/presentation/bloc/payment_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final ProcessPaymentUseCase processPaymentUseCase;

  PaymentBloc({required this.processPaymentUseCase})
    : super(const PaymentState()) {
    on<ChangePaymentMethodEvent>(_onChangePaymentMethod);
    on<UpdatePaidAmountEvent>(_onUpdatePaidAmount);
    on<UpdateReferenceNumberEvent>(_onUpdateReferenceNumber);
    on<SubmitPaymentEvent>(_onSubmitPayment);
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

  Future<void> _onSubmitPayment(
    SubmitPaymentEvent event,
    Emitter<PaymentState> emit,
  ) async {
    emit(state.copyWith(status: PaymentStatus.loading));

    final request = ProcessPaymentRequest(
      orderId: event.orderId,
      totalAmount: state.totalAmount,
      paidAmount: state.paidAmount,
      paymentMethods: [
        PaymentMethodAmount(
          method: state.selectedMethod,
          amount: state.paidAmount,
          referenceNumber: state.referenceNumber,
        ),
      ],
    );

    final result = await processPaymentUseCase(request);

    result.when(
      success: (response) {
        emit(
          state.copyWith(
            status: PaymentStatus.success,
            successModel: response.data,
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            status: PaymentStatus.error,
            errorMessage: 'فشلت عملية الدفع. يرجى المحاولة مرة أخرى.',
          ),
        );
      },
    );
  }
}

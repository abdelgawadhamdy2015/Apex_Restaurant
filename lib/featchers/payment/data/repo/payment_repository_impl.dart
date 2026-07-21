import 'package:apex_restaurant/core/service/api_result.dart';
import 'package:apex_restaurant/core/shared/model/base_response.dart';
import 'package:apex_restaurant/featchers/payment/data/datasource/payment_remote_data_source.dart';
import 'package:apex_restaurant/featchers/payment/data/model/payment_request_model.dart';
import 'package:apex_restaurant/featchers/payment/data/model/payment_success_model.dart';
import 'package:apex_restaurant/featchers/payment/domain/repo/payment_repository.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentRemoteDataSource _remoteDataSource;
  PaymentRepositoryImpl(this._remoteDataSource);
  @override
  Future<ApiResult<BaseResponse<PaymentSuccessModel>>> processPayment(
    ProcessPaymentRequest request,
  ) async {
    try {
      // Mocked successful payment result for UI flow
      final successData = PaymentSuccessModel(
        orderNumber: '#12345',
        invoiceNumber: 'INV-9876',
        totalPaid: request.paidAmount,
        paymentMethodName: 'بطاقة مدى',
        transactionTime: DateTime.now(),
        items: const [
          OrderItemModel(name: 'ستيك سالمون مشوي', quantity: 1, price: 120.0),
          OrderItemModel(name: 'سلطة خضراء', quantity: 2, price: 42.0),
          OrderItemModel(name: 'بيتزا تشيز برست', quantity: 1, price: 45.0),
        ],
      );
      return ApiResult.success(BaseResponse(result: 1, data: successData));
    } catch (e) {
      return ApiResult.failure(e as dynamic);
    }
  }
}

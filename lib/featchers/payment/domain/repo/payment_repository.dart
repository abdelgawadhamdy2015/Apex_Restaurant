import 'package:apex_restaurant/core/service/api_result.dart';
import 'package:apex_restaurant/core/shared/model/base_response.dart';
import 'package:apex_restaurant/featchers/payment/data/model/payment_request_model.dart';
import 'package:apex_restaurant/featchers/payment/data/model/payment_success_model.dart';

abstract class PaymentRepository {
  Future<ApiResult<BaseResponse<PaymentSuccessModel>>> processPayment(
    ProcessPaymentRequest request,
  );
}

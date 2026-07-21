import 'package:apex_restaurant/core/service/api_service.dart';
import 'package:apex_restaurant/core/shared/model/base_response.dart';
import 'package:apex_restaurant/featchers/payment/data/model/payment_request_model.dart';
import 'package:apex_restaurant/featchers/payment/data/model/payment_success_model.dart';

/// Talks directly to `ApiService`. Throws on failure (DioException or
/// otherwise) — the repository layer is responsible for catching that and
/// converting it to an [ApiResult.failure] via [ErrorHandler].
abstract class PaymentRemoteDataSource {
  Future<BaseResponse<PaymentSuccessModel>> processPayment(
    ProcessPaymentRequest request,
  );
}

class PaymentRemoteDataSourceImpl implements PaymentRemoteDataSource {
  final ApiService _apiService;

  PaymentRemoteDataSourceImpl(this._apiService);

  @override
  Future<BaseResponse<PaymentSuccessModel>> processPayment(
    ProcessPaymentRequest request,
  ) {
    return _apiService.processPayment(request.toJson());
  }
}

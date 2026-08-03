import 'package:apex_restaurant/core/service/api_error_handler.dart';
import 'package:apex_restaurant/core/service/api_result.dart';
import 'package:apex_restaurant/core/shared/model/base_response.dart';
import 'package:apex_restaurant/featchers/cart/data/models/invoice_request_model.dart';
import 'package:apex_restaurant/featchers/payment/data/datasource/payment_remote_data_source.dart';
import 'package:apex_restaurant/featchers/payment/domain/repo/payment_repository.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentRemoteDataSource _remoteDataSource;
  PaymentRepositoryImpl(this._remoteDataSource);
  @override
  Future<ApiResult<BaseResponse<dynamic>>> saveRestaurantPosInvoice(
    SaveInvoiceRequestModel request,
  ) async {
    try {
      // Mocked successful payment result for UI flow
      final response = await _remoteDataSource.saveRestaurantPosInvoice(
        request,
      );
      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e));
    }
  }
}

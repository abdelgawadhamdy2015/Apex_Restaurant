import 'package:apex_restaurant/featchers/payment/data/model/payment_method_response_model.dart';

import '../../../../core/service/api_error_handler.dart';
import '../../../../core/service/api_result.dart';
import '../../../../core/shared/model/base_response.dart';
import '../../../cart/data/models/invoice_request.dart';
import '../datasource/payment_remote_data_source.dart';
import '../model/success_response_model.dart';
import '../../domain/repo/payment_repository.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentRemoteDataSource _remoteDataSource;
  PaymentRepositoryImpl(this._remoteDataSource);
  @override
  Future<ApiResult<BaseResponse<SuccessResponseModel>>>
  saveRestaurantPosInvoice(SaveRestaurantPosInvoiceRequest request) async {
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

  @override
  Future<ApiResult<BaseResponse<List<PaymentMethodResponseModel>?>>>
  getListOfPaymentMethods() async {
    try {
      final response = await _remoteDataSource.getListOfPaymentMethods();
      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e));
    }
  }
}

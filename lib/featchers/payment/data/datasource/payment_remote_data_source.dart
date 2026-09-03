import 'package:apex_restaurant/featchers/payment/data/model/payment_method_response_model.dart';

import '../../../../core/service/api_service.dart';
import '../../../../core/shared/model/base_response.dart';
import '../../../cart/data/models/invoice_request.dart';
import '../model/success_response_model.dart';

/// Talks directly to `ApiService`. Throws on failure (DioException or
/// otherwise) — the repository layer is responsible for catching that and
/// converting it to an [ApiResult.failure] via [ErrorHandler].
abstract class PaymentRemoteDataSource {
  Future<BaseResponse<SuccessResponseModel>> saveRestaurantPosInvoice(
    SaveRestaurantPosInvoiceRequest request,
  );
  Future<BaseResponse<List<PaymentMethodResponseModel>?>>
  getListOfPaymentMethods();
}

class PaymentRemoteDataSourceImpl implements PaymentRemoteDataSource {
  final ApiService _apiService;

  PaymentRemoteDataSourceImpl(this._apiService);

  @override
  Future<BaseResponse<SuccessResponseModel>> saveRestaurantPosInvoice(
    SaveRestaurantPosInvoiceRequest request,
  ) {
    return _apiService.saveRestaurantPosInvoice(request);
  }

  @override
  Future<BaseResponse<List<PaymentMethodResponseModel>?>>
  getListOfPaymentMethods() {
    return _apiService.getListOfPaymentMethods();
  }
}

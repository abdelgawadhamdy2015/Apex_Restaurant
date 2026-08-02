import 'package:apex_restaurant/core/service/api_service.dart';
import 'package:apex_restaurant/core/shared/model/base_response.dart';
import 'package:apex_restaurant/featchers/cart/data/models/invoice_request_model.dart';

/// Talks directly to `ApiService`. Throws on failure (DioException or
/// otherwise) — the repository layer is responsible for catching that and
/// converting it to an [ApiResult.failure] via [ErrorHandler].
abstract class PaymentRemoteDataSource {
  Future<BaseResponse<dynamic>> saveRestaurantPosInvoice(
    SaveInvoiceRequestModel request,
  );
}

class PaymentRemoteDataSourceImpl implements PaymentRemoteDataSource {
  final ApiService _apiService;

  PaymentRemoteDataSourceImpl(this._apiService);

  @override
  Future<BaseResponse<dynamic>> saveRestaurantPosInvoice(
    SaveInvoiceRequestModel request,
  ) {
    return _apiService.saveRestaurantPosInvoice(request);
  }
}

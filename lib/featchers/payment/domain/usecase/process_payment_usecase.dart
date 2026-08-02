import 'package:apex_restaurant/core/service/api_result.dart';
import 'package:apex_restaurant/core/shared/model/base_response.dart';
import 'package:apex_restaurant/featchers/cart/data/models/invoice_request_model.dart';
import 'package:apex_restaurant/featchers/payment/domain/repo/payment_repository.dart';

class SaveRestaurantPosInvoice {
  final PaymentRepository repository;

  SaveRestaurantPosInvoice(this.repository);

  Future<ApiResult<BaseResponse<dynamic>>> call(
    SaveInvoiceRequestModel request,
  ) {
    return repository.saveRestaurantPosInvoice(request);
  }
}

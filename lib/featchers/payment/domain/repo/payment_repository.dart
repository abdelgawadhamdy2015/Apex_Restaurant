import 'package:apex_restaurant/core/service/api_result.dart';
import 'package:apex_restaurant/core/shared/model/base_response.dart';
import 'package:apex_restaurant/featchers/cart/data/models/invoice_request_model.dart';

abstract class PaymentRepository {
  Future<ApiResult<BaseResponse<dynamic>>> saveRestaurantPosInvoice(
    SaveInvoiceRequestModel request,
  );
}

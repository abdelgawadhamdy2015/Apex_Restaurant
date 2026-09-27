import 'package:apex_restaurant/featchers/payment/data/model/payment_method_response_model.dart';

import '../../../../core/service/api_result.dart';
import '../../../../core/shared/model/base_response.dart';
import '../../../cart/data/models/invoice_request.dart';
import '../../data/model/success_response_model.dart';

abstract class PaymentRepository {
  Future<ApiResult<BaseResponse<SuccessResponseModel>>>
  saveRestaurantPosInvoice(SaveRestaurantPosInvoiceRequest request);
  Future<ApiResult<BaseResponse<List<PaymentMethodResponseModel>?>>>
  getListOfPaymentMethods();
}

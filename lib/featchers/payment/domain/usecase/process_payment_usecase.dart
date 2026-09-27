import 'package:apex_restaurant/featchers/payment/data/model/payment_method_response_model.dart';

import '../../../../core/service/api_result.dart';
import '../../../../core/shared/model/base_response.dart';
import '../../../cart/data/models/invoice_request.dart';
import '../../data/model/success_response_model.dart';
import '../repo/payment_repository.dart';

class SavePaymentRestaurantPosInvoiceUseCase {
  final PaymentRepository repository;

  SavePaymentRestaurantPosInvoiceUseCase(this.repository);

  Future<ApiResult<BaseResponse<SuccessResponseModel>>> call(
    SaveRestaurantPosInvoiceRequest request,
  ) {
    return repository.saveRestaurantPosInvoice(request);
  }
}

class PaymentMethodsUseCase {
  final PaymentRepository repository;

  PaymentMethodsUseCase(this.repository);

  Future<ApiResult<BaseResponse<List<PaymentMethodResponseModel>?>>>
  call() async {
    return await repository.getListOfPaymentMethods();
  }
}

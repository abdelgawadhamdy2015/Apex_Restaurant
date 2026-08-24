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

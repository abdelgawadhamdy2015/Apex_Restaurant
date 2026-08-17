import '../../../../core/service/api_result.dart';
import '../../../../core/shared/model/base_response.dart';
import '../../data/model/get_pinding_invoice.dart';
import '../../data/model/get_previous_invoice_request.dart';
import '../../data/model/pinding_invoice_model.dart';
import '../../data/model/previous_invoice_model.dart';
import '../../data/model/restored_invoice_model.dart';
import '../repo/orders_repository.dart';

class GetPreviousOrdersUseCase {
  final OrdersRepository repository;
  GetPreviousOrdersUseCase(this.repository);
  Future<ApiResult<BaseResponse<List<PreviousInvoiceModel>?>>> call({
    required GetPreviousInvoiceRequest request,
  }) => repository.getPreviousOrders(request: request);
}

class GetPindingInvoicesUseCase {
  final OrdersRepository repository;
  GetPindingInvoicesUseCase(this.repository);
  Future<ApiResult<BaseResponse<List<PindingInvoiceModel>?>>> call({
    GetPindingInvoicesRequest? request,
  }) => repository.getPindingInvoices(request: request);
}

class RestoreHeldOrderUseCase {
  final OrdersRepository repository;
  RestoreHeldOrderUseCase(this.repository);
  Future<ApiResult<BaseResponse<RestoredInvoiceModel?>>> call(int invoiceId) =>
      repository.restorePosRestuarantInvoice(invoiceId);
}

class DeleteHeldOrderUseCase {
  final OrdersRepository repository;
  DeleteHeldOrderUseCase(this.repository);
  Future<void> call(String orderId) => repository.deleteHeldOrder(orderId);
}

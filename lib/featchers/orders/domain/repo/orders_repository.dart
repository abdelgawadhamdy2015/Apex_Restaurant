import '../../../../core/service/api_result.dart';
import '../../../../core/shared/model/base_response.dart';
import '../../data/model/get_pinding_invoice.dart';
import '../../data/model/get_previous_invoice_request.dart';
import '../../data/model/pinding_invoice_model.dart';
import '../../data/model/previous_invoice_model.dart';
import '../../data/model/restored_invoice_model.dart';

abstract class OrdersRepository {
  Future<ApiResult<BaseResponse<List<PreviousInvoiceModel>?>>>
  getPreviousOrders({required GetPreviousInvoiceRequest request});
  Future<ApiResult<BaseResponse<List<PindingInvoiceModel>?>>>
  getPindingInvoices({GetPindingInvoicesRequest? request});

  Future<ApiResult<BaseResponse<RestoredInvoiceModel?>>> getPosInvoiceDataById(
    int invoiceId,
  );
  Future<ApiResult<BaseResponse<dynamic>>> deleteHeldOrder({
    int? id,
    String? foodTableId,
  });
}

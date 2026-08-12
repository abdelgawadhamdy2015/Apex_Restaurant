import 'package:apex_restaurant/core/service/api_result.dart';
import 'package:apex_restaurant/core/shared/model/base_response.dart';
import 'package:apex_restaurant/featchers/orders/data/model/get_pinding_invoice.dart';
import 'package:apex_restaurant/featchers/orders/data/model/get_previous_invoice_request.dart';
import 'package:apex_restaurant/featchers/orders/data/model/pinding_invoice_model.dart';
import 'package:apex_restaurant/featchers/orders/data/model/previous_invoice_model.dart';
import 'package:apex_restaurant/featchers/orders/data/model/restored_invoice_model.dart';

abstract class OrdersRepository {
  Future<ApiResult<BaseResponse<List<PreviousInvoiceModel>?>>>
  getPreviousOrders({required GetPreviousInvoiceRequest request});
  Future<ApiResult<BaseResponse<List<PindingInvoiceModel>?>>>
  getPindingInvoices({GetPindingInvoicesRequest? request});
  Future<ApiResult<BaseResponse<List<PindingInvoiceModel>?>>>
  getRestaurantPosBookingTable({GetPindingInvoicesRequest? request});

  Future<ApiResult<BaseResponse<RestoredInvoiceModel?>>>
  restorePosRestuarantInvoice(int invoiceId);
  Future<void> deleteHeldOrder(String orderId);
}

import '../../../../core/service/api_service.dart';
import '../../../../core/shared/model/base_response.dart';
import '../model/get_pinding_invoice.dart';
import '../model/get_previous_invoice_request.dart';
import '../model/pinding_invoice_model.dart';
import '../model/previous_invoice_model.dart';
import '../model/restored_invoice_model.dart';

abstract class OrdersRemoteDataSource {
  Future<BaseResponse<List<PreviousInvoiceModel>?>> getPreviousOrders({
    required GetPreviousInvoiceRequest request,
  });
  Future<BaseResponse<List<PindingInvoiceModel>?>> getPindingInvoices({
    GetPindingInvoicesRequest? request,
  });
  Future<BaseResponse<List<PindingInvoiceModel>?>>
  getRestaurantPosBookingTable({GetPindingInvoicesRequest? request});
  Future<BaseResponse<RestoredInvoiceModel?>> restorePosRestuarantInvoice(
    int invoiceId,
  );
  Future<void> deleteHeldOrder(String orderId);
}

class OrdersRemoteDataSourceImpl implements OrdersRemoteDataSource {
  final ApiService apiService;
  OrdersRemoteDataSourceImpl(this.apiService);
  @override
  Future<BaseResponse<List<PreviousInvoiceModel>?>> getPreviousOrders({
    required GetPreviousInvoiceRequest request,
  }) async {
    return await apiService.getListPosInvoiceData(request);
  }

  @override
  Future<BaseResponse<List<PindingInvoiceModel>?>> getPindingInvoices({
    GetPindingInvoicesRequest? request,
  }) async {
    return await apiService.getPendingRestaurantPosInvoiceDetails(request);
  }

  @override
  Future<BaseResponse<List<PindingInvoiceModel>?>>
  getRestaurantPosBookingTable({GetPindingInvoicesRequest? request}) async {
    return await apiService.getRestaurantPosBookingTable(request);
  }

  @override
  Future<BaseResponse<RestoredInvoiceModel?>> restorePosRestuarantInvoice(
    int invoiceId,
  ) async {
    return await apiService.getPosInvoiceDataById(invoiceId);
  }

  @override
  Future<void> deleteHeldOrder(String orderId) async {}
}

import 'package:apex_restaurant/featchers/orders/data/model/get_pinding_invoice.dart';
import 'package:apex_restaurant/featchers/orders/data/model/pinding_invoice_model.dart';
import 'package:apex_restaurant/featchers/orders/data/model/restored_invoice_model.dart';

import '../../../../core/service/api_service.dart';
import '../../../../core/shared/model/base_response.dart';
import '../../../pos/data/models/floor_model.dart';
import '../models/get_floor_request.dart';
import '../models/get_reservations_request.dart';
import '../models/get_table_request.dart';
import '../models/reservation_requests.dart';
import '../models/reservations_data.dart';
import '../models/table_model.dart';

abstract class TablesRemoteDataSource {
  Future<BaseResponse<ReservationsData?>> fetchReservations(
    GetReservationRequest request,
  );
  Future<BaseResponse<dynamic>> addReservation(
    ReserveFoodTableRequest reservation,
  );
  Future<BaseResponse<dynamic>> editReservation(
    EditReserveFoodTableRequest reservation,
  );
  Future<BaseResponse<dynamic>> cancelReservation(
    CancelReserveFoodTableRequest request,
  );

  Future<BaseResponse<List<FloorModel>?>> getFloors({
    required GetFloorsRequest request,
  });

  Future<BaseResponse<List<TableModel>?>> getTables({
    required GetTablesRequest request,
  });

  Future<BaseResponse<List<PindingInvoiceModel>?>>
  getRestaurantPosBookingTableInvoice({GetPindingInvoicesRequest? request});
  Future<BaseResponse<RestoredInvoiceModel?>> restorePosRestuarantInvoice(
    int invoiceId,
  );
}

class TablesRemoteDataSourceImpl implements TablesRemoteDataSource {
  final ApiService _apiService;

  TablesRemoteDataSourceImpl(this._apiService);

  @override
  Future<BaseResponse<List<FloorModel>?>> getFloors({
    required GetFloorsRequest request,
  }) async {
    return await _apiService.getAllFloors(request);
  }

  @override
  Future<BaseResponse<List<TableModel>?>> getTables({
    required GetTablesRequest request,
  }) async {
    return await _apiService.getAllFoodTables(request);
  }

  @override
  Future<BaseResponse<ReservationsData>> fetchReservations(
    GetReservationRequest request,
  ) async {
    return await _apiService.getAllReservation(request);
  }

  @override
  Future<BaseResponse<dynamic>> addReservation(
    ReserveFoodTableRequest reservation,
  ) async {
    return await _apiService.reserveFoodTable(reservation);
  }

  @override
  Future<BaseResponse<dynamic>> editReservation(
    EditReserveFoodTableRequest reservation,
  ) async {
    return await _apiService.editReserveFoodTable(reservation);
  }

  @override
  Future<BaseResponse<dynamic>> cancelReservation(
    CancelReserveFoodTableRequest request,
  ) async {
    return await _apiService.cancelReserveFoodTable(request);
  }

  @override
  Future<BaseResponse<List<PindingInvoiceModel>?>>
  getRestaurantPosBookingTableInvoice({
    GetPindingInvoicesRequest? request,
  }) async {
    return await _apiService.getRestaurantPosBookingTable(request);
  }

  @override
  Future<BaseResponse<RestoredInvoiceModel?>> restorePosRestuarantInvoice(
    int invoiceId,
  ) async {
    return await _apiService.getPosInvoiceDataById(invoiceId);
  }
}

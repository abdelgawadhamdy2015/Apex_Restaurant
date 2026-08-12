import 'dart:developer';

import 'package:apex_restaurant/core/service/api_error_handler.dart';
import 'package:apex_restaurant/core/service/api_result.dart';
import 'package:apex_restaurant/core/shared/model/base_response.dart';
import 'package:apex_restaurant/featchers/orders/data/datasource/orders_remote_data_source.dart';
import 'package:apex_restaurant/featchers/orders/data/model/get_pinding_invoice.dart';
import 'package:apex_restaurant/featchers/orders/data/model/get_previous_invoice_request.dart';
import 'package:apex_restaurant/featchers/orders/data/model/pinding_invoice_model.dart';
import 'package:apex_restaurant/featchers/orders/data/model/previous_invoice_model.dart';
import 'package:apex_restaurant/featchers/orders/data/model/restored_invoice_model.dart';
import 'package:apex_restaurant/featchers/orders/domain/repo/orders_repository.dart';

class OrdersRepositoryImpl implements OrdersRepository {
  final OrdersRemoteDataSource remoteDataSource;

  OrdersRepositoryImpl(this.remoteDataSource);

  @override
  Future<ApiResult<BaseResponse<List<PreviousInvoiceModel>?>>>
  getPreviousOrders({required GetPreviousInvoiceRequest request}) async {
    try {
      final response = await remoteDataSource.getPreviousOrders(
        request: request,
      );
      return ApiResult.success(response);
    } catch (e, s) {
      log("$e , \n $s");
      return ApiResult.failure(ErrorHandler.handle(e));
    }
  }

  @override
  Future<ApiResult<BaseResponse<List<PindingInvoiceModel>?>>>
  getPindingInvoices({GetPindingInvoicesRequest? request}) async {
    try {
      final response = await remoteDataSource.getPindingInvoices(
        request: request,
      );
      return ApiResult.success(response);
    } catch (e, s) {
      log("$e , \n $s");
      return ApiResult.failure(ErrorHandler.handle(e));
    }
  }

  @override
  Future<ApiResult<BaseResponse<List<PindingInvoiceModel>?>>>
  getRestaurantPosBookingTable({GetPindingInvoicesRequest? request}) async {
    try {
      final response = await remoteDataSource.getPindingInvoices(
        request: request,
      );
      return ApiResult.success(response);
    } catch (e, s) {
      log("$e , \n $s");
      return ApiResult.failure(ErrorHandler.handle(e));
    }
  }

  @override
  Future<ApiResult<BaseResponse<RestoredInvoiceModel?>>>
  restorePosRestuarantInvoice(int invoiceId) async {
    try {
      final response = await remoteDataSource.restorePosRestuarantInvoice(
        invoiceId,
      );
      return ApiResult.success(response);
    } catch (e, s) {
      log("$e , \n $s");
      return ApiResult.failure(ErrorHandler.handle(e));
    }
  }

  @override
  Future<void> deleteHeldOrder(String orderId) =>
      remoteDataSource.deleteHeldOrder(orderId);
}

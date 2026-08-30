import 'package:flutter/material.dart';

import '../../../../core/service/api_error_handler.dart';
import '../../../../core/service/api_result.dart';
import '../../../../core/shared/model/base_response.dart';
import '../datasource/orders_remote_data_source.dart';
import '../model/get_pinding_invoice.dart';
import '../model/get_previous_invoice_request.dart';
import '../model/pinding_invoice_model.dart';
import '../model/previous_invoice_model.dart';
import '../model/restored_invoice_model.dart';
import '../../domain/repo/orders_repository.dart';

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
      debugPrint("$e , \n $s");
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
      debugPrint("$e , \n $s");
      return ApiResult.failure(ErrorHandler.handle(e));
    }
  }

  @override
  Future<ApiResult<BaseResponse<RestoredInvoiceModel?>>> getPosInvoiceDataById(
    int invoiceId,
  ) async {
    try {
      final response = await remoteDataSource.getPosInvoiceDataById(invoiceId);
      return ApiResult.success(response);
    } catch (e, s) {
      debugPrint("$e , \n $s");
      return ApiResult.failure(ErrorHandler.handle(e));
    }
  }

  @override
  Future<ApiResult<BaseResponse<dynamic>>> deleteHeldOrder({
    int? id,
    String? foodTableId,
  }) async {
    try {
      final response = await remoteDataSource.deleteHeldOrder(
        id: id,
        foodTableId: foodTableId,
      );
      return ApiResult.success(response);
    } catch (e, s) {
      debugPrint("$e , \n $s");
      return ApiResult.failure(ErrorHandler.handle(e));
    }
  }
}

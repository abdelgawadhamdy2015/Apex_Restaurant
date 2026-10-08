import 'package:apex_restaurant/core/service/api_error_handler.dart';
import 'package:apex_restaurant/core/service/api_result.dart';
import 'package:apex_restaurant/core/shared/datasource/shared_datasource.dart';
import 'package:apex_restaurant/core/shared/model/base_response.dart';
import 'package:apex_restaurant/core/shared/model/print_kitchen_request.dart';
import 'package:apex_restaurant/core/shared/model/print_kitchen_response.dart';
import 'package:apex_restaurant/core/shared/model/return_request.dart';
import 'package:apex_restaurant/core/shared/model/return_response.dart';
import 'package:apex_restaurant/featchers/orders/data/model/invoice_report_request.dart';
import 'package:apex_restaurant/featchers/orders/data/model/invoice_report_response.dart';
import 'package:flutter/material.dart';

abstract class SharedRepository {
  Future<ApiResult<BaseResponse<PrintKitchenResponse?>>> printKitchen({
    required PrintKitchenRequest request,
  });
  Future<ApiResult<InvoiceReportResponse?>> getInvoiceReport({
    required InvoiceReportRequest request,
  });
  Future<ApiResult<BaseResponse<ReturnResponseData?>>>
  saveRestaurantPosReturnInvoice({required ReturnRequest request});
}

class SharedRepositoryImpl implements SharedRepository {
  final SharedDatasource _datasource;
  SharedRepositoryImpl(this._datasource);

  @override
  Future<ApiResult<BaseResponse<PrintKitchenResponse?>>> printKitchen({
    required PrintKitchenRequest request,
  }) async {
    try {
      final response = await _datasource.printKitchen(request: request);
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }

  @override
  Future<ApiResult<InvoiceReportResponse?>> getInvoiceReport({
    required InvoiceReportRequest request,
  }) async {
    try {
      final response = await _datasource.getInvoiceReport(request: request);
      return ApiResult.success(response);
    } catch (e, s) {
      debugPrint("$e , \n $s");
      return ApiResult.failure(ErrorHandler.handle(e));
    }
  }

  @override
  Future<ApiResult<BaseResponse<ReturnResponseData?>>>
  saveRestaurantPosReturnInvoice({required ReturnRequest request}) async {
    try {
      final response = await _datasource.saveRestaurantPosPartialReturnInvoice(
        request: request,
      );
      return ApiResult.success(response);
    } catch (e, s) {
      debugPrint("$e , \n $s");
      return ApiResult.failure(ErrorHandler.handle(e));
    }
  }
}

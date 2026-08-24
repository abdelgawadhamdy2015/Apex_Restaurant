import 'package:apex_restaurant/core/service/api_error_handler.dart';
import 'package:apex_restaurant/core/service/api_result.dart';
import 'package:apex_restaurant/core/shared/model/base_response.dart';
import 'package:apex_restaurant/featchers/more_actions/data/datasource/more_action_datasource.dart';
import 'package:apex_restaurant/featchers/more_actions/data/model/add_pos_total_return_invoice_request.dart';
import 'package:apex_restaurant/featchers/more_actions/data/model/get_all_pos_invoice_request.dart';
import 'package:apex_restaurant/featchers/more_actions/data/model/pos_invoice_data.dart';
import 'package:apex_restaurant/featchers/more_actions/domain/repo/more_actions_repo.dart';
import 'package:flutter/material.dart';

class MoreActionRepoImp extends MoreActionsRepo {
  final MoreActionDatasource remoteDataSource;

  MoreActionRepoImp(this.remoteDataSource);
  @override
  Future<ApiResult<BaseResponse<PosInvoiceData?>>> addPOSResturnInvoice({
    required GetAllPosInvoiceRequest request,
  }) async {
    try {
      final response = await remoteDataSource.addPOSResturnInvoice(
        request: request,
      );
      return ApiResult.success(response);
    } catch (e, s) {
      debugPrint("$e , \n $s");
      return ApiResult.failure(ErrorHandler.handle(e));
    }
  }

  @override
  Future<ApiResult<BaseResponse<PosInvoiceData?>>> addPOSTotalReturnInvoice({
    required AddPOSTotalReturnInvoiceRequest request,
  }) async {
    try {
      final response = await remoteDataSource.addPOSTotalReturnInvoice(
        request: request,
      );
      return ApiResult.success(response);
    } catch (e, s) {
      debugPrint("$e , \n $s");
      return ApiResult.failure(ErrorHandler.handle(e));
    }
  }

  @override
  Future<ApiResult<BaseResponse<List<PosInvoiceData>?>>> getAllPosInvoice({
    required GetAllPosInvoiceRequest request,
  }) async {
    try {
      final response = await remoteDataSource.getAllPosInvoice(
        request: request,
      );
      return ApiResult.success(response);
    } catch (e, s) {
      debugPrint("$e , \n $s");
      return ApiResult.failure(ErrorHandler.handle(e));
    }
  }
}

import 'dart:developer';

import '../../../../core/service/api_error_handler.dart';
import '../../../../core/service/api_result.dart';
import '../../../../core/shared/entity/base_request.dart';
import '../../../../core/shared/model/base_response.dart';
import '../datasource/cart_remote_datasource.dart';
import '../models/apply_discount_request_model.dart';
import '../models/client_request_model.dart';
import '../models/dynamic_discount.dart';
import '../models/get_client_request.dart';
import '../models/invoice_request.dart';
import '../models/pos_client_model.dart';
import '../../domain/repo/cart_repo.dart';

import '../models/discount_result_model.dart';
import '../models/waiter_model.dart';

class CartRepositoryImpl implements CartRepository {
  final CartRemoteDataSource _remoteDataSource;
  CartRepositoryImpl(this._remoteDataSource);

  @override
  Future<ApiResult<BaseResponse<List<WaiterModel>?>>> getDeliveryAgents({
    BaseRequest? request,
  }) async {
    try {
      final response = await _remoteDataSource.getDeliveryAgents(
        request: request,
      );
      return ApiResult.success(response);
    } catch (error, s) {
      log("$error, \n $s");

      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }

  @override
  Future<ApiResult<BaseResponse<List<WaiterModel>?>>> getWaiters({
    BaseRequest? request,
  }) async {
    try {
      final response = await _remoteDataSource.getWaiters(request: request);
      return ApiResult.success(response);
    } catch (error, s) {
      log("$error, \n $s");

      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }

  @override
  Future<ApiResult<BaseResponse<DiscountResultModel?>>> applyDiscount(
    ApplyDiscountRequestModel request,
  ) async {
    try {
      final response = await _remoteDataSource.applyDiscount(request);
      return ApiResult.success(response);
    } catch (error, s) {
      log("$error, \n $s");

      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }

  @override
  Future<ApiResult<BaseResponse<dynamic>>> savePendingRestaurantPosInvoice(
    SaveRestaurantPosInvoiceRequest request,
  ) async {
    try {
      final response = await _remoteDataSource.savePendingRestaurantPosInvoice(
        request,
      );
      return ApiResult.success(response);
    } catch (error, s) {
      log("$error, \n $s");
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }

  @override
  Future<ApiResult<BaseResponse<dynamic>>> saveBookingTableRestaurantPosInvoice(
    SaveRestaurantPosInvoiceRequest request,
  ) async {
    try {
      final response = await _remoteDataSource
          .saveBookingTableRestaurantPosInvoice(request);
      return ApiResult.success(response);
    } catch (error, s) {
      log("$error, \n $s");

      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }

  @override
  Future<ApiResult<BaseResponse<List<PosClientModel>?>>> getPosClients({
    required GetClientsRequest request,
  }) async {
    try {
      final response = await _remoteDataSource.getPersons(request: request);
      return ApiResult.success(response);
    } catch (error, s) {
      log("$error\n ${s.toString()}");
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }

  @override
  Future<ApiResult<BaseResponse<dynamic>>> addPosClient({
    required ClientRequestModel request,
  }) async {
    try {
      final response = await _remoteDataSource.addPosClient(request: request);
      return ApiResult.success(response);
    } catch (error, s) {
      log("$error, \n $s");

      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }

  @override
  Future<ApiResult<BaseResponse<dynamic>>> updatePosClient({
    required ClientRequestModel request,
  }) async {
    try {
      final response = await _remoteDataSource.updatePosClient(
        request: request,
      );
      return ApiResult.success(response);
    } catch (error, s) {
      log("$error, \n $s");

      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }

  @override
  Future<ApiResult<BaseResponse<List<DynamicDiscountModel>?>>>
  getDynamicInvoiceDiscount() async {
    try {
      final response = await _remoteDataSource.getDynamicInvoiceDiscount();
      return ApiResult.success(response);
    } catch (error, s) {
      log("$error, \n $s");

      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }
}

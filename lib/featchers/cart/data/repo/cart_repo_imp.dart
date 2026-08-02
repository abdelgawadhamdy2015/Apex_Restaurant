import 'dart:developer';

import 'package:apex_restaurant/core/service/api_error_handler.dart';
import 'package:apex_restaurant/core/service/api_result.dart';
import 'package:apex_restaurant/core/shared/entity/base_request.dart';
import 'package:apex_restaurant/core/shared/model/base_response.dart';
import 'package:apex_restaurant/featchers/cart/data/datasource/cart_remote_datasource.dart';
import 'package:apex_restaurant/featchers/cart/data/models/apply_discount_request_model.dart';
import 'package:apex_restaurant/featchers/cart/data/models/client_request_model.dart';
import 'package:apex_restaurant/featchers/cart/data/models/dynamic_discount.dart';
import 'package:apex_restaurant/featchers/cart/data/models/get_client_request.dart';
import 'package:apex_restaurant/featchers/cart/data/models/pos_client_model.dart';
import 'package:apex_restaurant/featchers/cart/domain/repo/cart_repo.dart';
import 'package:apex_restaurant/featchers/pos/domain/entities/menu_item.dart';

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
    } catch (error) {
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
    } catch (error) {
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
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }

  @override
  Future<ApiResult<BaseResponse<dynamic>>> holdOrder(Order order) async {
    try {
      final response = await _remoteDataSource.holdOrder(order);
      return ApiResult.success(response);
    } catch (error) {
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
    } catch (error) {
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
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }

  @override
  Future<ApiResult<BaseResponse<List<DynamicDiscountModel>?>>>
  getDynamicInvoiceDiscount() async {
    try {
      final response = await _remoteDataSource.getDynamicInvoiceDiscount();
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }
}

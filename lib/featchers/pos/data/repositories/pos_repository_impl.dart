import 'dart:developer';

import 'package:apex_restaurant/core/service/api_error_handler.dart';
import 'package:apex_restaurant/core/service/api_result.dart';
import 'package:apex_restaurant/core/shared/entity/base_request.dart';
import 'package:apex_restaurant/core/shared/model/base_response.dart';
import 'package:apex_restaurant/core/shared/model/settings_model.dart';
import 'package:apex_restaurant/featchers/pos/data/datasources/pos_remote_datasource.dart';
import 'package:apex_restaurant/featchers/pos/data/models/category_model.dart';
import 'package:apex_restaurant/featchers/pos/data/models/delivery_company.dart';
import 'package:apex_restaurant/featchers/pos/data/models/floor_model.dart';
import 'package:apex_restaurant/featchers/pos/data/models/restaurant_item.dart';
import 'package:apex_restaurant/featchers/tables/data/models/get_floor_request.dart';
import 'package:apex_restaurant/featchers/pos/domain/entities/get_food_additive_request.dart';
import 'package:apex_restaurant/featchers/pos/domain/entities/get_items_request_model.dart';
import 'package:apex_restaurant/featchers/tables/data/models/get_table_request.dart';
import 'package:apex_restaurant/featchers/pos/domain/entities/menu_item.dart';
import 'package:apex_restaurant/featchers/pos/domain/repositories/pos_repository.dart';
import 'package:apex_restaurant/featchers/tables/data/models/table_model.dart';

class PosRepositoryImpl implements PosRepository {
  final PosRemoteDataSource _remoteDataSource;

  PosRepositoryImpl(this._remoteDataSource);

  @override
  Future<ApiResult<BaseResponse<List<CategoryModel>?>>>
  getMenuCategories() async {
    try {
      final response = await _remoteDataSource.getMenuCategories();
      return ApiResult.success(response);
    } catch (e, s) {
      log("$e\n$s");

      return ApiResult.failure(ErrorHandler.handle(e));
    }
  }

  @override
  Future<ApiResult<BaseResponse<List<RestaurantItem>?>>> getMenuItemsByCategory(
    GetItemsRequest? request,
  ) async {
    try {
      final response = await _remoteDataSource.getMenuItemsByCategory(
        request: request,
      );
      return ApiResult.success(response);
    } catch (e, s) {
      log("$e\n$s");

      return ApiResult.failure(ErrorHandler.handle(e));
    }
  }

  @override
  Future<void> sendToKitchen(Order order) async {
    final data = _orderToMap(order);
    await _remoteDataSource.sendToKitchen(data);
  }

  @override
  Future<void> submitOrder(Order order) async {
    final data = _orderToMap(order);
    await _remoteDataSource.submitOrder(data);
  }

  Map<String, dynamic> _orderToMap(Order order) => {
    'table_id': order.tableId,
    'items': order.items
        .map(
          (item) => {
            'menu_item_id': item.menuItem.itemId,
            'quantity': item.quantity,
            'notes': item.notes,
            'addons': item.addons,
          },
        )
        .toList(),
    'subtotal': order.subtotal,
    'tax': order.tax,
    'total': order.total,
  };

  @override
  Future<ApiResult<BaseResponse<List<FloorModel>?>>> getFloors({
    required GetFloorsRequest request,
  }) async {
    try {
      final response = await _remoteDataSource.getFloors(request: request);
      return ApiResult.success(response);
    } catch (e, s) {
      log("$e\n$s");
      return ApiResult.failure(ErrorHandler.handle(e));
    }
  }

  @override
  Future<ApiResult<BaseResponse<List<TableModel>?>>> getTables({
    required GetTablesRequest request,
  }) async {
    try {
      final response = await _remoteDataSource.getTables(request: request);
      return ApiResult.success(response);
    } catch (e, s) {
      log("$e\n$s");

      return ApiResult.failure(ErrorHandler.handle(e));
    }
  }

  @override
  Future<ApiResult<BaseResponse<List<AdditiveModel>?>>> getFoodAdditives(
    GetFoodAdditivesRequest? request,
  ) async {
    try {
      final response = await _remoteDataSource.getFoodAdditives(
        request: request,
      );
      return ApiResult.success(response);
    } catch (e, s) {
      log("$e\n$s");
      return ApiResult.failure(ErrorHandler.handle(e));
    }
  }

  @override
  Future<ApiResult<BaseResponse<List<DeliveryCompanyModel>?>>>
  getAllDeliveryCompany({BaseRequest? request}) async {
    try {
      final response = await _remoteDataSource.getAllDeliveryCompany(
        request: request,
      );
      return ApiResult.success(response);
    } catch (e, s) {
      log("$e\n$s");

      return ApiResult.failure(ErrorHandler.handle(e));
    }
  }

  @override
  Future<ApiResult<BaseResponse<SettingsModel?>>> getSettings() async {
    try {
      final response = await _remoteDataSource.getSettings();
      return ApiResult.success(response);
    } catch (e, s) {
      log("$e\n$s");

      return ApiResult.failure(ErrorHandler.handle(e));
    }
  }
}

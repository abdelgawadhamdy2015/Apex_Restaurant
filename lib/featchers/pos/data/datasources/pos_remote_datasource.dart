import 'package:apex_restaurant/core/service/api_service.dart';
import 'package:apex_restaurant/core/shared/entity/base_request.dart';
import 'package:apex_restaurant/core/shared/model/base_response.dart';
import 'package:apex_restaurant/core/shared/model/settings_model.dart';
import 'package:apex_restaurant/featchers/pos/data/models/category_model.dart';
import 'package:apex_restaurant/featchers/pos/data/models/delivery_company.dart';
import 'package:apex_restaurant/featchers/pos/data/models/floor_model.dart';
import 'package:apex_restaurant/featchers/pos/data/models/restaurant_item.dart';
import 'package:apex_restaurant/featchers/pos/domain/entities/get_food_additive_request.dart';
import 'package:apex_restaurant/featchers/pos/domain/entities/get_items_request_model.dart';
import 'package:apex_restaurant/featchers/tables/data/models/get_floor_request.dart';
import 'package:apex_restaurant/featchers/tables/data/models/get_table_request.dart';
import 'package:apex_restaurant/featchers/tables/data/models/table_model.dart';

abstract class PosRemoteDataSource {
  Future<BaseResponse<SettingsModel?>> getSettings();

  Future<BaseResponse<List<FloorModel>?>> getFloors({
    required GetFloorsRequest request,
  });

  Future<BaseResponse<List<TableModel>?>> getTables({
    required GetTablesRequest request,
  });

  Future<BaseResponse<List<AdditiveModel>?>> getFoodAdditives({
    GetFoodAdditivesRequest? request,
  });

  Future<BaseResponse<List<CategoryModel>?>> getMenuCategories();

  Future<BaseResponse<List<RestaurantItem>?>> getMenuItemsByCategory({
    GetItemsRequest? request,
  });

  Future<void> submitOrder(Map<String, dynamic> orderData);

  Future<void> sendToKitchen(Map<String, dynamic> orderData);

  Future<BaseResponse<List<DeliveryCompanyModel>?>> getAllDeliveryCompany({
    BaseRequest? request,
  });
}

class PosRemoteDataSourceImpl implements PosRemoteDataSource {
  final ApiService _apiService;

  PosRemoteDataSourceImpl(this._apiService);

  @override
  Future<BaseResponse<List<CategoryModel>?>> getMenuCategories() async {
    return await _apiService.getAllCategories();
  }

  @override
  Future<BaseResponse<List<RestaurantItem>?>> getMenuItemsByCategory({
    GetItemsRequest? request,
  }) async {
    return await _apiService.getItemsByCategory(
      request ?? const GetItemsRequest(),
    );
  }

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
  Future<BaseResponse<List<AdditiveModel>?>> getFoodAdditives({
    GetFoodAdditivesRequest? request,
  }) async {
    return await _apiService.getAllFoodAdditives(request);
  }

  @override
  Future<BaseResponse<List<DeliveryCompanyModel>?>> getAllDeliveryCompany({
    BaseRequest? request,
  }) async {
    final queryRequest = BaseRequest(
      pageNumber: request?.pageNumber,
      pageSize: request?.pageSize,
      name: request?.name,
    );

    return await _apiService.getAllDeliveryCompany(queryRequest);
  }

  @override
  Future<void> submitOrder(Map<String, dynamic> orderData) async {
    // await _apiService.post('/orders', data: orderData);
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<void> sendToKitchen(Map<String, dynamic> orderData) async {
    // await _dio.post('/orders/kitchen', data: orderData);
    await Future.delayed(const Duration(milliseconds: 300));
  }

  @override
  Future<BaseResponse<SettingsModel?>> getSettings() async {
    return await _apiService.getSettings();
  }
}

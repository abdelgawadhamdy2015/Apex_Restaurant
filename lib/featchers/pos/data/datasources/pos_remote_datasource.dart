import 'package:apex_restaurant/core/service/api_service.dart';
import 'package:apex_restaurant/core/shared/entity/base_request.dart';
import 'package:apex_restaurant/core/shared/model/base_response.dart';
import 'package:apex_restaurant/featchers/pos/data/models/category_model.dart';
import 'package:apex_restaurant/featchers/pos/data/models/delivery_company.dart';
import 'package:apex_restaurant/featchers/pos/data/models/floor_model.dart';
import 'package:apex_restaurant/featchers/pos/data/models/restaurant_item.dart';
import 'package:apex_restaurant/featchers/pos/domain/entities/get_floor_request.dart';
import 'package:apex_restaurant/featchers/pos/domain/entities/get_food_additive_request.dart';
import 'package:apex_restaurant/featchers/pos/domain/entities/get_items_request_model.dart';
import 'package:apex_restaurant/featchers/pos/data/models/table_model.dart';
import 'package:apex_restaurant/featchers/pos/domain/entities/get_table_request.dart';

abstract class PosRemoteDataSource {
  Future<BaseResponse<List<FloorModel>?>> getFloors({
    required GetFloorsRequestModel request,
  });
  Future<BaseResponse<List<TableModel>?>> getTables({
    required GetTablesRequestModel request,
  });

  Future<BaseResponse<List<AdditiveModel>?>> getFoodAdditives({
    GetFoodAdditiveRequest? request,
  });
  Future<BaseResponse<List<CategoryModel>?>> getMenuCategories();
  Future<BaseResponse<List<RestaurantItem>?>> getMenuItemsByCategory({
    GetItemsRequestModel? request,
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
    return _apiService.getAllCategories().then((response) {
      return response;
    });
  }

  @override
  Future<BaseResponse<List<RestaurantItem>?>> getMenuItemsByCategory({
    GetItemsRequestModel? request,
  }) async {
    return await _apiService
        .getItemsByCategory(
          pageNumber: request?.pageNumber,
          pageSize: request?.pageSize,
          statues: request?.status,
          name: request?.name,
          categoryId: request?.categoryId,
          companyId: request?.companyId,
          searchKey: request?.searchKey,
        )
        .then((response) {
          return response;
        });
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
  Future<BaseResponse<List<FloorModel>?>> getFloors({
    required GetFloorsRequestModel request,
  }) async {
    return await _apiService.getAllFloors(
      pageNumber: request.pageNumber,
      pageSize: request.pageSize,
      id: request.id,
      name: request.name,
      branchId: request.branchId,
    );
  }

  @override
  Future<BaseResponse<List<TableModel>?>> getTables({
    required GetTablesRequestModel request,
  }) async {
    return await _apiService.getAllFoodTables(
      pageNumber: request.pageNumber,
      pageSize: request.pageSize,
      id: request.id,
      name: request.name,
      floorID: request.floorID,
      forPOS: request.forPOS,
    );
  }

  @override
  Future<BaseResponse<List<AdditiveModel>?>> getFoodAdditives({
    GetFoodAdditiveRequest? request,
  }) {
    final respons = _apiService.getAllFoodAdditives(
      pageNumber: request?.pageNumber,
      pageSize: request?.pageSize,

      categoryID: request?.categoryID,
      name: request?.name,
    );
    return respons;
  }

  @override
  Future<BaseResponse<List<DeliveryCompanyModel>?>> getAllDeliveryCompany({
    BaseRequest? request,
  }) async {
    return await _apiService.getAllDeliveryCompany(
      name: request?.name,
      pageNumber: request?.pageNumber,
      pageSize: request?.pageSize,
    );
  }
}

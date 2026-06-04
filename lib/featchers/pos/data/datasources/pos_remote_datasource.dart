import 'package:apex_restaurant/core/service/api_service.dart';
import 'package:apex_restaurant/core/shared/model/base_response.dart';
import 'package:apex_restaurant/featchers/pos/data/models/category_model.dart';
import 'package:apex_restaurant/featchers/pos/data/models/floor_model.dart';
import 'package:apex_restaurant/featchers/pos/data/models/food_additive_model.dart';
import 'package:apex_restaurant/featchers/pos/domain/entities/get_food_additive_request.dart';
import 'package:apex_restaurant/featchers/pos/domain/entities/get_items_request_model.dart';
import 'package:apex_restaurant/featchers/pos/data/models/menu_item_model.dart';
import 'package:apex_restaurant/featchers/pos/data/models/table_model.dart';

abstract class PosRemoteDataSource {
  Future<List<FloorModel>> getFloors({
    int? pageNumber,
    int? pageSize,
    String? id,
    String? name,
    int? branchId,
  });
  Future<List<TableModel>> getTables({
    int? pageNumber,
    int? pageSize,
    String? id,
    String? name,
    String? floorID,
    bool? forPOS,
  });

  Future<BaseResponse<List<FoodAdditiveModel>>> getFoodAdditives({
    GetFoodAdditiveRequest? request,
  });
  Future<List<CategoryModel>> getMenuCategories();
  Future<List<MenuItemModel>> getMenuItemsByCategory({
    GetItemsRequestModel? request,
  });
  Future<void> submitOrder(Map<String, dynamic> orderData);
  Future<void> sendToKitchen(Map<String, dynamic> orderData);
}

class PosRemoteDataSourceImpl implements PosRemoteDataSource {
  final ApiService _apiService;

  PosRemoteDataSourceImpl(this._apiService);

  @override
  Future<List<CategoryModel>> getMenuCategories() async {
    return _apiService.getAllCategories().then((response) {
      return response.data ?? [];
    });
  }

  @override
  Future<List<MenuItemModel>> getMenuItemsByCategory({
    GetItemsRequestModel? request,
  }) async {
    return await _apiService
        .getItemsByCategory(
          pageNumber: request?.pageNumber,
          pageSize: request?.pageSize,
          statues: request?.status,
          name: request?.name,
          categories: request?.categories,
          isRestaurantItem: request?.isRestaurantItem,
          isRestaurantIngrediant: request?.isRestaurantIngrediant,
        )
        .then((response) {
          return response.data ?? [];
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
  Future<List<FloorModel>> getFloors({
    int? pageNumber,
    int? pageSize,
    String? id,
    String? name,
    int? branchId,
  }) {
    return _apiService
        .getAllFloors(
          pageNumber: pageNumber,
          pageSize: pageSize,
          id: id,
          name: name,
          branchId: branchId,
        )
        .then((response) => response.data ?? []);
  }

  @override
  Future<List<TableModel>> getTables({
    int? pageNumber,
    int? pageSize,
    String? id,
    String? name,
    String? floorID,
    bool? forPOS,
  }) {
    return _apiService
        .getAllFoodTables(
          pageNumber: pageNumber,
          pageSize: pageSize,
          id: id,
          name: name,
          floorID: floorID,
          forPOS: forPOS,
        )
        .then((response) => response.data ?? []);
  }

  @override
  Future<BaseResponse<List<FoodAdditiveModel>>> getFoodAdditives({
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
}

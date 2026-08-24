import '../../../../core/service/api_service.dart';
import '../../../../core/shared/model/base_response.dart';
import '../../../../core/shared/model/settings_model.dart';
import '../../../home/data/models/session_model.dart';
import '../models/category_model.dart';
import '../models/floor_model.dart';
import '../models/restaurant_item.dart';
import '../../domain/entities/get_food_additive_request.dart';
import '../../domain/entities/get_items_request_model.dart';
import '../../../tables/data/models/get_floor_request.dart';
import '../../../tables/data/models/get_table_request.dart';
import '../../../tables/data/models/table_model.dart';

abstract class PosRemoteDataSource {
  Future<BaseResponse<SettingsModel?>> getSettings();
  Future<BaseResponse<SessionModel?>> getCurrentSession();

  Future<BaseResponse<dynamic>> closeRestaurantPosSession({
    required int sessionId,
  });

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

  @override
  Future<BaseResponse> closeRestaurantPosSession({
    required int sessionId,
  }) async {
    return await _apiService.closeRestaurantPosSession(sessionId);
  }

  @override
  Future<BaseResponse<SessionModel?>> getCurrentSession() async {
    return await _apiService.currentPOSsession();
  }
}

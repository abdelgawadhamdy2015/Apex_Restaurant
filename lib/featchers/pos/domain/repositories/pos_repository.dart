import '../../../../core/service/api_result.dart';
import '../../../../core/shared/model/base_response.dart';
import '../../../../core/shared/model/settings_model.dart';
import '../../../home/data/models/session_model.dart';
import '../../data/models/category_model.dart';
import '../../data/models/floor_model.dart';
import '../../data/models/restaurant_item.dart';
import '../../../tables/data/models/get_floor_request.dart';
import '../entities/get_food_additive_request.dart';
import '../entities/get_items_request_model.dart';
import '../../../tables/data/models/get_table_request.dart';
import '../../../tables/data/models/table_model.dart';

abstract class PosRepository {
  Future<ApiResult<BaseResponse<SettingsModel?>>> getSettings();
  Future<ApiResult<BaseResponse<SessionModel?>>> getCurrentSession();
  Future<ApiResult<BaseResponse<List<FloorModel>?>>> getFloors({
    required GetFloorsRequest request,
  });

  Future<ApiResult<BaseResponse<dynamic>>> closeRestaurantPosSession({
    required int sessionId,
  });

  Future<ApiResult<BaseResponse<List<TableModel>?>>> getTables({
    required GetTablesRequest request,
  });
  Future<ApiResult<BaseResponse<List<AdditiveModel>?>>> getFoodAdditives(
    GetFoodAdditivesRequest? request,
  );
  Future<ApiResult<BaseResponse<List<CategoryModel>?>>> getMenuCategories();
  Future<ApiResult<BaseResponse<List<RestaurantItem>?>>> getMenuItemsByCategory(
    GetItemsRequest? request,
  );
  // Future<void> submitOrder(Order order);
  // Future<void> sendToKitchen(Order order);
}

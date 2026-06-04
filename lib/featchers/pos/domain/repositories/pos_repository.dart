import 'package:apex_restaurant/core/service/api_result.dart';
import 'package:apex_restaurant/core/shared/model/base_response.dart';
import 'package:apex_restaurant/featchers/pos/data/models/category_model.dart';
import 'package:apex_restaurant/featchers/pos/data/models/floor_model.dart';
import 'package:apex_restaurant/featchers/pos/data/models/food_additive_model.dart';
import 'package:apex_restaurant/featchers/pos/domain/entities/get_food_additive_request.dart';
import 'package:apex_restaurant/featchers/pos/domain/entities/get_items_request_model.dart';
import 'package:apex_restaurant/featchers/pos/data/models/menu_item_model.dart';
import 'package:apex_restaurant/featchers/pos/data/models/table_model.dart';
import 'package:apex_restaurant/featchers/pos/domain/entities/menu_item.dart';

abstract class PosRepository {
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
  Future<ApiResult<BaseResponse<List<FoodAdditiveModel>>>> getFoodAdditives(
    GetFoodAdditiveRequest? request,
  );
  Future<List<CategoryModel>> getMenuCategories();
  Future<List<MenuItemModel>> getMenuItemsByCategory(
    GetItemsRequestModel? request,
  );
  Future<void> submitOrder(Order order);
  Future<void> sendToKitchen(Order order);
}

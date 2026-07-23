import 'package:apex_restaurant/core/service/api_result.dart';
import 'package:apex_restaurant/core/shared/entity/base_request.dart';
import 'package:apex_restaurant/core/shared/model/base_response.dart';
import 'package:apex_restaurant/featchers/pos/data/models/category_model.dart';
import 'package:apex_restaurant/featchers/pos/data/models/delivery_company.dart';
import 'package:apex_restaurant/featchers/pos/data/models/floor_model.dart';
import 'package:apex_restaurant/featchers/pos/data/models/restaurant_item.dart';
import 'package:apex_restaurant/featchers/tables/data/models/get_floor_request.dart';
import 'package:apex_restaurant/featchers/pos/domain/entities/get_food_additive_request.dart';
import 'package:apex_restaurant/featchers/pos/domain/entities/get_items_request_model.dart';
import 'package:apex_restaurant/featchers/pos/data/models/table_model.dart';
import 'package:apex_restaurant/featchers/tables/data/models/get_table_request.dart';
import 'package:apex_restaurant/featchers/pos/domain/entities/menu_item.dart';

abstract class PosRepository {
  Future<ApiResult<BaseResponse<List<FloorModel>?>>> getFloors({
    required GetFloorsRequest request,
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
  Future<void> submitOrder(Order order);
  Future<void> sendToKitchen(Order order);

  Future<ApiResult<BaseResponse<List<DeliveryCompanyModel>?>>>
  getAllDeliveryCompany({BaseRequest? request});
}

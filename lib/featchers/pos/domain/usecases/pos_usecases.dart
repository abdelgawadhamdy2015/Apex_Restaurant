import 'package:apex_restaurant/core/service/api_result.dart';
import 'package:apex_restaurant/core/shared/entity/base_request.dart';
import 'package:apex_restaurant/core/shared/model/base_response.dart';
import 'package:apex_restaurant/featchers/pos/data/models/category_model.dart';
import 'package:apex_restaurant/featchers/pos/data/models/delivery_company.dart';
import 'package:apex_restaurant/featchers/pos/data/models/floor_model.dart';
import 'package:apex_restaurant/featchers/pos/data/models/food_additive_model.dart';
import 'package:apex_restaurant/featchers/pos/domain/entities/get_floor_request.dart';
import 'package:apex_restaurant/featchers/pos/domain/entities/get_food_additive_request.dart';
import 'package:apex_restaurant/featchers/pos/domain/entities/get_items_request_model.dart';
import 'package:apex_restaurant/featchers/pos/data/models/menu_item_model.dart';
import 'package:apex_restaurant/featchers/pos/data/models/table_model.dart';
import 'package:apex_restaurant/featchers/pos/domain/entities/get_table_request.dart';
import 'package:apex_restaurant/featchers/pos/domain/entities/menu_item.dart';
import 'package:apex_restaurant/featchers/pos/domain/repositories/pos_repository.dart';

class GetFloorsUseCase {
  final PosRepository _repository;
  GetFloorsUseCase(this._repository);
  Future<ApiResult<BaseResponse<List<FloorModel>?>>> call({
    required GetFloorsRequestModel request,
  }) => _repository.getFloors(request: request);
}

class GetTablesUseCase {
  final PosRepository _repository;
  GetTablesUseCase(this._repository);
  Future<ApiResult<BaseResponse<List<TableModel>?>>> call({
    required GetTablesRequestModel request,
  }) => _repository.getTables(request: request);
}

class GetFoodAdditivesUseCase {
  final PosRepository _repository;
  GetFoodAdditivesUseCase(this._repository);
  Future<ApiResult<BaseResponse<List<FoodAdditiveModel>?>>> call(
    GetFoodAdditiveRequest? request,
  ) => _repository.getFoodAdditives(request);
}

class GetMenuCategoriesUseCase {
  final PosRepository _repository;
  GetMenuCategoriesUseCase(this._repository);
  Future<ApiResult<BaseResponse<List<CategoryModel>?>>> call() =>
      _repository.getMenuCategories();
}

class GetMenuItemsByCategoryUseCase {
  final PosRepository _repository;
  GetMenuItemsByCategoryUseCase(this._repository);
  Future<ApiResult<BaseResponse<List<MenuItemModel>?>>> call(
    GetItemsRequestModel? request,
  ) => _repository.getMenuItemsByCategory(request);
}

class GetAllDeliveryCompanyUseCase {
  final PosRepository _repository;
  GetAllDeliveryCompanyUseCase(this._repository);
  Future<ApiResult<BaseResponse<List<DeliveryCompanyModel>?>>> call({
    BaseRequest? request,
  }) => _repository.getAllDeliveryCompany(request: request);
}

class SendToKitchenUseCase {
  final PosRepository _repository;
  SendToKitchenUseCase(this._repository);
  Future<void> call(Order order) => _repository.sendToKitchen(order);
}

class SubmitOrderUseCase {
  final PosRepository _repository;
  SubmitOrderUseCase(this._repository);
  Future<void> call(Order order) => _repository.submitOrder(order);
}

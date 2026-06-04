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
import 'package:apex_restaurant/featchers/pos/domain/repositories/pos_repository.dart';

class GetFloorsUseCase {
  final PosRepository _repository;
  GetFloorsUseCase(this._repository);
  Future<List<FloorModel>> call({
    int? pageNumber,
    int? pageSize,
    String? id,
    String? name,
    int? branchId,
  }) => _repository.getFloors();
}

class GetTablesUseCase {
  final PosRepository _repository;
  GetTablesUseCase(this._repository);
  Future<List<TableModel>> call({
    int? pageNumber,
    int? pageSize,
    String? id,
    String? name,
    String? floorID,
    bool? forPOS,
  }) => _repository.getTables(
    pageNumber: pageNumber,
    pageSize: pageSize,
    id: id,
    name: name,
    floorID: floorID,
    forPOS: forPOS,
  );
}

class GetFoodAdditivesUseCase {
  final PosRepository _repository;
  GetFoodAdditivesUseCase(this._repository);
  Future<ApiResult<BaseResponse<List<FoodAdditiveModel>>>> call(
    GetFoodAdditiveRequest? request,
  ) => _repository.getFoodAdditives(request);
}

class GetMenuCategoriesUseCase {
  final PosRepository _repository;
  GetMenuCategoriesUseCase(this._repository);
  Future<List<CategoryModel>> call() => _repository.getMenuCategories();
}

class GetMenuItemsByCategoryUseCase {
  final PosRepository _repository;
  GetMenuItemsByCategoryUseCase(this._repository);
  Future<List<MenuItemModel>> call(GetItemsRequestModel? request) =>
      _repository.getMenuItemsByCategory(request);
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

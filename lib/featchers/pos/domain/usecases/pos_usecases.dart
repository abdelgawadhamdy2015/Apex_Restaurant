import 'package:apex_restaurant/core/service/api_result.dart';
import 'package:apex_restaurant/core/shared/entity/base_request.dart';
import 'package:apex_restaurant/core/shared/model/base_response.dart';
import 'package:apex_restaurant/core/shared/model/settings_model.dart';
import 'package:apex_restaurant/featchers/pos/data/models/category_model.dart';
import 'package:apex_restaurant/featchers/pos/data/models/delivery_company.dart';
import 'package:apex_restaurant/featchers/pos/data/models/restaurant_item.dart';
import 'package:apex_restaurant/featchers/pos/domain/entities/get_food_additive_request.dart';
import 'package:apex_restaurant/featchers/pos/domain/entities/get_items_request_model.dart';
import 'package:apex_restaurant/featchers/pos/domain/entities/menu_item.dart';
import 'package:apex_restaurant/featchers/pos/domain/repositories/pos_repository.dart';

class GetSettingsUseCase {
  final PosRepository _repository;
  GetSettingsUseCase(this._repository);
  Future<ApiResult<BaseResponse<SettingsModel?>>> call() =>
      _repository.getSettings();
}

class GetFoodAdditivesUseCase {
  final PosRepository _repository;
  GetFoodAdditivesUseCase(this._repository);
  Future<ApiResult<BaseResponse<List<AdditiveModel>?>>> call(
    GetFoodAdditivesRequest? request,
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
  Future<ApiResult<BaseResponse<List<RestaurantItem>?>>> call(
    GetItemsRequest? request,
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

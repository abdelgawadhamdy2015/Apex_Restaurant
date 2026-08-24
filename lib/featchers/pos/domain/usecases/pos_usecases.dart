import '../../../../core/service/api_result.dart';
import '../../../../core/shared/model/base_response.dart';
import '../../../../core/shared/model/settings_model.dart';
import '../../data/models/category_model.dart';
import '../../data/models/restaurant_item.dart';
import '../entities/get_food_additive_request.dart';
import '../entities/get_items_request_model.dart';
import '../repositories/pos_repository.dart';

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

// class SendToKitchenUseCase {
//   final PosRepository _repository;
//   SendToKitchenUseCase(this._repository);
//   Future<void> call(Order order) => _repository.sendToKitchen(order);
// }

class CloseRestaurantPosSessionUseCase {
  final PosRepository _repository;
  CloseRestaurantPosSessionUseCase(this._repository);
  Future<ApiResult<BaseResponse<dynamic>>> call({required int sessionId}) =>
      _repository.closeRestaurantPosSession(sessionId: sessionId);
}

class CurrentRestaurantPosSessionUseCase {
  final PosRepository _repository;
  CurrentRestaurantPosSessionUseCase(this._repository);
  Future<ApiResult<BaseResponse<dynamic>>> call() =>
      _repository.getCurrentSession();
}

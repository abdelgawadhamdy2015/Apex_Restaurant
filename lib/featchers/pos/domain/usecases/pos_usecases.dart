import 'package:apex_restaurant/featchers/pos/data/models/floor_model.dart';
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

class GetMenuCategoriesUseCase {
  final PosRepository _repository;
  GetMenuCategoriesUseCase(this._repository);
  Future<List<MenuCategory>> call() => _repository.getMenuCategories();
}

class GetMenuItemsByCategoryUseCase {
  final PosRepository _repository;
  GetMenuItemsByCategoryUseCase(this._repository);
  Future<List<MenuItem>> call(String categoryId) =>
      _repository.getMenuItemsByCategory(categoryId);
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

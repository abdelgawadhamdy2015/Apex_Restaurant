import 'package:apex_restaurant/featchers/pos/data/models/floor_model.dart';
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
  Future<List<MenuCategory>> getMenuCategories();
  Future<List<MenuItem>> getMenuItemsByCategory(String categoryId);
  Future<void> submitOrder(Order order);
  Future<void> sendToKitchen(Order order);
}

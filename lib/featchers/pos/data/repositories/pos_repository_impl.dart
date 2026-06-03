import 'package:apex_restaurant/featchers/pos/data/datasources/pos_remote_datasource.dart';
import 'package:apex_restaurant/featchers/pos/data/models/category_model.dart';
import 'package:apex_restaurant/featchers/pos/data/models/floor_model.dart';
import 'package:apex_restaurant/featchers/pos/data/models/get_items_request_model.dart';
import 'package:apex_restaurant/featchers/pos/data/models/menu_item_model.dart';
import 'package:apex_restaurant/featchers/pos/data/models/table_model.dart';
import 'package:apex_restaurant/featchers/pos/domain/entities/menu_item.dart';
import 'package:apex_restaurant/featchers/pos/domain/repositories/pos_repository.dart';

class PosRepositoryImpl implements PosRepository {
  final PosRemoteDataSource _remoteDataSource;

  PosRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<CategoryModel>> getMenuCategories() async {
    final categories = await _remoteDataSource.getMenuCategories();
    return categories;
  }

  @override
  Future<List<MenuItemModel>> getMenuItemsByCategory(
    GetItemsRequestModel? request,
  ) async {
    final items = await _remoteDataSource.getMenuItemsByCategory(
      request: request,
    );
    return items;
  }

  @override
  Future<void> sendToKitchen(Order order) async {
    final data = _orderToMap(order);
    await _remoteDataSource.sendToKitchen(data);
  }

  @override
  Future<void> submitOrder(Order order) async {
    final data = _orderToMap(order);
    await _remoteDataSource.submitOrder(data);
  }

  Map<String, dynamic> _orderToMap(Order order) => {
    'table_id': order.tableId,
    'items': order.items
        .map(
          (item) => {
            'menu_item_id': item.menuItem.id,
            'quantity': item.quantity,
            'notes': item.notes,
            'addons': item.addons,
          },
        )
        .toList(),
    'subtotal': order.subtotal,
    'tax': order.tax,
    'total': order.total,
  };

  @override
  Future<List<FloorModel>> getFloors({
    int? pageNumber,
    int? pageSize,
    String? id,
    String? name,
    int? branchId,
  }) {
    return _remoteDataSource.getFloors(
      pageNumber: pageNumber,
      pageSize: pageSize,
      id: id,
      name: name,
      branchId: branchId,
    );
  }

  @override
  Future<List<TableModel>> getTables({
    int? pageNumber,
    int? pageSize,
    String? id,
    String? name,
    String? floorID,
    bool? forPOS,
  }) {
    return _remoteDataSource.getTables(
      pageNumber: pageNumber,
      pageSize: pageSize,
      id: id,
      name: name,
      floorID: floorID,
      forPOS: forPOS,
    );
  }
}

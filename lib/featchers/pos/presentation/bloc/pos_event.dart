import 'package:apex_restaurant/featchers/pos/data/enums/pos_order_type.dart';
import 'package:apex_restaurant/featchers/pos/data/models/category_model.dart';
import 'package:apex_restaurant/featchers/pos/domain/entities/get_food_additive_request.dart';
import 'package:apex_restaurant/featchers/pos/domain/entities/get_items_request_model.dart';
import 'package:apex_restaurant/featchers/pos/data/models/menu_item_model.dart';
import 'package:apex_restaurant/featchers/pos/data/models/table_model.dart';
import 'package:equatable/equatable.dart';

abstract class PosEvent extends Equatable {
  const PosEvent();
  @override
  List<Object?> get props => [];
}

class LoadCategoriesEvent extends PosEvent {
  const LoadCategoriesEvent();
}

class LoadItemsEvent extends PosEvent {
  final GetItemsRequestModel? requestModel;
  const LoadItemsEvent(this.requestModel);
}

class LoadFoodAdditivesEvent extends PosEvent {
  final GetFoodAdditiveRequest? requestModel;
  const LoadFoodAdditivesEvent({this.requestModel});
}

class LoadFloorsEvent extends PosEvent {
  final int? pageNumber;
  final int? pageSize;
  final String? id;
  final String? name;
  final int? branchId;
  const LoadFloorsEvent({
    this.pageNumber,
    this.pageSize,
    this.id,
    this.name,
    this.branchId,
  });
}

class LoadTablesEvent extends PosEvent {
  final int? pageNumber;
  final int? pageSize;
  final String? id;
  final String? name;
  final String? floorID;
  final bool? forPOS;

  const LoadTablesEvent({
    this.pageNumber,
    this.pageSize,
    this.id,
    this.name,
    this.floorID,
    this.forPOS,
  });
}

class SelectCategoryEvent extends PosEvent {
  final CategoryModel category;
  const SelectCategoryEvent(this.category);
  @override
  List<Object?> get props => [category];
}

class SelectItemEvent extends PosEvent {
  final MenuItemModel item;
  const SelectItemEvent(this.item);
  @override
  List<Object?> get props => [item];
}

class AddItemToOrderEvent extends PosEvent {
  final MenuItemModel item;
  const AddItemToOrderEvent(this.item);
  @override
  List<Object?> get props => [item];
}

class RemoveItemFromOrderEvent extends PosEvent {
  final String itemId;
  const RemoveItemFromOrderEvent(this.itemId);
  @override
  List<Object?> get props => [itemId];
}

class IncrementItemEvent extends PosEvent {
  final String itemId;
  const IncrementItemEvent(this.itemId);
  @override
  List<Object?> get props => [itemId];
}

class DecrementItemEvent extends PosEvent {
  final String itemId;
  const DecrementItemEvent(this.itemId);
  @override
  List<Object?> get props => [itemId];
}

class SendToKitchenEvent extends PosEvent {
  const SendToKitchenEvent();
}

class PayOrderEvent extends PosEvent {
  const PayOrderEvent();
}

class CancelOrderEvent extends PosEvent {
  const CancelOrderEvent();
}

class ShowToastEvent extends PosEvent {
  final String message;
  const ShowToastEvent(this.message);
  @override
  List<Object?> get props => [message];
}

class DismissToastEvent extends PosEvent {
  const DismissToastEvent();
}

class ChangeOrderTypeEvent extends PosEvent {
  final PosOrderType type;

  const ChangeOrderTypeEvent(this.type);
}

class SelectTableEvent extends PosEvent {
  final TableModel table;

  const SelectTableEvent({required this.table});
}

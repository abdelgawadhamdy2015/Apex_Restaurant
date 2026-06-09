import 'package:apex_restaurant/core/shared/entity/base_request.dart';
import 'package:apex_restaurant/featchers/pos/data/enums/pos_order_type.dart';
import 'package:apex_restaurant/featchers/pos/data/models/category_model.dart';
import 'package:apex_restaurant/featchers/pos/data/models/delivery_company.dart';
import 'package:apex_restaurant/featchers/pos/data/models/food_additive_model.dart';
import 'package:apex_restaurant/featchers/pos/domain/entities/get_floor_request.dart';
import 'package:apex_restaurant/featchers/pos/domain/entities/get_food_additive_request.dart';
import 'package:apex_restaurant/featchers/pos/domain/entities/get_items_request_model.dart';
import 'package:apex_restaurant/featchers/pos/data/models/menu_item_model.dart';
import 'package:apex_restaurant/featchers/pos/data/models/table_model.dart';
import 'package:apex_restaurant/featchers/pos/domain/entities/get_table_request.dart';
import 'package:apex_restaurant/featchers/pos/domain/entities/menu_item.dart';
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
  final GetFloorsRequestModel request;

  const LoadFloorsEvent({required this.request});
}

class LoadTablesEvent extends PosEvent {
  final GetTablesRequestModel request;

  const LoadTablesEvent({required this.request});
}

class LoadDeliveryCompaniesEvent extends PosEvent {
  final BaseRequest? request;

  const LoadDeliveryCompaniesEvent({this.request});
}

class SelectDeliveryCompanyEvent extends PosEvent {
  final DeliveryCompanyModel deliveryCompanyModel;
  const SelectDeliveryCompanyEvent({required this.deliveryCompanyModel});
  @override
  List<Object?> get props => [deliveryCompanyModel];
}

class SelectCategoryEvent extends PosEvent {
  final CategoryModel category;
  const SelectCategoryEvent(this.category);
  @override
  List<Object?> get props => [category];
}

class AddItemToOrderEvent extends PosEvent {
  final MenuItemModel item;
  const AddItemToOrderEvent(this.item);
  @override
  List<Object?> get props => [item];
}

class UpdateItemAddonsEvent extends PosEvent {
  final OrderItem item;
  final List<FoodAdditiveModel> addons;
  const UpdateItemAddonsEvent({required this.item, required this.addons});
  @override
  List<Object?> get props => [item, addons];
}

class RemoveItemFromOrderEvent extends PosEvent {
  final String itemId;
  const RemoveItemFromOrderEvent(this.itemId);
  @override
  List<Object?> get props => [itemId];
}

class IncrementItemEvent extends PosEvent {
  final int itemId;
  const IncrementItemEvent(this.itemId);
  @override
  List<Object?> get props => [itemId];
}

class DecrementItemEvent extends PosEvent {
  final int itemId;
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

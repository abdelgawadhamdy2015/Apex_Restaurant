import 'package:apex_restaurant/featchers/tables/data/models/table_model.dart';
import 'package:equatable/equatable.dart';

import 'package:apex_restaurant/featchers/pos/data/models/category_model.dart';
import 'package:apex_restaurant/featchers/pos/domain/entities/get_food_additive_request.dart';
import 'package:apex_restaurant/featchers/pos/domain/entities/get_items_request_model.dart';
import 'package:apex_restaurant/featchers/pos/domain/entities/menu_item.dart';

abstract class PosEvent extends Equatable {
  const PosEvent();

  @override
  List<Object?> get props => [];
}

class LoadCategoriesEvent extends PosEvent {
  const LoadCategoriesEvent();
}

class LoadSettingsEvent extends PosEvent {
  const LoadSettingsEvent();
}

class LoadItemsEvent extends PosEvent {
  final GetItemsRequest? requestModel;
  const LoadItemsEvent(this.requestModel);

  @override
  List<Object?> get props => [requestModel];
}

class LoadFoodAdditivesEvent extends PosEvent {
  final GetFoodAdditivesRequest? requestModel;
  const LoadFoodAdditivesEvent({this.requestModel});

  @override
  List<Object?> get props => [requestModel];
}

class SelectCategoryEvent extends PosEvent {
  final CategoryModel category;
  const SelectCategoryEvent(this.category);

  @override
  List<Object?> get props => [category];
}

class AddItemToOrderEvent extends PosEvent {
  final OrderItem item;
  const AddItemToOrderEvent(this.item);

  @override
  List<Object?> get props => [item];
}

class UpdateItemAddonsEvent extends PosEvent {
  final OrderItem item;
  final List<AdditiveModel> addons;
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

class SelectTableEvent extends PosEvent {
  final TableModel table;
  const SelectTableEvent({required this.table});

  @override
  List<Object?> get props => [table];
}

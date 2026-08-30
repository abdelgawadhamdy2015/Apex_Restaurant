import 'package:apex_restaurant/featchers/pos/presentation/pages/pos_page.dart';

import '../../../tables/data/models/table_model.dart';
import 'package:equatable/equatable.dart';

import '../../data/models/category_model.dart';
import '../../domain/entities/get_food_additive_request.dart';
import '../../domain/entities/get_items_request_model.dart';
import '../../domain/entities/menu_item.dart';

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

  /// When true, appends the next page onto [PosState.currentMenuItems]
  /// instead of replacing it. When false (default), resets pagination
  /// and loads page 1.
  final bool loadMore;

  const LoadItemsEvent(this.requestModel, {this.loadMore = false});

  @override
  List<Object?> get props => [requestModel, loadMore];
}

/// Fetches the next page of items for whatever filters are currently
/// active in [PosState.currentItemsRequest]. No-ops if there is no
/// more data or a page fetch is already in flight.
class LoadMoreItemsEvent extends PosEvent {
  const LoadMoreItemsEvent();
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

class SendToKitchenEvent extends PosEvent {
  const SendToKitchenEvent();
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

class SelectedNavIndexEvent extends PosEvent {
  final PosBottomNavEnm selectedNavIndex;
  const SelectedNavIndexEvent({required this.selectedNavIndex});

  @override
  List<Object?> get props => [selectedNavIndex];
}

class CloseRestaurantPosSessionEvent extends PosEvent {
  final int sessionId;
  const CloseRestaurantPosSessionEvent({required this.sessionId});

  @override
  List<Object?> get props => [sessionId];
}

class CurrentRestaurantPosSessionEvent extends PosEvent {
  const CurrentRestaurantPosSessionEvent();

  @override
  List<Object?> get props => [];
}

import 'package:apex_restaurant/core/shared/entity/base_request.dart';
import 'package:apex_restaurant/featchers/cart/data/models/client_request_model.dart';
import 'package:apex_restaurant/featchers/cart/data/models/get_client_request.dart';
import 'package:apex_restaurant/featchers/cart/data/models/pos_client_model.dart';
import 'package:apex_restaurant/featchers/pos/data/models/delivery_company.dart';
import 'package:apex_restaurant/featchers/tables/data/models/get_floor_request.dart';
import 'package:apex_restaurant/featchers/tables/data/models/get_table_request.dart';
import 'package:apex_restaurant/featchers/pos/domain/entities/menu_item.dart';
import 'package:equatable/equatable.dart';

import 'cart_state.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

class LoadCartDataEvent extends CartEvent {}

class LoadPersonsData extends CartEvent {
  final GetClientsRequest request;
  const LoadPersonsData({required this.request});
  @override
  List<Object?> get props => [request];
}

class SyncCartItemsEvent extends CartEvent {
  final List<OrderItem> items;
  const SyncCartItemsEvent(this.items);

  @override
  List<Object?> get props => [items];
}

class SelectPersonEvent extends CartEvent {
  final PosClientModel? person;
  const SelectPersonEvent(this.person);

  @override
  List<Object?> get props => [person];
}

class ChangeOrderTypeEvent extends CartEvent {
  final OrderType orderType;
  const ChangeOrderTypeEvent(this.orderType);

  @override
  List<Object?> get props => [orderType];
}

class SelectWaiterEvent extends CartEvent {
  final String? waiterId;
  const SelectWaiterEvent(this.waiterId);

  @override
  List<Object?> get props => [waiterId];
}

class SelectDeliveryAgentEvent extends CartEvent {
  final String? agentId;
  const SelectDeliveryAgentEvent(this.agentId);

  @override
  List<Object?> get props => [agentId];
}

class ChangeDiscountTypeEvent extends CartEvent {
  final DiscountType discountType;
  const ChangeDiscountTypeEvent(this.discountType);

  @override
  List<Object?> get props => [discountType];
}

class ApplyDiscountEvent extends CartEvent {
  final String code;
  const ApplyDiscountEvent(this.code);

  @override
  List<Object?> get props => [code];
}

class AddOrderItemToCartEvent extends CartEvent {
  final OrderItem item;
  const AddOrderItemToCartEvent(this.item);

  @override
  List<Object?> get props => [item];
}

class UpdateItemQuantityEvent extends CartEvent {
  final int index;
  final int delta; // Matches the parameter name used in CartBloc (+1 or -1)
  const UpdateItemQuantityEvent(this.index, this.delta);

  @override
  List<Object?> get props => [index, delta];
}

class RemoveItemEvent extends CartEvent {
  final int index;
  const RemoveItemEvent(this.index);

  @override
  List<Object?> get props => [index];
}

class LoadFloorsEvent extends CartEvent {
  final GetFloorsRequest request;
  const LoadFloorsEvent({required this.request});

  @override
  List<Object?> get props => [request];
}

class LoadTablesEvent extends CartEvent {
  final GetTablesRequest request;
  const LoadTablesEvent({required this.request});

  @override
  List<Object?> get props => [request];
}

class LoadDeliveryCompaniesEvent extends CartEvent {
  final BaseRequest? request;
  const LoadDeliveryCompaniesEvent({this.request});

  @override
  List<Object?> get props => [request];
}

class SelectDeliveryCompanyEvent extends CartEvent {
  final DeliveryCompanyModel deliveryCompanyModel;
  const SelectDeliveryCompanyEvent({required this.deliveryCompanyModel});

  @override
  List<Object?> get props => [deliveryCompanyModel];
}

class HoldOrderSubmittedEvent extends CartEvent {}

class ClearCartEvent extends CartEvent {}

class CompletePaymentSubmittedEvent extends CartEvent {}

class AddPosClientEvent extends CartEvent {
  final ClientRequestModel request;
  const AddPosClientEvent({required this.request});

  @override
  List<Object?> get props => [request];
}

class UpdatePosClientEvent extends CartEvent {
  final ClientRequestModel request;
  const UpdatePosClientEvent({required this.request});

  @override
  List<Object?> get props => [request];
}

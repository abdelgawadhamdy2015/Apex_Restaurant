import 'package:apex_restaurant/featchers/cart/data/models/check_voucher_request.dart';

import '../../../../core/shared/entity/base_request.dart';
import '../../../../core/shared/model/settings_model.dart';
import '../../data/enums/cart_enum.dart';
import '../../data/models/client_request_model.dart';
import '../../data/models/get_client_request.dart';
import '../../data/models/invoice_request.dart';
import '../../data/models/pos_client_model.dart';
import '../../data/models/restored_cart_data.dart';
import '../../data/models/waiter_model.dart';
import '../../../pos/data/models/category_model.dart';
import '../../../pos/data/models/delivery_company.dart';
import '../../../pos/data/models/restaurant_item.dart';
import '../../../pos/domain/entities/menu_item.dart';
import '../../../tables/data/models/get_floor_request.dart';
import '../../../tables/data/models/get_table_request.dart';
import '../../../tables/domain/entities/table_entity.dart';
import 'package:equatable/equatable.dart';

import 'cart_state.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

class LoadCartDataEvent extends CartEvent {}

class AcknowledgeCartRestoredEvent extends CartEvent {
  const AcknowledgeCartRestoredEvent();
}

class SyncRestoredInvoiceEvent extends CartEvent {
  final RestoredCartData data;
  final bool canEdit;
  final bool isPending;
  const SyncRestoredInvoiceEvent(
    this.data, {
    this.canEdit = true,
    this.isPending = false,
  });

  @override
  List<Object?> get props => [data];
}

class UpdateSettingsEvent extends CartEvent {
  final SettingsModel? settings;
  const UpdateSettingsEvent(this.settings);

  @override
  List<Object?> get props => [settings];
}

class ChangeAddressEvent extends CartEvent {
  final ClientAddressModel address;
  const ChangeAddressEvent(this.address);
}

/// Fired when the user confirms changes inside ItemCustomizationSheet while
/// editing an item that's already in the cart (as opposed to adding a new
/// one from the POS grid).
class EditCartItemEvent extends CartEvent {
  final int index;
  final ItemSize selectedSize;
  final List<AdditiveModel> selectedAddons;
  final double discount;
  final bool isPercentageDiscount;
  final String notes;
  final int quantity;

  const EditCartItemEvent({
    required this.index,
    required this.selectedSize,
    required this.selectedAddons,
    required this.discount,
    required this.isPercentageDiscount,
    required this.notes,
    required this.quantity,
  });

  @override
  List<Object?> get props => [
    index,
    selectedSize,
    selectedAddons,
    discount,
    isPercentageDiscount,
    notes,
    quantity,
  ];
}

class LoadDynamicDiscountsEvent extends CartEvent {}

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

class UpdateTakeawayDateTimeEvent extends CartEvent {
  final DateTime takeawayDateTime;
  const UpdateTakeawayDateTimeEvent({required this.takeawayDateTime});

  @override
  List<Object?> get props => [takeawayDateTime];
}

class SelectWaiterEvent extends CartEvent {
  final WaiterModel? waiter;
  const SelectWaiterEvent(this.waiter);

  @override
  List<Object?> get props => [waiter];
}

class SelectDeliveryManEvent extends CartEvent {
  final WaiterModel? deliveryMan;
  const SelectDeliveryManEvent(this.deliveryMan);

  @override
  List<Object?> get props => [deliveryMan];
}

class SelectPersonEvent extends CartEvent {
  final PosClientModel? person;
  const SelectPersonEvent(this.person);

  @override
  List<Object?> get props => [person];
}

class SelectCartTableEvent extends CartEvent {
  final TableEntity table;
  const SelectCartTableEvent({required this.table});

  @override
  List<Object?> get props => [table];
}

class SelectDeliveryCompanyEvent extends CartEvent {
  final DeliveryCompanyModel deliveryCompanyModel;
  const SelectDeliveryCompanyEvent({required this.deliveryCompanyModel});

  @override
  List<Object?> get props => [deliveryCompanyModel];
}

class ChangeOrderTypeEvent extends CartEvent {
  final CartOrderType orderType;
  const ChangeOrderTypeEvent(this.orderType);

  @override
  List<Object?> get props => [orderType];
}

class ChangeDiscountTypeEvent extends CartEvent {
  final DiscountTypeEnum discountType;
  const ChangeDiscountTypeEvent(this.discountType);

  @override
  List<Object?> get props => [discountType];
}

class ApplyDiscountEvent extends CartEvent {
  final RestaurantPosDiscountRequest? restaurantPosDiscountRequest;
  const ApplyDiscountEvent({this.restaurantPosDiscountRequest});

  @override
  List<Object?> get props => [RestaurantPosDiscountRequest];
}

class ApplyVoucherDiscountEvent extends CartEvent {
  final CheckVoucherRequest request;
  const ApplyVoucherDiscountEvent({required this.request});

  @override
  List<Object?> get props => [request];
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

class HoldOrderEvent extends CartEvent {
  final SaveRestaurantPosInvoiceRequest request;
  const HoldOrderEvent({required this.request});
  @override
  List<Object?> get props => [request];
}

class SaveTableOrderEvent extends CartEvent {
  final SaveRestaurantPosInvoiceRequest request;
  const SaveTableOrderEvent({required this.request});
  @override
  List<Object?> get props => [request];
}

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

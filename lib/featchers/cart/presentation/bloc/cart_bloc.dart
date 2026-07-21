import 'dart:developer';

import 'package:apex_restaurant/core/service/api_result.dart';
import 'package:apex_restaurant/featchers/cart/domain/usescase/cart_usescase.dart';
import 'package:apex_restaurant/featchers/pos/domain/entities/menu_item.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final GetWaitersUseCase getWaitersUseCase;
  final GetDeliveryAgentsUseCase getDeliveryAgentsUseCase;
  final ApplyDiscountUseCase applyDiscountUseCase;
  final HoldOrderUseCase holdOrderUseCase;
  final CompletePaymentUseCase completePaymentUseCase;

  CartBloc({
    required this.getWaitersUseCase,
    required this.getDeliveryAgentsUseCase,
    required this.applyDiscountUseCase,
    required this.holdOrderUseCase,
    required this.completePaymentUseCase,
  }) : super(const CartState()) {
    on<LoadCartDataEvent>(_onLoadCartData);
    on<SyncCartItemsEvent>(_onSyncCartItems);
    on<AddOrderItemToCartEvent>(_onAddOrderItem);
    on<SelectDeliveryCompanyEvent>(_onSelectDeliveryCompany);
    on<ChangeOrderTypeEvent>(_onChangeOrderType);
    on<SelectWaiterEvent>(
      (event, emit) => emit(state.copyWith(selectedWaiterId: event.waiterId)),
    );
    on<SelectDeliveryAgentEvent>(
      (event, emit) => emit(state.copyWith(selectedAgentId: event.agentId)),
    );
    on<ChangeDiscountTypeEvent>(
      (event, emit) =>
          emit(state.copyWith(selectedDiscountType: event.discountType)),
    );
    on<UpdateItemQuantityEvent>(_onUpdateItemQuantity);
    on<RemoveItemEvent>(_onRemoveItem);
    on<HoldOrderSubmittedEvent>(_onHoldOrder);
    on<CompletePaymentSubmittedEvent>(_onCompletePayment);
  }

  Future<void> _onLoadCartData(
    LoadCartDataEvent event,
    Emitter<CartState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final waitersRes = await getWaitersUseCase();
    final agentsRes = await getDeliveryAgentsUseCase();

    List<dynamic> waitersList = [];
    List<dynamic> agentsList = [];

    waitersRes.when(
      success: (data) => waitersList = data.data ?? [],
      failure: (_) {},
    );

    agentsRes.when(
      success: (data) => agentsList = data.data ?? [],
      failure: (_) {},
    );

    emit(
      state.copyWith(
        isLoading: false,
        waiters: waitersList,
        deliveryAgents: agentsList,
      ),
    );
  }

  void _onSyncCartItems(SyncCartItemsEvent event, Emitter<CartState> emit) {
    emit(state.copyWith(items: event.items));
  }

  void _onAddOrderItem(AddOrderItemToCartEvent event, Emitter<CartState> emit) {
    final updatedList = List<OrderItem>.from(state.items)..add(event.item);
    log("updatedList: ${updatedList.length}");
    emit(state.copyWith(items: updatedList));
  }

  void _onSelectDeliveryCompany(
    SelectDeliveryCompanyEvent event,
    Emitter<CartState> emit,
  ) {
    emit(state.copyWith(selectedDeliveryCompany: event.deliveryCompanyModel));
    log('Selected Company: ${event.deliveryCompanyModel.arabicName}');
  }

  void _onChangeOrderType(ChangeOrderTypeEvent event, Emitter<CartState> emit) {
    emit(state.copyWith(selectedOrderType: event.orderType));
  }

  void _onUpdateItemQuantity(
    UpdateItemQuantityEvent event,
    Emitter<CartState> emit,
  ) {
    final updated = List<OrderItem>.from(state.items);
    if (event.index >= 0 && event.index < updated.length) {
      final currentItem = updated[event.index];
      final newQty = currentItem.quantity + event.delta;

      if (newQty <= 0) {
        updated.removeAt(event.index);
      } else {
        updated[event.index] = OrderItem(
          menuItem: currentItem.menuItem,
          selectedSize: currentItem.selectedSize,
          addons: currentItem.addons,
          quantity: newQty,
          notes: currentItem.notes,
          discount: currentItem.discount,
          isPercentageDiscount: currentItem.isPercentageDiscount,
        );
      }
      emit(state.copyWith(items: updated));
    }
  }

  void _onRemoveItem(RemoveItemEvent event, Emitter<CartState> emit) {
    if (event.index >= 0 && event.index < state.items.length) {
      final updated = List<OrderItem>.from(state.items)..removeAt(event.index);
      emit(state.copyWith(items: updated));
    }
  }

  Future<void> _onHoldOrder(
    HoldOrderSubmittedEvent event,
    Emitter<CartState> emit,
  ) async {
    emit(state.copyWith(isSubmitting: true));
    await Future.delayed(const Duration(seconds: 1));
    emit(
      state.copyWith(
        isSubmitting: false,
        successMessage: 'تم تعليق الطلب بنجاح',
      ),
    );
  }

  Future<void> _onCompletePayment(
    CompletePaymentSubmittedEvent event,
    Emitter<CartState> emit,
  ) async {
    emit(state.copyWith(isSubmitting: true));
    await Future.delayed(const Duration(seconds: 1));
    emit(
      state.copyWith(
        isSubmitting: false,
        successMessage: 'تم إتمام عملية الدفع بنجاح',
      ),
    );
  }
}

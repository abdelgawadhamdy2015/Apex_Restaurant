import 'dart:async';
import 'dart:developer';

import 'package:apex_restaurant/core/service/api_result.dart';
import 'package:apex_restaurant/featchers/cart/data/models/pos_client_model.dart';
import 'package:apex_restaurant/featchers/cart/domain/usescase/cart_usescase.dart';
import 'package:apex_restaurant/featchers/pos/data/models/category_model.dart';
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
  final GetAllPosClientsUseCase getAllPersonsUseCase;
  final AddPosClientUseCase addPosClientUseCase;
  final UpdatePosClientUseCase updatePosClientUseCase;

  CartBloc({
    required this.getWaitersUseCase,
    required this.getDeliveryAgentsUseCase,
    required this.applyDiscountUseCase,
    required this.holdOrderUseCase,
    required this.completePaymentUseCase,
    required this.getAllPersonsUseCase,
    required this.addPosClientUseCase,
    required this.updatePosClientUseCase,
  }) : super(const CartState()) {
    on<LoadCartDataEvent>(_onLoadCartData);
    on<SyncCartItemsEvent>(_onSyncCartItems);
    on<AddOrderItemToCartEvent>(_onAddOrderItem);
    on<SelectDeliveryCompanyEvent>(_onSelectDeliveryCompany);
    on<LoadPersonsData>(_onLoadPersonData);
    on<SelectPersonEvent>(_onSelectPerson);

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
    on<ClearCartEvent>(_onClearCartEvent);
    on<AddPosClientEvent>(_addPosClient);
    on<UpdatePosClientEvent>(_updatePosClient);
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

  Future<void> _onLoadPersonData(
    LoadPersonsData event,
    Emitter<CartState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final personsRes = await getAllPersonsUseCase(request: event.request);

    List<PosClientModel> personsList = [];

    personsRes.when(
      success: (data) => personsList = data.data ?? [],
      failure: (_) {},
    );
    emit(state.copyWith(isLoading: false, persons: personsList));
  }

  void _onSyncCartItems(SyncCartItemsEvent event, Emitter<CartState> emit) {
    emit(state.copyWith(items: event.items));
  }

  void _onAddOrderItem(AddOrderItemToCartEvent event, Emitter<CartState> emit) {
    final existingItems = List<OrderItem>.from(state.items);

    final exactMatchIndex = existingItems.indexWhere(
      (i) =>
          i.menuItem.itemId == event.item.menuItem.itemId &&
          i.selectedSize?.sizeId == event.item.selectedSize?.sizeId &&
          _areAddonsEqual(i.addons, event.item.addons) &&
          i.discount == event.item.discount &&
          i.isPercentageDiscount == event.item.isPercentageDiscount,
    );

    if (exactMatchIndex >= 0) {
      final currentItem = existingItems[exactMatchIndex];
      existingItems[exactMatchIndex] = OrderItem(
        menuItem: currentItem.menuItem,
        selectedSize: currentItem.selectedSize,
        addons: currentItem.addons,
        quantity: currentItem.quantity + event.item.quantity,
        notes: currentItem.notes,
        discount: currentItem.discount,
        isPercentageDiscount: currentItem.isPercentageDiscount,
      );
    } else {
      existingItems.add(event.item);
    }

    log("updatedList: ${existingItems.length}");
    emit(state.copyWith(items: existingItems));
  }

  bool _areAddonsEqual(
    List<AdditiveModel> addons1,
    List<AdditiveModel> addons2,
  ) {
    if (addons1.length != addons2.length) return false;
    for (int i = 0; i < addons1.length; i++) {
      if (!addons1.any((a) => a.id == addons2[i].id)) return false;
    }
    return true;
  }

  void _onSelectDeliveryCompany(
    SelectDeliveryCompanyEvent event,
    Emitter<CartState> emit,
  ) {
    emit(state.copyWith(selectedDeliveryCompany: event.deliveryCompanyModel));
    log('Selected Company: ${event.deliveryCompanyModel.arabicName}');
  }

  void _onSelectPerson(SelectPersonEvent event, Emitter<CartState> emit) {
    emit(state.copyWith(selectedPerson: event.person));
    log('Selected Company: ${event.person?.arabicName}');
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

  void _onClearCartEvent(ClearCartEvent event, Emitter<CartState> emit) {
    emit(state.copyWith(items: []));
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

  Future<void> _addPosClient(
    AddPosClientEvent event,
    Emitter<CartState> emit,
  ) async {
    try {
      emit(state.copyWith(status: AddPersonStatus.loading));
      final response = await addPosClientUseCase(request: event.request);
      response.when(
        success: (data) {
          if (data.result == 1) {
            emit(
              state.copyWith(
                status: AddPersonStatus.success,
                successMessage: data.errorMessageAr,
              ),
            );
          } else {
            emit(
              state.copyWith(
                status: AddPersonStatus.failure,
                errorMessage: data.errorMessageAr,
              ),
            );
          }
        },
        failure: (errorHandler) {
          emit(
            state.copyWith(
              status: AddPersonStatus.failure,
              errorMessage: errorHandler.apiErrorModel.errorMessageAr,
            ),
          );
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: AddPersonStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _updatePosClient(
    UpdatePosClientEvent event,
    Emitter<CartState> emit,
  ) async {
    try {
      emit(state.copyWith(status: AddPersonStatus.loading));
      final response = await updatePosClientUseCase(request: event.request);
      response.when(
        success: (data) {
          if (data.result == 1) {
            emit(
              state.copyWith(
                status: AddPersonStatus.success,
                successMessage: data.errorMessageAr,
              ),
            );
          } else {
            emit(
              state.copyWith(
                status: AddPersonStatus.failure,
                errorMessage: data.errorMessageAr,
              ),
            );
          }
        },
        failure: (errorHandler) {
          emit(
            state.copyWith(
              status: AddPersonStatus.failure,
              errorMessage: errorHandler.apiErrorModel.errorMessageAr,
            ),
          );
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: AddPersonStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}

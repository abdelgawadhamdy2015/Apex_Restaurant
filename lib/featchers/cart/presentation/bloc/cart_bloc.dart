import 'dart:async';

import 'package:apex_restaurant/featchers/pos/data/models/delivery_company.dart';

import '../../../../core/service/api_result.dart';
import '../../data/enums/cart_enum.dart';
import '../../data/models/dynamic_discount.dart';
import '../../data/models/pos_client_model.dart';
import '../../data/models/waiter_model.dart';
import '../../domain/usescase/cart_usescase.dart';
import '../../../pos/data/models/category_model.dart';
import '../../../pos/domain/entities/menu_item.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final GetWaitersUseCase getWaitersUseCase;
  final GetDeliveryAgentsUseCase getDeliveryAgentsUseCase;
  final ApplyDiscountUseCase applyDiscountUseCase;
  final SavePendingRestaurantPosInvoiceUseCase
  savePendingRestaurantPosInvoiceUseCase;
  final SaveBookingTableRestaurantPosInvoiceUseCase
  saveBookingTableRestaurantPosInvoiceUseCase;
  final GetAllDeliveryCompanyUseCase getAllDeliveryCompanyUseCase;

  final GetAllPosClientsUseCase getAllPersonsUseCase;
  final AddPosClientUseCase addPosClientUseCase;
  final UpdatePosClientUseCase updatePosClientUseCase;
  final GetDynamicInvoiceDiscountUseCase getDynamicInvoiceDiscountUseCase;

  CartBloc({
    required this.getWaitersUseCase,
    required this.getDeliveryAgentsUseCase,
    required this.applyDiscountUseCase,
    required this.savePendingRestaurantPosInvoiceUseCase,
    required this.saveBookingTableRestaurantPosInvoiceUseCase,
    required this.getAllPersonsUseCase,
    required this.addPosClientUseCase,
    required this.updatePosClientUseCase,
    required this.getDynamicInvoiceDiscountUseCase,
    required this.getAllDeliveryCompanyUseCase,
  }) : super(const CartState()) {
    on<LoadCartDataEvent>(_onLoadCartData);
    on<SyncCartItemsEvent>(_onSyncCartItems);
    on<AddOrderItemToCartEvent>(_onAddOrderItem);
    on<LoadPersonsData>(_onLoadPersonData);
    on<SelectPersonEvent>(_onSelectPerson);
    on<SyncRestoredInvoiceEvent>(_onSyncRestoredInvoice);
    on<UpdateSettingsEvent>((event, emit) {
      emit(state.copyWith(settingsModel: event.settings));
    });
    on<SelectCartTableEvent>(
      (event, emit) => emit(state.copyWith(selectedTable: event.table)),
    );
    on<ChangeOrderTypeEvent>(_onChangeOrderType);
    on<SelectWaiterEvent>(
      (event, emit) => emit(state.copyWith(selectedWaiter: event.waiter)),
    );
    on<UpdateTakeawayDateTimeEvent>(
      (event, emit) =>
          emit(state.copyWith(fromBranchDateTime: event.takeawayDateTime)),
    );
    on<SelectDeliveryManEvent>(
      (event, emit) =>
          emit(state.copyWith(selectedDeliveryMan: event.deliveryMan)),
    );
    on<SelectDeliveryCompanyEvent>(
      (event, emit) => emit(
        state.copyWith(selectedDeliveryCompany: event.deliveryCompanyModel),
      ),
    );
    on<AcknowledgeCartRestoredEvent>((event, emit) {
      emit(state.copyWith(justRestored: false));
    });
    on<ChangeDiscountTypeEvent>(
      (event, emit) =>
          emit(state.copyWith(selectedDiscountType: event.discountType)),
    );
    on<UpdateItemQuantityEvent>(_onUpdateItemQuantity);
    on<RemoveItemEvent>(_onRemoveItem);
    on<HoldOrderEvent>(_onHoldOrder);
    on<SaveTableOrderEvent>(_saveTableOrder);
    on<ClearCartEvent>(_onClearCartEvent);
    on<AddPosClientEvent>(_addPosClient);
    on<UpdatePosClientEvent>(_updatePosClient);
    on<LoadDynamicDiscountsEvent>(_onLoadDynamicDiscounts);
    on<ChangeAddressEvent>(_onChangeAddress);
    on<EditCartItemEvent>(_onEditCartItem);
    on<ApplyDiscountEvent>(_onApplyDiscount);
    on<ApplyCouponDiscountEvent>(_onApplyCouponDiscount);
  }

  void _onChangeAddress(ChangeAddressEvent event, Emitter<CartState> emit) {
    emit(state.copyWith(selectedAddress: event.address));
  }

  void _onEditCartItem(EditCartItemEvent event, Emitter<CartState> emit) {
    final items = List<OrderItem>.from(state.items);
    final old = items[event.index];

    double addonsTotal = 0.0;
    for (final addon in event.selectedAddons) {
      addonsTotal += addon.price;
    }
    double lineTotal =
        (event.selectedSize.price ?? 0 + addonsTotal) * event.quantity;
    if (event.isPercentageDiscount) {
      lineTotal = lineTotal * (1 - (event.discount / 100));
    } else {
      lineTotal = (lineTotal - event.discount).clamp(0.0, double.infinity);
    }

    items[event.index] = old.copyWith(
      selectedSize: event.selectedSize,
      addons: event.selectedAddons,
      quantity: event.quantity,
      notes: event.notes,
      discount: event.discount,
      isPercentageDiscount: event.isPercentageDiscount,
    );

    emit(state.copyWith(items: items));
  }

  void _onSyncRestoredInvoice(
    SyncRestoredInvoiceEvent event,
    Emitter<CartState> emit,
  ) {
    final data = event.data;

    // 1. Determine discount strategy based on restored invoice data
    final hasInvoiceDiscount =
        data.restaurantPosDiscountRequest != null &&
        (data.restaurantPosDiscountRequest!.value) > 0;

    // 2. Clear opposing entity selections based on Order Type (Clean State Isolation)
    final isDineIn = data.orderType == CartOrderType.DINE_IN;
    final isDelivery = data.orderType == CartOrderType.DELIVERY;
    final isDeliveryCompany = data.orderType == CartOrderType.DELIVERY_COMPANY;

    emit(
      state.copyWith(
        // Primary Restored Data
        items: data.items,
        invoiceId: data.invoiceID,
        selectedOrderType: data.orderType,
        fromBranchDateTime: null,
        canEdit: event.canEdit,
        // Entities mapped according to active order type
        selectedTable: isDineIn ? data.table : null,
        selectedWaiter: isDineIn ? data.waiter : null,
        selectedDeliveryMan: isDelivery ? data.deliveryMan : null,
        selectedDeliveryCompany: isDeliveryCompany
            ? data.deliveryCompany
            : null,
        selectedPerson: data.client,

        // Discount Configuration
        restaurantPosDiscountRequest: data.restaurantPosDiscountRequest,
        selectedDiscountType: hasInvoiceDiscount
            ? DiscountTypeEnum.direct
            : DiscountTypeEnum.coupon,
        discountAmount: hasInvoiceDiscount
            ? (data.restaurantPosDiscountRequest!.value)
            : 0.0,

        // State Flags & Status
        justRestored: true,
        status: CartStatus
            .pindingSuccess, // Triggers state listeners without breaking UI flow
        isLoading: false,
        errorMessage: null,
      ),
    );
  }

  Future<void> _onLoadCartData(
    LoadCartDataEvent event,
    Emitter<CartState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final waitersRes = await getWaitersUseCase();
    final agentsRes = await getDeliveryAgentsUseCase();
    final deliveryCompaniesRes = await getAllDeliveryCompanyUseCase();

    List<WaiterModel> waitersList = [];
    List<WaiterModel> agentsList = [];
    List<DeliveryCompanyModel> companiesList = [];

    waitersRes.when(
      success: (data) => waitersList = data.data ?? [],
      failure: (_) {},
    );

    agentsRes.when(
      success: (data) => agentsList = data.data ?? [],
      failure: (_) {},
    );
    deliveryCompaniesRes.when(
      success: (data) => companiesList = data.data ?? [],
      failure: (_) {},
    );

    emit(
      state.copyWith(
        isLoading: false,
        waiters: waitersList,
        deliveryAgents: agentsList,
        companiesList: companiesList,
      ),
    );
  }

  Future<void> _onLoadPersonData(
    LoadPersonsData event,
    Emitter<CartState> emit,
  ) async {
    final personsRes = await getAllPersonsUseCase(request: event.request);

    List<PosClientModel> personsList = [];

    personsRes.when(
      success: (data) => personsList = data.data ?? [],
      failure: (_) {},
    );
    emit(state.copyWith(persons: personsList));
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
        transactionId: currentItem.transactionId,
      );
    } else {
      existingItems.add(event.item);
    }

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

  void _onSelectPerson(SelectPersonEvent event, Emitter<CartState> emit) {
    emit(state.copyWith(selectedPerson: event.person, clearAddress: true));
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
          transactionId: currentItem.transactionId,
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
    emit(
      state.copyWith(
        items: [],
        successMessage: null,
        selectedAddress: null,
        selectedDeliveryCompany: null,
        selectedDiscountType: null,
        selectedDeliveryMan: null,
        selectedOrderType: null,
        selectedPerson: null,
        selectedTable: null,
        selectedWaiter: null,
        restaurantPosDiscountRequest: null,
        fromBranchDateTime: null,
        customerDiscount: null,
        discountAmount: 0,

        couponDiscountvalue: null,

        clearCouponDiscountValue: true,
        clearCustomerDiscount: true,
        clearRestaurantPosDiscountRequest: true,
      ),
    );
  }

  Future<void> _onHoldOrder(
    HoldOrderEvent event,
    Emitter<CartState> emit,
  ) async {
    emit(state.copyWith(status: CartStatus.pindingLoading));
    final response = await savePendingRestaurantPosInvoiceUseCase(
      event.request,
    );
    response.when(
      success: (data) {
        if (data.result == 1) {
          emit(
            state.copyWith(
              status: CartStatus.pindingSuccess,
              successMessage: data.errorMessageAr,
            ),
          );
        } else {
          emit(
            state.copyWith(
              status: CartStatus.pindingFailure,
              errorMessage: data.errorMessageAr,
            ),
          );
        }
      },
      failure: (errorHandler) {
        emit(
          state.copyWith(
            status: CartStatus.pindingFailure,
            errorMessage: errorHandler.apiErrorModel.errorMessageAr,
          ),
        );
      },
    );
  }

  Future<void> _saveTableOrder(
    SaveTableOrderEvent event,
    Emitter<CartState> emit,
  ) async {
    emit(state.copyWith(status: CartStatus.pindingLoading));
    final response = await saveBookingTableRestaurantPosInvoiceUseCase(
      event.request,
    );
    response.when(
      success: (data) {
        if (data.result == 1) {
          emit(
            state.copyWith(
              status: CartStatus.pindingSuccess,
              successMessage: data.errorMessageAr,
            ),
          );
        } else {
          emit(
            state.copyWith(
              status: CartStatus.pindingFailure,
              errorMessage: data.errorMessageAr,
            ),
          );
        }
      },
      failure: (errorHandler) {
        emit(
          state.copyWith(
            status: CartStatus.pindingFailure,
            errorMessage: errorHandler.apiErrorModel.errorMessageAr,
          ),
        );
      },
    );
  }

  Future<void> _addPosClient(
    AddPosClientEvent event,
    Emitter<CartState> emit,
  ) async {
    try {
      emit(state.copyWith(status: CartStatus.loading));
      final response = await addPosClientUseCase(request: event.request);
      response.when(
        success: (data) {
          if (data.result == 1) {
            emit(
              state.copyWith(
                status: CartStatus.success,
                successMessage: data.errorMessageAr,
              ),
            );
          } else {
            emit(
              state.copyWith(
                status: CartStatus.failure,
                errorMessage: data.errorMessageAr,
              ),
            );
          }
        },
        failure: (errorHandler) {
          emit(
            state.copyWith(
              status: CartStatus.failure,
              errorMessage: errorHandler.apiErrorModel.errorMessageAr,
            ),
          );
        },
      );
    } catch (e) {
      emit(
        state.copyWith(status: CartStatus.failure, errorMessage: e.toString()),
      );
    }
  }

  Future<void> _updatePosClient(
    UpdatePosClientEvent event,
    Emitter<CartState> emit,
  ) async {
    try {
      emit(state.copyWith(status: CartStatus.loading));
      final response = await updatePosClientUseCase(request: event.request);
      response.when(
        success: (data) {
          if (data.result == 1) {
            emit(
              state.copyWith(
                status: CartStatus.success,
                successMessage: data.errorMessageAr,
              ),
            );
          } else {
            emit(
              state.copyWith(
                status: CartStatus.failure,
                errorMessage: data.errorMessageAr,
              ),
            );
          }
        },
        failure: (errorHandler) {
          emit(
            state.copyWith(
              status: CartStatus.failure,
              errorMessage: errorHandler.apiErrorModel.errorMessageAr,
            ),
          );
        },
      );
    } catch (e) {
      emit(
        state.copyWith(status: CartStatus.failure, errorMessage: e.toString()),
      );
    }
  }

  FutureOr<void> _onLoadDynamicDiscounts(
    LoadDynamicDiscountsEvent event,
    Emitter<CartState> emit,
  ) async {
    try {
      final response = await getDynamicInvoiceDiscountUseCase();
      response.when(
        success: (data) {
          if (data.result == 1) {
            final activeDiscounts = checkAvailability(data.data);

            emit(state.copyWith(activeDiscounts: activeDiscounts));
          } else {
            emit(state.copyWith(errorMessage: data.errorMessageAr));
          }
        },
        failure: (errorHandler) {
          emit(
            state.copyWith(
              errorMessage: errorHandler.apiErrorModel.errorMessageAr,
            ),
          );
        },
      );
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  List<DynamicDiscountModel> checkAvailability(
    List<DynamicDiscountModel>? data,
  ) {
    if (data == null || data.isEmpty) return [];

    final now = DateTime.now();
    final activeDiscounts = <DynamicDiscountModel>[];

    for (final d in data) {
      final discount = d.discount;
      if (discount == null) continue;

      final startDate = discount.startDate;
      final endDate = discount.endDate;

      if (startDate != null && endDate != null) {
        final today = DateTime(now.year, now.month, now.day);
        final start = DateTime(startDate.year, startDate.month, startDate.day);
        final end = DateTime(endDate.year, endDate.month, endDate.day);

        if (today.isBefore(start) || today.isAfter(end)) {
          continue;
        }
      }

      final startTime = discount.startTime;
      final endTime = discount.endTime;

      if (startTime != null && endTime != null) {
        final currentMinutes = now.hour * 60 + now.minute;
        final startMinutes = startTime.hour * 60 + startTime.minute;
        final endMinutes = endTime.hour * 60 + endTime.minute;

        if (currentMinutes < startMinutes || currentMinutes > endMinutes) {
          continue;
        }
      }

      activeDiscounts.add(d);
    }

    return activeDiscounts;
  }

  Future<void> _onApplyDiscount(
    ApplyDiscountEvent event,
    Emitter<CartState> emit,
  ) async {
    emit(
      state.copyWith(
        restaurantPosDiscountRequest: event.restaurantPosDiscountRequest,
        couponDiscountvalue: 0.0, // Reset coupon discount
        selectedDiscountType: DiscountTypeEnum.direct,
        activeDiscountModel: null,
      ),
    );
  }

  Future<void> _onApplyCouponDiscount(
    ApplyCouponDiscountEvent event,
    Emitter<CartState> emit,
  ) async {
    final double discountVal = double.tryParse(event.code) ?? 0.0;

    emit(
      state.copyWith(
        couponDiscountvalue: discountVal,
        restaurantPosDiscountRequest: null, // Reset direct discount
        selectedDiscountType: DiscountTypeEnum.coupon,
        activeDiscountModel: null,
      ),
    );
  }
}

import 'dart:async';
import 'dart:developer';

import 'package:apex_restaurant/core/shared/usescase/shared_usescase.dart';
import 'package:apex_restaurant/featchers/calculation/data/models/calculation_requests.dart';
import 'package:apex_restaurant/featchers/calculation/data/models/calculation_result.dart';
import 'package:apex_restaurant/featchers/calculation/domain/usecases/add_item_usecase.dart';
import 'package:apex_restaurant/featchers/calculation/domain/usecases/clear_calculation_items_usecase.dart';
import 'package:apex_restaurant/featchers/calculation/domain/usecases/edit_calculation_item_usecase.dart.dart';
import 'package:apex_restaurant/featchers/calculation/domain/usecases/open_new_cart_usecase.dart';
import 'package:apex_restaurant/featchers/calculation/domain/usecases/remove_calculation_cart_usecase.dart';
import 'package:apex_restaurant/featchers/pos/data/models/delivery_company.dart';
import 'package:apex_restaurant/featchers/pos/data/models/restaurant_item.dart';
import 'package:apex_restaurant/featchers/pos/domain/entities/get_items_request_model.dart';
import 'package:apex_restaurant/featchers/pos/domain/usecases/pos_usecases.dart';

import '../../../../core/service/api_result.dart';
import '../../data/enums/cart_enum.dart';
import '../../data/models/dynamic_discount.dart';
import '../../data/models/pos_client_model.dart';
import '../../data/models/waiter_model.dart';
import '../../domain/usescase/cart_usescase.dart';
import '../../../pos/data/models/category_model.dart';
import '../../../pos/domain/entities/order_item.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final GetWaitersUseCase getWaitersUseCase;
  final GetDeliveryAgentsUseCase getDeliveryAgentsUseCase;
  final ApplyDiscountUseCase applyDiscountUseCase;
  final CheckVoucherUseCase checkVoucherUseCase;
  final SavePendingRestaurantPosInvoiceUseCase
  savePendingRestaurantPosInvoiceUseCase;
  final SaveBookingTableRestaurantPosInvoiceUseCase
  saveBookingTableRestaurantPosInvoiceUseCase;
  final GetInvoiceReportUseCase getInvoiceReportUseCase;
  final GetAllDeliveryCompanyUseCase getAllDeliveryCompanyUseCase;
  final GetPosMenuItemsUseCase getMenuItemsByCompanyIdUseCase;
  final GetAllPosClientsUseCase getAllPersonsUseCase;
  final AddPosClientUseCase addPosClientUseCase;
  final UpdatePosClientUseCase updatePosClientUseCase;
  final GetDynamicInvoiceDiscountUseCase getDynamicInvoiceDiscountUseCase;
  final AddCalculationItemUseCase addCalculationItemUseCase;
  final OpenNewCalculationCartUseCase openNewCalculationCartUseCase;

  final EditCalculationItemUseCase editCalculationItemUseCase;
  final ClearCalculationItemsUseCase clearCalculationItemsUseCase;
  final RemoveCalculationCartUseCase removeCalculationCartUseCase;
  final Map<int, int> _returnLimits = {};

  int returnLimitFor(OrderItem item) {
    final current = (item.availableQuantity ?? 0).toInt();
    final key = item.invoiceDetailsId;
    if (key == null) return current;
    return _returnLimits[key] ?? current;
  }

  final Map<int, int> _addonReturnLimits = {};

  int returnAddonLimitFor(AdditiveModel addon) {
    final current = (addon.availableQuantity ?? 0).toInt();
    final key = addon.invoiceDetailsId;
    if (key == null) return current;
    return _addonReturnLimits[key] ?? current;
  }

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
    required this.checkVoucherUseCase,
    required this.getMenuItemsByCompanyIdUseCase,
    required this.getInvoiceReportUseCase,
    required this.addCalculationItemUseCase,
    required this.openNewCalculationCartUseCase,
    required this.editCalculationItemUseCase,
    required this.clearCalculationItemsUseCase,
    required this.removeCalculationCartUseCase,
  }) : super(const CartState()) {
    on<OpenNewCartEvent>(_onOpenCalculationCart);
    on<AddCalculationItemEvent>(_onAddCalculationItem);
    on<UpdateCalculationItemEvent>(_onUpdateCalculationItem);
    on<RemoveCalculationItemEvent>(_onRemoveCalculationItem);
    on<RemoveAllCalculationItemsEvent>(_onRemoveAllCalculationItems);
    on<RemoveCalculationCartEvent>(_onRemoveCalculationCart);
    on<LoadCartDataEvent>(_onLoadCartData);
    on<SyncCartItemsEvent>(_onSyncCartItems);
    on<AddOrderItemToCartEvent>(_onAddOrderItem);
    on<LoadPersonsData>(_onLoadPersonData);
    on<SelectPersonEvent>(_onSelectPerson);

    on<UpdateItemsPriceWithCompanyEvent>(_updateItemsPriceForCompanies);
    on<ClearVoucherDiscountEvent>(
      (event, emit) => state.isReturn
          ? null
          : emit(
              state.copyWith(
                voucherData: null,
                clearVoucherDiscountValue: true,
                clearMessage: true,
              ),
            ),
    );
    on<ClearDiscountEvent>(
      (event, emit) => state.isReturn
          ? null
          : emit(
              state.copyWith(
                restaurantPosDiscountRequest: null,
                clearRestaurantPosDiscountRequest: true,
                discountAmount: 0,
                clearMessage: true,
              ),
            ),
    );
    on<SyncRestoredInvoiceEvent>(_onSyncRestoredInvoice);
    on<UpdateSettingsEvent>((event, emit) {
      emit(state.copyWith(settingsModel: event.settings, clearMessage: true));
    });
    on<SelectCartTableEvent>(
      (event, emit) =>
          emit(state.copyWith(selectedTable: event.table, clearMessage: true)),
    );
    on<ChangeOrderTypeEvent>(_onChangeOrderType);
    on<SelectWaiterEvent>(
      (event, emit) => emit(
        state.copyWith(selectedWaiter: event.waiter, clearMessage: true),
      ),
    );
    on<UpdateTakeawayDateTimeEvent>(
      (event, emit) => emit(
        state.copyWith(
          fromBranchDateTime: event.takeawayDateTime,
          clearMessage: true,
        ),
      ),
    );
    on<SelectDeliveryManEvent>(
      (event, emit) => emit(
        state.copyWith(
          selectedDeliveryMan: event.deliveryMan,
          clearMessage: true,
        ),
      ),
    );
    on<SelectDeliveryCompanyEvent>((event, emit) {
      emit(
        state.copyWith(
          selectedDeliveryCompany: event.deliveryCompanyModel,
          clearMessage: true,
        ),
      );
      add(UpdateItemsPriceWithCompanyEvent());
    });
    on<AcknowledgeCartRestoredEvent>((event, emit) {
      emit(
        state.copyWith(
          justRestored: false,
          errorMessage: null,
          successMessage: null,
          clearMessage: true,
        ),
      );
    });
    on<ChangeDiscountTypeEvent>(
      (event, emit) => emit(
        state.copyWith(
          selectedDiscountType: event.discountType,
          clearMessage: true,
        ),
      ),
    );
    on<UpdateItemQuantityEvent>(_onUpdateItemQuantity);
    on<RemoveItemEvent>(_onRemoveItem);
    on<HoldOrderEvent>(_onHoldOrder);
    on<SaveTableOrderEvent>(_saveTableOrder);
    on<GetInvoiceReportEvent>(_onInvoiceReport);
    on<ClearCartEvent>(_onClearCartEvent);
    on<AddPosClientEvent>(_addPosClient);
    on<UpdatePosClientEvent>(_updatePosClient);
    on<LoadDynamicDiscountsEvent>(_onLoadDynamicDiscounts);
    on<ChangeAddressEvent>(_onChangeAddress);
    on<EditCartItemEvent>(_onEditCartItem);
    on<ApplyDiscountEvent>(_onApplyDiscount);
    on<ApplyVoucherDiscountEvent>(_onApplyVoucherDiscount);
  }
  // Future<void> _openNewCart(
  //   OpenNewCartEvent event,
  //   Emitter<CartState> emit,
  // ) async {
  //   emit(state.copyWith(status: CartStatus.loading));
  //   try {
  //     final result = await openNewCalculationCartUseCase(
  //       event.openNewCartRequest,
  //     );
  //     if (result != null) {
  //       log("cart Id: $result");
  //       emit(
  //         state.copyWith(status: CartStatus.success, calculationCartId: result),
  //       );
  //     }
  //   } catch (e) {
  //     emit(
  //       state.copyWith(
  //         status: CartStatus.failure,
  //         errorMessage: ErrorHandler.handle(e).apiErrorModel.errorMessageAr,
  //       ),
  //     );
  //   }
  // }
  Future<void> _onOpenCalculationCart(
    OpenNewCartEvent event,
    Emitter<CartState> emit,
  ) async {
    try {
      emit(state.copyWith(status: CartStatus.loading, clearMessage: true));

      final cartId = await openNewCalculationCartUseCase(
        event.openNewCartRequest,
      );

      emit(
        state.copyWith(
          calculationCartId: cartId,
          calculationResult: const CalculationResult(),
          status: CartStatus.success,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: CartStatus.failure, errorMessage: e.toString()),
      );
    }
  }

  Future<void> _onRemoveCalculationCart(
    RemoveCalculationCartEvent event,
    Emitter<CartState> emit,
  ) async {
    final cartId = state.calculationCartId;

    if (cartId == null) return;

    try {
      emit(state.copyWith(status: CartStatus.loading));

      await removeCalculationCartUseCase(cartId);

      emit(
        state.copyWith(
          clearCalculationCart: true,
          clearCalculationResult: true,
          status: CartStatus.success,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: CartStatus.failure, errorMessage: e.toString()),
      );
    }
  }

  Future<void> _onAddCalculationItem(
    AddCalculationItemEvent event,
    Emitter<CartState> emit,
  ) async {
    try {
      if (state.calculationCartId == null) {
        throw Exception('Calculation cart is not opened');
      }

      emit(state.copyWith(status: CartStatus.itemsUpdateing));

      final result = await addCalculationItemUseCase(request: event.request);

      emit(
        state.copyWith(
          calculationResult: result,
          status: CartStatus.itemsUpdated,
          clearMessage: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: CartStatus.failure, errorMessage: e.toString()),
      );
    }
  }

  Future<void> _onUpdateCalculationItem(
    UpdateCalculationItemEvent event,
    Emitter<CartState> emit,
  ) async {
    try {
      if (state.calculationCartId == null) {
        throw Exception('Calculation cart is not opened');
      }

      emit(state.copyWith(status: CartStatus.itemsUpdateing));

      final result = await editCalculationItemUseCase(event.request);

      emit(
        state.copyWith(
          calculationResult: result,
          status: CartStatus.itemsUpdated,
          clearMessage: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: CartStatus.failure, errorMessage: e.toString()),
      );
    }
  }

  Future<void> _onRemoveCalculationItem(
    RemoveCalculationItemEvent event,
    Emitter<CartState> emit,
  ) async {
    final cartId = state.calculationCartId;

    if (cartId == null) return;

    try {
      emit(state.copyWith(status: CartStatus.itemsUpdateing));

      await clearCalculationItemsUseCase(cartId);
      CalculationResult? finalresult;
      for (final item in event.remainingItems) {
        finalresult = await addCalculationItemUseCase(
          request: AddCalculationItemRequest(
            cartId: cartId,
            itemId: item.itemId,
            quantity: item.quantity,
            unitPrice: item.unitPrice,
            vatRatio: item.vatRatio,
            itemDiscount: item.itemDiscount,
            minimumCharge: item.minimumCharge,
            maximumDiscount: item.maximumDiscount,
            isAutoDiscount: item.isAutoDiscount,
            itemTypeId: item.itemTypeId,
            isTobacco: item.isTobacco,
            transactionId: item.transactionId,
            parentTransactionId: item.parentTransactionId,
          ),
        );
      }

      emit(
        state.copyWith(
          calculationResult: finalresult,
          status: CartStatus.itemsUpdated,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: CartStatus.failure, errorMessage: e.toString()),
      );
    }
  }

  Future<void> _onRemoveAllCalculationItems(
    RemoveAllCalculationItemsEvent event,
    Emitter<CartState> emit,
  ) async {
    final cartId = state.calculationCartId;

    if (cartId == null) return;

    try {
      emit(state.copyWith(status: CartStatus.itemsUpdateing));

      final result = await clearCalculationItemsUseCase(cartId);

      emit(
        state.copyWith(
          calculationResult: result,
          status: CartStatus.itemsUpdated,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: CartStatus.failure, errorMessage: e.toString()),
      );
    }
  }

  /// The Calculation API does not expose a confirmed single-item delete
  /// endpoint. Rebuild the calculation cart to keep it aligned with local items.
  /// Return invoices are intentionally excluded from this integration.
  Future<CalculationResult?> _replaceCalculationItems(
    List<OrderItem> items,
  ) async {
    final cartId = state.calculationCartId;
    if (cartId == null || cartId.isEmpty || state.isReturn) return null;

    CalculationResult? result = await clearCalculationItemsUseCase(cartId);
    for (final item in items) {
      result = await addCalculationItemUseCase(
        request: AddCalculationItemRequest(
          cartId: cartId,
          itemId: item.menuItem.itemId,
          quantity: item.quantity.toDouble(),
          unitPrice: item.selectedSize?.price ?? 0,
          vatRatio: state.settingsModel?.vat?.vatDefaultValue ?? 0,
          itemDiscount: item.discountAmount,
          minimumCharge: state.dynamicDiscountIsActive
              ? state.activeDiscountModel?.discount?.minInvoiceNET ?? 0
              : 0,
          maximumDiscount: state.dynamicDiscountIsActive
              ? state.activeDiscountModel?.discount?.maxDiscountValue ?? 0
              : 0,
          isAutoDiscount: state.dynamicDiscountIsActive,
          itemTypeId: item.menuItem.itemTypeId ?? 0,
          isTobacco: item.menuItem.isTobaccoTax ?? false,
          transactionId: item.transactionId,
        ),
      );
    }
    return result;
  }

  void _onChangeAddress(ChangeAddressEvent event, Emitter<CartState> emit) {
    emit(
      state.copyWith(
        selectedAddress: event.address,
        status: CartStatus.initial,
        clearMessage: true,
      ),
    );
  }

  Future<void> _onEditCartItem(
    EditCartItemEvent event,
    Emitter<CartState> emit,
  ) async {
    final items = List<OrderItem>.from(state.items);
    final old = items[event.index];

    final isReturn = state.isReturnInvoice == true;
    var quantity = event.quantity;
    int? returnQuantity;

    if (isReturn) {
      final limit = returnLimitFor(old);
      if (limit <= 0) return;
      returnQuantity = event.quantity.clamp(1, limit).toInt();
      quantity = old.quantity;
    }

    items[event.index] = old.copyWith(
      selectedSize: event.selectedSize,
      addons: event.selectedAddons,
      quantity: quantity,
      availableQuantity: returnQuantity?.toDouble() ?? old.availableQuantity,
      notes: event.notes,
      discount: isReturn ? old.discount : event.discount,
      isPercentageDiscount: isReturn
          ? old.isPercentageDiscount
          : event.isPercentageDiscount,
    );

    emit(
      state.copyWith(
        items: items,
        status: CartStatus.itemsUpdated,
        clearMessage: true,
      ),
    );

    if (!isReturn && state.calculationCartId != null) {
      try {
        emit(state.copyWith(status: CartStatus.itemsUpdateing));
        final result = await _replaceCalculationItems(items);
        emit(
          state.copyWith(
            calculationResult: result,
            status: CartStatus.itemsUpdated,
            clearMessage: true,
          ),
        );
      } catch (e) {
        emit(
          state.copyWith(
            status: CartStatus.failure,
            errorMessage: e.toString(),
          ),
        );
      }
    }
  }

  Future<void> _updateItemsPriceForCompanies(
    UpdateItemsPriceWithCompanyEvent event,
    Emitter<CartState> emit,
  ) async {
    emit(state.copyWith(status: CartStatus.itemsUpdateing));
    final itmemIds = state.items.map((i) => i.menuItem.itemId).toList();

    final response = await getMenuItemsByCompanyIdUseCase(
      GetItemsRequest(
        itemIds: itmemIds,
        companyId: state.selectedOrderType == CartOrderType.DELIVERY_COMPANY
            ? state.selectedDeliveryCompany?.id
            : null,
      ),
    );

    response.when(
      success: (data) {
        final items = data.data ?? [];
        if (items.isNotEmpty) {
          final orderItems = _updatePrices(items);
          emit(
            state.copyWith(
              items: orderItems,
              status: CartStatus.itemsUpdated,
              clearMessage: true,
            ),
          );
        }
      },
      failure: (errorHandler) {},
    );
  }

  List<OrderItem> _updatePrices(List<RestaurantItem> items) {
    final oldItems = state.items;
    final List<OrderItem> newItems = [];

    for (final oldItem in oldItems) {
      final newItem = items.firstWhere(
        (e) => e.itemId == oldItem.menuItem.itemId,
      );

      final orderItem = oldItem.copyWith(
        menuItem: newItem,
        selectedSize: newItem.sizes.first,
      );

      newItems.add(orderItem);
    }

    return newItems;
  }

  void _onSyncRestoredInvoice(
    SyncRestoredInvoiceEvent event,
    Emitter<CartState> emit,
  ) {
    final data = event.data;

    _returnLimits.clear();
    _addonReturnLimits.clear();
    if (data.isReturnInvoice == true) {
      for (final i in data.items) {
        final id = i.invoiceDetailsId;
        if (id != null) _returnLimits[id] = (i.availableQuantity ?? 0).toInt();
        for (final a in i.addons) {
          final aid = a.invoiceDetailsId;
          if (aid != null) {
            _addonReturnLimits[aid] = (a.availableQuantity ?? 0).toInt();
          }
        }
      }
    }

    // 1. Determine discount strategy based on restored invoice data
    final hasInvoiceDiscount =
        data.restaurantPosDiscountRequest != null &&
        (data.restaurantPosDiscountRequest!.value) > 0;

    // 2. Clear opposing entity selections based on Order Type (Clean State Isolation)
    final isDineIn = data.orderType == CartOrderType.DINE_IN;
    final isDelivery = data.orderType == CartOrderType.DELIVERY;
    final isDeliveryCompany = data.orderType == CartOrderType.DELIVERY_COMPANY;
    final selectedDeliveryCompany =
        isDeliveryCompany && state.companiesList.isNotEmpty
        ? state.companiesList.firstWhere(
            (c) => c.id == data.deliveryCompany?.id,
          )
        : null;
    emit(
      state.copyWith(
        // Primary Restored Data
        items: data.items,
        invoiceId: data.invoiceID,
        selectedOrderType: data.orderType,
        fromBranchDateTime: null,
        canEdit: event.canEdit,
        isPending: event.isPending,
        isPreviousInvoice:
            !(event.data.isReturnInvoice ?? false) && !event.isPending,
        selectedWaiter: isDineIn ? data.waiter : null,
        selectedDeliveryMan: isDelivery
            ? state.deliveryAgents.firstWhere(
                (d) => d.id == data.deliveryMan?.id,
              )
            : null,
        selectedPerson: data.client,
        selectedDeliveryCompany: selectedDeliveryCompany,
        voucherId: data.voucherId,
        invoiceCode: data.invoiceCode,
        orderNumber: data.orderNumber,
        selectedTable: isDineIn ? data.table : null,
        // Discount Configuration
        restaurantPosDiscountRequest: data.restaurantPosDiscountRequest,
        selectedDiscountType: hasInvoiceDiscount
            ? DiscountTypeEnum.direct
            : DiscountTypeEnum.coupon,
        discountAmount: hasInvoiceDiscount
            ? (data.restaurantPosDiscountRequest!.value)
            : 0.0,

        // Drop any stale "current" discounts from a previous cart so only
        // the restored invoice discounts remain.
        clearActiveDiscountModel: true,
        clearCustomerDiscount: true,
        clearVoucherDiscountValue: true,

        // State Flags & Status
        justRestored: true,
        // status: CartStatus
        //     .success, // Triggers state listeners without breaking UI flow
        isLoading: false,
        errorMessage: null,
        successMessage: null,
        clearMessage: true,
        isReturnInvoice: data.isReturnInvoice,
        priceIncludeVat: data.priceIncludeVat,
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
        selectedWaiter: waitersList.isNotEmpty ? waitersList.first : null,
        deliveryAgents: agentsList,
        selectedDeliveryMan: agentsList.isNotEmpty ? agentsList.first : null,
        companiesList: companiesList,
        selectedDeliveryCompany: companiesList.isNotEmpty
            ? companiesList.first
            : null,
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
    emit(
      state.copyWith(
        persons: personsList,
        selectedPerson: personsList.isNotEmpty ? personsList.first : null,
        clearMessage: true,
      ),
    );
  }

  void _onSyncCartItems(SyncCartItemsEvent event, Emitter<CartState> emit) {
    emit(
      state.copyWith(
        status: CartStatus.itemsUpdated,
        items: event.items,
        clearMessage: true,
      ),
    );
  }

  void _onAddOrderItem(
    AddOrderItemToCartEvent event,
    Emitter<CartState> emit,
  ) async {
    emit(state.copyWith(status: CartStatus.itemsUpdateing));
    try {
      final calculationCartId = state.calculationCartId;
      if (calculationCartId == null || calculationCartId.isEmpty) {
        throw StateError('Calculation cart is not opened');
      }
      final response = await addCalculationItemUseCase(
        request: AddCalculationItemRequest(
          cartId: calculationCartId,
          itemId: event.item.menuItem.itemId,
          quantity: event.item.quantity.toDouble(),
          unitPrice: event.item.selectedSize?.price ?? 0,
          vatRatio: state.settingsModel?.vat?.vatDefaultValue ?? 0,
          itemDiscount: event.item.discountAmount,
          minimumCharge: state.dynamicDiscountIsActive
              ? state.activeDiscountModel?.discount?.minInvoiceNET ?? 0
              : 0,
          maximumDiscount: state.dynamicDiscountIsActive
              ? state.activeDiscountModel?.discount?.maxDiscountValue ?? 0
              : 0,
          isAutoDiscount: state.dynamicDiscountIsActive,
          itemTypeId: event.item.menuItem.itemTypeId ?? 0,
          isTobacco: event.item.menuItem.isTobaccoTax ?? false,
          transactionId: event.item.transactionId,
        ),
      );
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

      emit(
        state.copyWith(
          status: .itemsUpdated,
          calculationResult: response,
          items: existingItems,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: CartStatus.failure, errorMessage: e.toString()),
      );
    }

    // emit(
    //   state.copyWith(
    //     items: existingItems,
    //     status: CartStatus.itemsUpdated,
    //     clearMessage: true,
    //   ),
    // );
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
    emit(
      state.copyWith(
        selectedPerson: event.person,
        selectedAddress:
            (event.person == null || event.person!.personAddress!.isEmpty)
            ? null
            : event.person!.personAddress!.first,
        clearVoucherDiscountValue: state.selectedPerson != event.person,
        clearMessage: true,
      ),
    );
  }

  void _onChangeOrderType(ChangeOrderTypeEvent event, Emitter<CartState> emit) {
    final oldType = state.selectedOrderType;
    if (state.isReturn) return;
    emit(
      state.copyWith(
        selectedOrderType: event.orderType,
        clearVoucherDiscountValue: event.orderType != state.selectedOrderType
            ? true
            : false,
        clearMessage: true,
      ),
    );
    if (oldType == CartOrderType.DELIVERY_COMPANY ||
        event.orderType == CartOrderType.DELIVERY_COMPANY) {
      add(UpdateItemsPriceWithCompanyEvent());
    }
  }

  Future<void> _onUpdateItemQuantity(
    UpdateItemQuantityEvent event,
    Emitter<CartState> emit,
  ) async {
    if (event.index < 0 || event.index >= state.items.length) return;

    final updatedItems = List<OrderItem>.from(state.items);
    final currentItem = updatedItems[event.index];

    if (state.isReturnInvoice == true) {
      // Return invoice: work with availableQuantity (1..original limit).
      final limit = returnLimitFor(currentItem);
      final current = (currentItem.availableQuantity ?? 0).toInt();
      final next = current + event.delta;

      if (limit <= 0 || next < 1 || next > limit) return;

      updatedItems[event.index] = currentItem.copyWith(
        availableQuantity: next.toDouble(),
      );
    } else {
      // Normal invoice: work with quantity.
      final next = currentItem.quantity + event.delta;
      if (next <= 0) {
        updatedItems.removeAt(event.index);
      } else {
        updatedItems[event.index] = currentItem.copyWith(quantity: next);
      }
    }

    emit(
      state.copyWith(
        items: updatedItems,
        status: CartStatus.itemsUpdated,
        clearMessage: true,
      ),
    );

    if (state.isReturn || state.calculationCartId == null) return;
    try {
      emit(state.copyWith(status: CartStatus.itemsUpdateing));
      final result = await _replaceCalculationItems(updatedItems);
      emit(
        state.copyWith(
          calculationResult: result,
          status: CartStatus.itemsUpdated,
          clearMessage: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: CartStatus.failure, errorMessage: e.toString()),
      );
    }
  }

  Future<void> _onRemoveItem(
    RemoveItemEvent event,
    Emitter<CartState> emit,
  ) async {
    if (event.index < 0 || event.index >= state.items.length) return;

    final updated = List<OrderItem>.from(state.items)..removeAt(event.index);
    emit(
      state.copyWith(
        items: updated,
        status: CartStatus.itemsUpdated,
        clearMessage: true,
      ),
    );

    if (state.isReturn || state.calculationCartId == null) return;
    try {
      emit(state.copyWith(status: CartStatus.itemsUpdateing));
      final result = await _replaceCalculationItems(updated);
      emit(
        state.copyWith(
          calculationResult: result,
          status: CartStatus.itemsUpdated,
          clearMessage: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: CartStatus.failure, errorMessage: e.toString()),
      );
    }
  }

  Future<void> _onClearCartEvent(
    ClearCartEvent event,
    Emitter<CartState> emit,
  ) async {
    _returnLimits.clear();
    _addonReturnLimits.clear();
    final calculationCartId = state.calculationCartId;
    if (calculationCartId != null && calculationCartId.isNotEmpty) {
      try {
        await removeCalculationCartUseCase(calculationCartId);
      } catch (e) {
        log('Failed to remove calculation cart: $e');
      }
    }
    emit(
      state.copyWith(
        status: CartStatus.initial,
        items: [],
        isPreviousInvoice: false,
        clearMessage: true,
        errorMessage: null,
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
        canEdit: true,
        couponDiscountvalue: null,
        invoiceCode: null,
        invoiceId: null,
        voucherId: null,
        restoredInvoiceDate: null,
        justRestored: false,
        orderNumber: 0,
        isPending: false,
        clearVoucherDiscountValue: true,
        clearCustomerDiscount: true,
        clearRestaurantPosDiscountRequest: true,
        clearInvoiceId: true,
        clearCart: true,
        clearCalculationCart: true,
        clearCalculationResult: true,
        isReturnInvoice: false,
        // SaveTableData: null,
      ),
    );
  }

  Future<void> _onHoldOrder(
    HoldOrderEvent event,
    Emitter<CartState> emit,
  ) async {
    emit(state.copyWith(status: CartStatus.pindingLoading, clearMessage: true));
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
    emit(
      state.copyWith(
        status: CartStatus.saveDineInInvoiceLoading,
        clearMessage: true,
      ),
    );
    final response = await saveBookingTableRestaurantPosInvoiceUseCase(
      event.request,
    );
    response.when(
      success: (data) {
        log(" success: ${data.data}");
        if (data.result == 1) {
          log("data : ${data.data?.toJson()}");
          emit(
            state.copyWith(
              status: CartStatus.saveDineInInvoiceSuccess,
              successMessage: data.errorMessageAr,
              saveTableData: data.data,
            ),
          );
        } else {
          emit(
            state.copyWith(
              status: CartStatus.saveDineInInvoiceFailure,
              errorMessage: data.errorMessageAr,
            ),
          );
        }
      },
      failure: (errorHandler) {
        emit(
          state.copyWith(
            status: CartStatus.saveDineInInvoiceFailure,
            errorMessage: errorHandler.apiErrorModel.errorMessageAr,
          ),
        );
      },
    );
  }

  Future<void> _onInvoiceReport(
    GetInvoiceReportEvent event,
    Emitter<CartState> emit,
  ) async {
    emit(
      state.copyWith(status: CartStatus.invoiceReportLoading, isLoading: true),
    );
    try {
      final response = await getInvoiceReportUseCase(request: event.request);
      response.when(
        success: (data) {
          if (data?.result != null && data!.result != 0) {
            emit(
              state.copyWith(
                status: CartStatus.invoiceReportSuccess,
                invoiceReportResponse: data,
                isLoading: false,
              ),
            );
          } else {
            emit(
              state.copyWith(
                status: CartStatus.invoiceReportFailure,
                errorMessage: data?.errorMessageAr ?? 'فشل استرجاع التقرير',
                isLoading: false,
              ),
            );
          }
        },
        failure: (err) {
          emit(
            state.copyWith(
              status: CartStatus.invoiceReportFailure,
              errorMessage:
                  err.apiErrorModel.errorMessageAr ?? 'خطأ في الاتصال بالخادم',
              isLoading: false,
            ),
          );
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: CartStatus.invoiceReportFailure,
          errorMessage: 'حدث خطأ غير متوقع أثناء استرجاع التقرير',
          isLoading: false,
        ),
      );
    }
  }

  Future<void> _addPosClient(
    AddPosClientEvent event,
    Emitter<CartState> emit,
  ) async {
    try {
      emit(state.copyWith(status: CartStatus.loading, clearMessage: true));
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
      emit(state.copyWith(status: CartStatus.loading, clearMessage: true));
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

            emit(
              state.copyWith(
                activeDiscounts: activeDiscounts,
                clearMessage: true,
              ),
            );
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
    // Return invoices keep the discount restored from the original invoice
    if (state.isReturn) return;

    emit(
      state.copyWith(
        status: CartStatus.itemsUpdated,
        restaurantPosDiscountRequest: event.restaurantPosDiscountRequest,
        couponDiscountvalue: 0.0, // Reset coupon discount
        selectedDiscountType: DiscountTypeEnum.direct,
        activeDiscountModel: null,
        voucherData: null,
        clearMessage: true,
      ),
    );
  }

  Future<void> _onApplyVoucherDiscount(
    ApplyVoucherDiscountEvent event,
    Emitter<CartState> emit,
  ) async {
    // Vouchers are not allowed on return invoices
    if (state.isReturn) return;

    final response = await checkVoucherUseCase(event.request);

    response.when(
      success: (data) {
        if (data.result == 1) {
          emit(
            state.copyWith(
              selectedDiscountType: DiscountTypeEnum.coupon,
              voucherData: data.data,
              status: CartStatus.itemsUpdated,
              clearMessage: true,
            ),
          );
        } else {
          emit(
            state.copyWith(
              voucherData: null,
              status: CartStatus.failure,
              errorMessage: data.errorMessageAr,
            ),
          );
        }
      },
      failure: (errorHandler) {
        emit(
          state.copyWith(
            voucherData: null,
            status: CartStatus.failure,
            errorMessage: errorHandler.apiErrorModel.errorMessageAr,
          ),
        );
      },
    );
  }
}

import 'dart:async';
import 'dart:developer';

import 'package:apex_restaurant/core/helpers/restaurant_constants.dart';
import 'package:apex_restaurant/core/helpers/transactionid_generator.dart';
import 'package:apex_restaurant/core/service/api_constants.dart';
import 'package:apex_restaurant/core/shared/usescase/shared_usescase.dart';
import 'package:apex_restaurant/featchers/calculation/data/models/calculation_requests.dart';
import 'package:apex_restaurant/featchers/calculation/data/models/calculation_result.dart';
import 'package:apex_restaurant/featchers/calculation/data/models/enums/calculation_enums.dart';
import 'package:apex_restaurant/featchers/calculation/data/models/item_line_preview.dart';
import 'package:apex_restaurant/featchers/calculation/domain/usecases/add_item_usecase.dart';
import 'package:apex_restaurant/featchers/calculation/domain/usecases/apply_discount_usecase.dart';
import 'package:apex_restaurant/featchers/calculation/domain/usecases/clear_calculation_items_usecase.dart';
import 'package:apex_restaurant/featchers/calculation/domain/usecases/edit_calculation_item_usecase.dart.dart';
import 'package:apex_restaurant/featchers/calculation/domain/usecases/open_new_cart_usecase.dart';
import 'package:apex_restaurant/featchers/calculation/domain/usecases/remove_calculation_cart_usecase.dart';
import 'package:apex_restaurant/featchers/calculation/domain/usecases/set_pos_type_usecase.dart';
import 'package:apex_restaurant/featchers/calculation/domain/usecases/voucher_usecases.dart';
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
  final SetCalculationPosTypeUseCase setPosTypeUseCase;
  final SetDiscountOnTotalUseCase setDiscountOnTotalUseCase;
  final AddCalculationVoucherUseCase addVoucherUseCase;
  final RemoveCalculationVoucherUseCase removeVoucherUseCase;
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

  Future<void> _tail = Future.value();
  Future<void> _serial(Future<void> Function() task) {
    final next = _tail.then((_) => task());
    _tail = next.then((_) {}, onError: (_) {});
    return next;
  }

  void _onSerial<E extends CartEvent>(
    Future<void> Function(E, Emitter<CartState>) handler,
  ) => on<E>((event, emit) => _serial(() => handler(event, emit)));

  String _msg(Object e) => e.toString().replaceFirst('Exception: ', '');
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
    required this.setPosTypeUseCase,
    required this.setDiscountOnTotalUseCase,
    required this.addVoucherUseCase,
    required this.removeVoucherUseCase,
  }) : super(const CartState()) {
    on<OpenNewCartEvent>(_onOpenCalculationCart);
    on<LoadCartDataEvent>(_onLoadCartData);
    on<LoadPersonsData>(_onLoadPersonData);
    on<SyncCartItemsEvent>(_onSyncCartItems);
    on<SelectPersonEvent>(_onSelectPerson);

    _onSerial<AddOrderItemToCartEvent>(_onAddOrderItem);
    _onSerial<UpdateItemQuantityEvent>(_onUpdateItemQuantity);
    _onSerial<RemoveItemEvent>(_onRemoveItem);
    _onSerial<EditCartItemEvent>(_onEditCartItem);
    _onSerial<ChangeOrderTypeEvent>(_onChangeOrderType);
    _onSerial<SelectCartTableEvent>(_onSelectTable);
    _onSerial<UpdateItemsPriceWithCompanyEvent>(_updateItemsPriceForCompanies);
    _onSerial<ClearCartEvent>(_onClearCartEvent);
    _onSerial<ApplyDiscountEvent>(_onApplyDiscount);
    _onSerial<ClearDiscountEvent>(_onClearDiscount);
    _onSerial<ApplyVoucherDiscountEvent>(_onApplyVoucherDiscount);
    _onSerial<ClearVoucherDiscountEvent>(_onClearVoucher);

    _onSerial<SyncRestoredInvoiceEvent>(_onSyncRestoredInvoice);
    on<UpdateSettingsEvent>((event, emit) {
      emit(state.copyWith(settingsModel: event.settings, clearMessage: true));
    });

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
    on<HoldOrderEvent>(_onHoldOrder);
    on<SaveTableOrderEvent>(_saveTableOrder);
    on<GetInvoiceReportEvent>(_onInvoiceReport);
    on<AddPosClientEvent>(_addPosClient);
    on<UpdatePosClientEvent>(_updatePosClient);
    on<LoadDynamicDiscountsEvent>(_onLoadDynamicDiscounts);
    on<ChangeAddressEvent>(_onChangeAddress);
  }

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
    if (event.index < 0 || event.index >= state.items.length) return;
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

    items[event.index] = _withUniqueTransactionIds(
      old.copyWith(
        selectedSize: event.selectedSize,
        addons: event.selectedAddons,
        quantity: quantity,
        availableQuantity: returnQuantity?.toDouble() ?? old.availableQuantity,
        notes: event.notes,
        discount: isReturn ? old.discount : event.discount,
        isPercentageDiscount: isReturn
            ? old.isPercentageDiscount
            : event.isPercentageDiscount,
      ),
      ignoreIndex: event.index,
    );

    emit(state.copyWith(items: items, clearMessage: true));
    await _recalculate(emit);
  }

  Future<void> _updateItemsPriceForCompanies(
    UpdateItemsPriceWithCompanyEvent event,
    Emitter<CartState> emit,
  ) async {
    emit(state.copyWith(status: CartStatus.itemsUpdateing));
    final response = await getMenuItemsByCompanyIdUseCase(
      GetItemsRequest(
        itemIds: state.items.map((i) => i.menuItem.itemId).toList(),
        companyId: state.selectedOrderType == CartOrderType.DELIVERY_COMPANY
            ? state.selectedDeliveryCompany?.id
            : null,
      ),
    );

    final fetched = response.when(
      success: (d) => d.data ?? <RestaurantItem>[],
      failure: (_) => <RestaurantItem>[],
    );

    if (fetched.isEmpty) {
      emit(state.copyWith(status: CartStatus.itemsUpdated));
      return;
    }
    emit(state.copyWith(items: _updatePrices(fetched), clearMessage: true));
    await _recalculate(emit);
  }

  List<OrderItem> _updatePrices(List<RestaurantItem> items) {
    final oldItems = state.items;
    final List<OrderItem> newItems = [];

    final fetchedById = <int, RestaurantItem>{
      for (final item in items) item.itemId: item,
    };

    for (final oldItem in oldItems) {
      final newItem = fetchedById[oldItem.menuItem.itemId];
      if (newItem == null) {
        newItems.add(oldItem);
        continue;
      }

      final selectedSize = newItem.sizes
          .where((size) => size.sizeId == oldItem.selectedSize?.sizeId)
          .firstOrNull;

      newItems.add(
        oldItem.copyWith(
          menuItem: newItem,
          selectedSize: selectedSize ??
              (newItem.sizes.isNotEmpty ? newItem.sizes.first : null),
        ),
      );
    }

    return newItems;
  }

  Future<void> _onSyncRestoredInvoice(
    SyncRestoredInvoiceEvent event,
    Emitter<CartState> emit,
  ) async {
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
    await _discardCalculationCart(emit);
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
        ? state.companiesList
            .where((c) => c.id == data.deliveryCompany?.id)
            .firstOrNull
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
            ? state.deliveryAgents
                    .where((d) => d.id == data.deliveryMan?.id)
                    .firstOrNull ??
                data.deliveryMan
            : null,
        selectedPerson: data.client,
        selectedDeliveryCompany: selectedDeliveryCompany,
        voucherId: data.voucherId,
        voucherData: data.voucherData,
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
        returnInvoiceDiscountShares: data.returnInvoiceDiscountShares,

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

    // Rebuild calculation data for restored invoices so server totals remain authoritative.
    if (data.items.isNotEmpty) {
      await _recalculate(emit);
    }
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

  Future<void> _onAddOrderItem(
    AddOrderItemToCartEvent event,
    Emitter<CartState> emit,
  ) async {
    final items = List<OrderItem>.from(state.items);
    final idx = items.indexWhere(
      (i) =>
          i.menuItem.itemId == event.item.menuItem.itemId &&
          i.selectedSize?.sizeId == event.item.selectedSize?.sizeId &&
          _areAddonsEqual(i.addons, event.item.addons) &&
          i.discount == event.item.discount &&
          i.isPercentageDiscount == event.item.isPercentageDiscount,
    );

    // Same line: merge locally, then rebuild so the server stays identical.
    if (idx >= 0) {
      final cur = items[idx];
      items[idx] = cur.copyWith(quantity: cur.quantity + event.item.quantity);
      emit(state.copyWith(items: items, clearMessage: true));
      await _recalculate(emit);
      return;
    }

    // New line: only send this item (+ its addons) and re-apply the discount.
    emit(state.copyWith(status: CartStatus.itemsUpdateing, clearMessage: true));
    final newItem = _withUniqueTransactionIds(event.item);
    try {
      await _ensureCalculationCart(emit);
      final cartId = state.calculationCartId!;
      final posTypeResult = await setPosTypeUseCase(
        SetPosTypeRequest(
          cartId: cartId,
          posType: state.selectedOrderType.apiValue,
          serviceValue: _calculationServiceValue,
        ),
      );

      CalculationResult? result = posTypeResult.mergeChangedItems(
        state.calculationResult,
      );
      for (final r in state.calculationRequestsFor(
        newItem,
        items.length,
        cartId,
      )) {
        final response = await addCalculationItemUseCase(request: r);
        result = response.mergeChangedItems(result);
      }
      items.add(newItem);
      emit(
        state.copyWith(items: items),
      ); // so the discount rules see the new item
      result = await _applyInvoiceLevel(cartId) ?? result;

      emit(
        state.copyWith(
          calculationResult: result,
          status: CartStatus.itemsUpdated,
          clearMessage: true,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: CartStatus.failure, errorMessage: _msg(e)));
    }
  }

  Future<void> _onUpdateItemQuantity(
    UpdateItemQuantityEvent event,
    Emitter<CartState> emit,
  ) async {
    if (event.index < 0 || event.index >= state.items.length) return;

    final updated = List<OrderItem>.from(state.items);
    final current = updated[event.index];

    if (state.isReturnInvoice == true) {
      final limit = returnLimitFor(current);
      final next = (current.availableQuantity ?? 0).toInt() + event.delta;
      if (limit <= 0 || next < 1 || next > limit) return;
      updated[event.index] = current.copyWith(
        availableQuantity: next.toDouble(),
      );
    } else {
      final next = current.quantity + event.delta;
      if (next <= 0) {
        updated.removeAt(event.index);
      } else {
        updated[event.index] = current.copyWith(quantity: next);
      }
    }

    emit(state.copyWith(items: updated, clearMessage: true));
    await _recalculate(emit);
  }

  Future<void> _onRemoveItem(
    RemoveItemEvent event,
    Emitter<CartState> emit,
  ) async {
    if (event.index < 0 || event.index >= state.items.length) return;
    final updated = List<OrderItem>.from(state.items)..removeAt(event.index);
    emit(state.copyWith(items: updated, clearMessage: true));
    await _recalculate(emit);
  }

  bool _areAddonsEqual(
    List<AdditiveModel> addons1,
    List<AdditiveModel> addons2,
  ) {
    if (addons1.length != addons2.length) return false;
    final left = addons1.map((a) => a.id).toList()..sort();
    final right = addons2.map((a) => a.id).toList()..sort();
    for (var i = 0; i < left.length; i++) {
      if (left[i] != right[i]) return false;
    }
    return true;
  }

  void _onSelectPerson(SelectPersonEvent event, Emitter<CartState> emit) {
    emit(
      state.copyWith(
        selectedPerson: event.person,
        selectedAddress:
            (event.person?.personAddress?.isNotEmpty ?? false)
            ? event.person!.personAddress!.first
            : null,
        clearVoucherDiscountValue: state.selectedPerson != event.person,
        clearMessage: true,
      ),
    );
  }

  Future<void> _onChangeOrderType(
    ChangeOrderTypeEvent event,
    Emitter<CartState> emit,
  ) async {
    if (state.isReturn || state.selectedOrderType == event.orderType) return;
    final oldType = state.selectedOrderType;

    emit(
      state.copyWith(
        selectedOrderType: event.orderType,
        clearVoucherDiscountValue: true,
        clearMessage: true,
      ),
    );

    if (oldType == CartOrderType.DELIVERY_COMPANY ||
        event.orderType == CartOrderType.DELIVERY_COMPANY) {
      add(UpdateItemsPriceWithCompanyEvent()); // reprices, then recalculates
    } else if (state.items.isNotEmpty) {
      await _recalculate(emit); // new pos type => different dynamic discounts
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
        await _discardCalculationCart(emit);
      } catch (e) {
        log('Failed to remove calculation cart: $e');
      }
    }
    emit(
      state.copyWith(
        status: CartStatus.initial,
        returnInvoiceDiscountShares: const {},
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
    if (state.isReturn) return;
    emit(
      state.copyWith(
        restaurantPosDiscountRequest: event.restaurantPosDiscountRequest,
        selectedDiscountType: DiscountTypeEnum.direct,
        clearVoucherDiscountValue: true,
        clearMessage: true,
      ),
    );
    if (!await _syncInvoiceLevel(emit)) {
      emit(state.copyWith(clearRestaurantPosDiscountRequest: true));
    }
  }

  Future<void> _onClearDiscount(
    ClearDiscountEvent event,
    Emitter<CartState> emit,
  ) async {
    if (state.isReturn) return;
    emit(
      state.copyWith(
        clearRestaurantPosDiscountRequest: true,
        discountAmount: 0,
        clearMessage: true,
      ),
    );
    await _syncInvoiceLevel(emit);
  }

  Future<void> _onClearVoucher(
    ClearVoucherDiscountEvent event,
    Emitter<CartState> emit,
  ) async {
    if (state.isReturn) return;
    emit(state.copyWith(clearVoucherDiscountValue: true, clearMessage: true));
    await _syncInvoiceLevel(emit);
  }

  Future<void> _onApplyVoucherDiscount(
    ApplyVoucherDiscountEvent event,
    Emitter<CartState> emit,
  ) async {
    if (state.isReturn) return;
    final response = await checkVoucherUseCase(event.request);

    final voucher = response.when(
      success: (d) => d.result == 1 ? d.data : null,
      failure: (_) => null,
    );
    if (voucher == null) {
      final msg = response.when(
        success: (d) => d.errorMessageAr,
        failure: (e) => e.apiErrorModel.errorMessageAr,
      );
      emit(
        state.copyWith(
          clearVoucherDiscountValue: true,
          status: CartStatus.failure,
          errorMessage: msg,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        selectedDiscountType: DiscountTypeEnum.coupon,
        voucherData: voucher,
        clearRestaurantPosDiscountRequest: true,
        clearMessage: true,
      ),
    );
    if (!await _syncInvoiceLevel(emit)) {
      emit(
        state.copyWith(clearVoucherDiscountValue: true),
      ); // server rejected it
    }
  }

  Future<void> _ensureCalculationCart(Emitter<CartState> emit) async {
    final id = state.calculationCartId;
    if (id != null && id.isNotEmpty) return;
    final cartId = await openNewCalculationCartUseCase(_openCartRequest());
    emit(
      state.copyWith(
        calculationCartId: cartId,
        calculationResult: const CalculationResult(),
      ),
    );
  }
  // ---------------- Preview (customization sheet) ----------------

  Future<String?> openPreviewCart() async {
    try {
      return await openNewCalculationCartUseCase(_openCartRequest());
    } catch (e) {
      log('openPreviewCart failed: $e');
      return null;
    }
  }

  Future<ItemLinePreview?> previewLine(String cartId, OrderItem draft) async {
    try {
      CalculationResult? result = await clearCalculationItemsUseCase(cartId);
      for (final r in state.calculationRequestsFor(draft, 0, cartId)) {
        result = await addCalculationItemUseCase(request: r);
      }
      if (result == null) return null;
      return state.linePreviewFrom(draft, result);
    } catch (e) {
      log('previewLine failed: $e');
      return null; // the sheet falls back to the local calculation
    }
  }

  Future<void> discardPreviewCart(String cartId) async {
    try {
      await removeCalculationCartUseCase(cartId);
    } catch (e) {
      log('discardPreviewCart failed: $e');
    }
  }

  OpenNewCartRequest _openCartRequest() {
    final s = state.settingsModel;
    final discountOn =
        (s?.posRestaurant?.activeDiscount ?? false) ||
        state.mode.ignoresActiveDiscountSetting;
    return OpenNewCartRequest(
      empId: ApiConstants.empId ?? 0,
      companyName: RestaurantConstants.appName,
      priceIncludeVAT: state.mode.priceIncludesVat(state), // same VAT mode
      applyVAT: s?.vat?.vatActive ?? false,
      vatRatio: s?.vat?.vatDefaultValue ?? 0,
      applyTobaccoTax: s?.vat?.toppacoTaxActive ?? false,
      systemApplyDiscount: discountOn,
      userCanAddDiscount: discountOn,
      decimalCount: s?.other?.decimals ?? 2,
    );
  }

  Future<void> _discardCalculationCart(Emitter<CartState> emit) async {
    final id = state.calculationCartId;
    if (id == null || id.isEmpty) return;
    try {
      await removeCalculationCartUseCase(id);
    } catch (e) {
      log('Failed to remove calculation cart: $e');
    }
    emit(
      state.copyWith(clearCalculationCart: true, clearCalculationResult: true),
    );
  }

  double get _calculationServiceValue => state.isDeliveryOrder
      ? (state.settingsModel?.posRestaurant?.deliveryCost ?? 0.0)
      : state.selectedOrderType == CartOrderType.DINE_IN
          ? (state.selectedTable?.serviceRatio ?? 0.0)
          : 0.0;

  /// Voucher if one is applied, otherwise discount-on-total (possibly 0).
  Future<CalculationResult?> _applyInvoiceLevel(String cartId) async {
    final s = state;
    final hadVoucher = (s.calculationResult?.voucherDiscount ?? 0) > 0;

    if (s.mode.allowsVoucher &&
        s.selectedDiscountType == DiscountTypeEnum.coupon &&
        s.voucherData?.voucherCode != null) {
      final v = s.voucherData!;
      final response = await addVoucherUseCase(
        AddVoucherRequest(
          cartId: cartId,
          code: v.voucherCode!,
          discountNatural: v.discountNatural == 1
              ? DiscountNatural.ratio
              : DiscountNatural.value,
          discountValue: v.discountValue ?? 0,
          minimumCharge: v.minimumCharge ?? 0,
          maximumDiscount: v.maximumDiscountValue ?? 0,
        ),
      );
      return response.mergeChangedItems(s.calculationResult);
    }

    CalculationResult? previous = s.calculationResult;
    if (hadVoucher) {
      previous = (await removeVoucherUseCase(cartId))
          .mergeChangedItems(previous);
    }

    final d = s.invoiceDiscountForCalculation;
    final response = await setDiscountOnTotalUseCase(
      SetDiscountOnTotalRequest(
        cartId: cartId,
        discountNatural: d.natural,
        discountValue: d.value,
        isAutoDiscount: d.isAuto,
        minimumCharge: d.min,
        maximumDiscount: d.max,
      ),
    );
    return response.mergeChangedItems(previous);
  }

  /// Full rebuild: pos type -> items (+addons) -> invoice-level discount.
  Future<void> _recalculate(Emitter<CartState> emit) async {
    emit(state.copyWith(status: CartStatus.itemsUpdateing, clearMessage: true));
    try {
      await _ensureCalculationCart(emit);
      final cartId = state.calculationCartId!;
      final items = state.items;
      await setPosTypeUseCase(
        SetPosTypeRequest(
          cartId: cartId,
          posType: state.selectedOrderType.apiValue,
          serviceValue: _calculationServiceValue,
        ),
      );

      CalculationResult? result = await clearCalculationItemsUseCase(cartId);
      for (var i = 0; i < items.length; i++) {
        for (final r in state.calculationRequestsFor(items[i], i, cartId)) {
          final response = await addCalculationItemUseCase(request: r);
          result = response.mergeChangedItems(result);
        }
      }
      if (items.isNotEmpty) {
        final invoiceResult = await _applyInvoiceLevel(cartId);
        result = invoiceResult?.mergeChangedItems(result) ?? result;
      }

      emit(
        state.copyWith(
          calculationResult: result,
          status: CartStatus.itemsUpdated,
          clearMessage: true,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: CartStatus.failure, errorMessage: _msg(e)));
    }
  }

  /// Only the invoice-level discount/voucher changed. Returns false on failure.
  Future<bool> _syncInvoiceLevel(Emitter<CartState> emit) async {
    if (state.items.isEmpty) return true;
    if (state.calculationCartId == null) {
      await _recalculate(emit);
      return state.status != CartStatus.failure;
    }
    emit(state.copyWith(status: CartStatus.itemsUpdateing, clearMessage: true));
    try {
      final result = await _applyInvoiceLevel(state.calculationCartId!);
      emit(
        state.copyWith(
          calculationResult: result?.mergeChangedItems(state.calculationResult) ??
              state.calculationResult,
          status: CartStatus.itemsUpdated,
        ),
      );
      return true;
    } catch (e) {
      emit(state.copyWith(status: CartStatus.failure, errorMessage: _msg(e)));
      return false;
    }
  }

  Future<void> _onSelectTable(
    SelectCartTableEvent event,
    Emitter<CartState> emit,
  ) async {
    emit(state.copyWith(selectedTable: event.table, clearMessage: true));
    if (state.selectedOrderType == CartOrderType.DINE_IN &&
        state.items.isNotEmpty) {
      await _recalculate(emit); // service ratio changed
    }
  }

  /// Gives the item (and its addon groups) ids that exist nowhere else in the
  /// cart. Return invoices keep the server ids untouched.
  OrderItem _withUniqueTransactionIds(OrderItem item, {int? ignoreIndex}) {
    if (state.isReturn) return item;

    final used = <String>{};
    for (var i = 0; i < state.items.length; i++) {
      if (i == ignoreIndex) continue;
      final it = state.items[i];
      used.add(it.transactionId);
      for (final a in it.addons) {
        final t = a.transactionId;
        if (t != null && t.isNotEmpty) used.add(t);
      }
    }

    var parentId = item.transactionId;
    if (parentId.isEmpty || used.contains(parentId)) {
      parentId = TransactionIdGenerator.next(used);
    }
    used.add(parentId);

    final perAddon = <String, String>{}; // addon.id -> tx id (one per group)
    final addons = <AdditiveModel>[];
    for (final a in item.addons) {
      final tx = perAddon.putIfAbsent(a.id, () {
        final old = a.transactionId;
        final id = (old != null && old.isNotEmpty && !used.contains(old))
            ? old
            : TransactionIdGenerator.next(used);
        used.add(id);
        return id;
      });
      addons.add(a.copyWith(transactionId: tx, parentTransactionId: parentId));
    }
    return item.copyWith(transactionId: parentId, addons: addons);
  }
}

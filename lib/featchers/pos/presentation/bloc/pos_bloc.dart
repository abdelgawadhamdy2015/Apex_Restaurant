import 'package:apex_restaurant/featchers/pos/domain/entities/menu_item.dart';
import 'package:apex_restaurant/featchers/pos/domain/usecases/pos_usecases.dart';
import 'package:apex_restaurant/featchers/pos/presentation/bloc/pos_event.dart';
import 'package:apex_restaurant/featchers/pos/presentation/bloc/pos_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PosBloc extends Bloc<PosEvent, PosState> {
  final GetMenuCategoriesUseCase _getMenuCategories;
  final SendToKitchenUseCase _sendToKitchen;
  final SubmitOrderUseCase _submitOrder;
  final GetFloorsUseCase _getFloors;
  final GetTablesUseCase _getTables;
  PosBloc({
    required this._getMenuCategories,
    required this._sendToKitchen,
    required this._submitOrder,
    required this._getFloors,
    required this._getTables,
  }) : super(PosState.initial()) {
    on<LoadFloorsEvent>(_onLoadFloors);
    on<LoadTablesEvent>(_onLoadTables);
    on<LoadMenuEvent>(_onLoadMenu);
    on<SelectCategoryEvent>(_onSelectCategory);
    on<AddItemToOrderEvent>(_onAddItem);
    on<RemoveItemFromOrderEvent>(_onRemoveItem);
    on<IncrementItemEvent>(_onIncrementItem);
    on<DecrementItemEvent>(_onDecrementItem);
    on<SendToKitchenEvent>(_onSendToKitchen);
    on<PayOrderEvent>(_onPayOrder);
    on<CancelOrderEvent>(_onCancelOrder);
    on<ShowToastEvent>(_onShowToast);
    on<DismissToastEvent>(_onDismissToast);
    on<ChangeOrderTypeEvent>(_onChangeOrderType);
    on<SelectTableEvent>(_onSelectTable);
  }

  Future<void> _onLoadFloors(
    LoadFloorsEvent event,
    Emitter<PosState> emit,
  ) async {
    emit(state.copyWith(status: PosStatus.loading));
    try {
      final floors = await _getFloors(
        pageNumber: event.pageNumber,
        pageSize: event.pageSize,
        id: event.id,
        name: event.name,
        branchId: event.branchId,
      );
      emit(state.copyWith(status: PosStatus.loaded, floors: floors));
    } catch (e) {
      emit(
        state.copyWith(
          status: PosStatus.error,
          errorMessage: 'فشل تحميل الطوابق. يرجى المحاولة مرة أخرى.',
        ),
      );
    }
  }

  Future<void> _onLoadTables(
    LoadTablesEvent event,
    Emitter<PosState> emit,
  ) async {
    emit(state.copyWith(status: PosStatus.loading));
    try {
      final tables = await _getTables(
        pageNumber: event.pageNumber,
        pageSize: event.pageSize,
        id: event.id,
        name: event.name,
        floorID: event.floorID,
        forPOS: event.forPOS,
      );
      emit(state.copyWith(status: PosStatus.loaded, tables: tables));
    } catch (e) {
      emit(
        state.copyWith(
          status: PosStatus.error,
          errorMessage: 'فشل تحميل الطوابق. يرجى المحاولة مرة أخرى.',
        ),
      );
    }
  }

  Future<void> _onLoadMenu(LoadMenuEvent event, Emitter<PosState> emit) async {
    emit(state.copyWith(status: PosStatus.loading));
    try {
      final categories = await _getMenuCategories();
      final firstCategory = categories.isNotEmpty ? categories.first : null;
      emit(
        state.copyWith(
          status: PosStatus.loaded,
          categories: categories,
          selectedCategoryId: firstCategory?.id ?? '',
          currentMenuItems: firstCategory?.items ?? [],
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: PosStatus.error,
          errorMessage: 'فشل تحميل القائمة. يرجى المحاولة مرة أخرى.',
        ),
      );
    }
  }

  void _onSelectCategory(SelectCategoryEvent event, Emitter<PosState> emit) {
    final category = state.categories.firstWhere(
      (c) => c.id == event.categoryId,
      orElse: () => state.categories.first,
    );
    emit(
      state.copyWith(
        selectedCategoryId: event.categoryId,
        currentMenuItems: category.items,
      ),
    );
  }

  void _onAddItem(AddItemToOrderEvent event, Emitter<PosState> emit) {
    final existingItems = List<OrderItem>.from(state.currentOrder.items);
    final existingIndex = existingItems.indexWhere(
      (i) => i.menuItem.id == event.item.id,
    );

    if (existingIndex >= 0) {
      existingItems[existingIndex] = existingItems[existingIndex].copyWith(
        quantity: existingItems[existingIndex].quantity + 1,
      );
    } else {
      existingItems.add(OrderItem(menuItem: event.item, quantity: 1));
    }

    emit(
      state.copyWith(
        currentOrder: state.currentOrder.copyWith(items: existingItems),
        toastMessage: 'تمت إضافة "${event.item.name}" إلى الطلب',
      ),
    );
  }

  void _onRemoveItem(RemoveItemFromOrderEvent event, Emitter<PosState> emit) {
    final items = state.currentOrder.items
        .where((i) => i.menuItem.id != event.itemId)
        .toList();
    emit(
      state.copyWith(currentOrder: state.currentOrder.copyWith(items: items)),
    );
  }

  void _onIncrementItem(IncrementItemEvent event, Emitter<PosState> emit) {
    final items = state.currentOrder.items.map((item) {
      if (item.menuItem.id == event.itemId) {
        return item.copyWith(quantity: item.quantity + 1);
      }
      return item;
    }).toList();
    emit(
      state.copyWith(currentOrder: state.currentOrder.copyWith(items: items)),
    );
  }

  void _onDecrementItem(DecrementItemEvent event, Emitter<PosState> emit) {
    final items = state.currentOrder.items
        .map((item) {
          if (item.menuItem.id == event.itemId) {
            if (item.quantity <= 1) return null;
            return item.copyWith(quantity: item.quantity - 1);
          }
          return item;
        })
        .whereType<OrderItem>()
        .toList();
    emit(
      state.copyWith(currentOrder: state.currentOrder.copyWith(items: items)),
    );
  }

  Future<void> _onSendToKitchen(
    SendToKitchenEvent event,
    Emitter<PosState> emit,
  ) async {
    if (state.currentOrder.items.isEmpty) return;
    emit(state.copyWith(status: PosStatus.submitting));
    try {
      await _sendToKitchen(state.currentOrder);
      emit(
        state.copyWith(
          status: PosStatus.loaded,
          isKitchenSent: true,
          toastMessage: 'تم إرسال الطلب للمطبخ بنجاح',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: PosStatus.loaded,
          toastMessage: 'فشل الإرسال. يرجى المحاولة مرة أخرى.',
        ),
      );
    }
  }

  Future<void> _onPayOrder(PayOrderEvent event, Emitter<PosState> emit) async {
    if (state.currentOrder.items.isEmpty) return;
    emit(state.copyWith(status: PosStatus.submitting));
    try {
      await _submitOrder(state.currentOrder);
      emit(
        PosState.initial().copyWith(
          status: PosStatus.loaded,
          categories: state.categories,
          selectedCategoryId: state.selectedCategoryId,
          currentMenuItems: state.currentMenuItems,
          toastMessage: 'تم إتمام الدفع بنجاح',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: PosStatus.loaded,
          toastMessage: 'فشل الدفع. يرجى المحاولة مرة أخرى.',
        ),
      );
    }
  }

  void _onCancelOrder(CancelOrderEvent event, Emitter<PosState> emit) {
    emit(
      state.copyWith(
        currentOrder: const Order(tableId: '12', items: []),
        isKitchenSent: false,
      ),
    );
  }

  void _onShowToast(ShowToastEvent event, Emitter<PosState> emit) {
    emit(state.copyWith(toastMessage: event.message));
  }

  void _onDismissToast(DismissToastEvent event, Emitter<PosState> emit) {
    emit(state.copyWith(clearToast: true));
  }

  void _onChangeOrderType(ChangeOrderTypeEvent event, Emitter<PosState> emit) {
    emit(state.copyWith(orderType: event.type));
  }

  void _onSelectTable(SelectTableEvent event, Emitter<PosState> emit) {
    emit(state.copyWith(selectedTable: event.table));
  }
}

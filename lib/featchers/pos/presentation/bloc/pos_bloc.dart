import 'dart:developer';

import 'package:apex_restaurant/core/service/api_error_handler.dart';
import 'package:apex_restaurant/core/service/api_result.dart';
import 'package:apex_restaurant/featchers/pos/domain/entities/menu_item.dart';
import 'package:apex_restaurant/featchers/pos/domain/usecases/pos_usecases.dart';
import 'package:apex_restaurant/featchers/pos/domain/entities/get_items_request_model.dart';
import 'package:apex_restaurant/featchers/pos/presentation/bloc/pos_event.dart';
import 'package:apex_restaurant/featchers/pos/presentation/bloc/pos_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PosBloc extends Bloc<PosEvent, PosState> {
  final GetMenuCategoriesUseCase _getMenuCategories;
  final SendToKitchenUseCase _sendToKitchen;
  final SubmitOrderUseCase _submitOrder;
  final GetFloorsUseCase _getFloors;
  final GetTablesUseCase _getTables;
  final GetMenuItemsByCategoryUseCase _itemsByCategoryUseCase;
  final GetFoodAdditivesUseCase _getfoodAdditivesUseCase;
  final GetAllDeliveryCompanyUseCase _getAllDeliveryCompanyUseCase;
  PosBloc({
    required this._getMenuCategories,
    required this._sendToKitchen,
    required this._submitOrder,
    required this._getFloors,
    required this._getTables,
    required this._itemsByCategoryUseCase,
    required this._getfoodAdditivesUseCase,
    required this._getAllDeliveryCompanyUseCase,
  }) : super(PosState.initial()) {
    on<LoadFloorsEvent>(_onLoadFloors);
    on<LoadTablesEvent>(_onLoadTables);
    on<LoadCategoriesEvent>(_onLoadCategories);
    on<SelectCategoryEvent>(_onSelectCategory);

    on<LoadItemsEvent>(_onLoadItems);
    on<LoadFoodAdditivesEvent>(_onLoadFoodAdditives);
    on<LoadDeliveryCompaniesEvent>(_onLoadDeliveryCompanies);
    on<SelectDeliveryCompanyEvent>(_onSelectDeliveryCompany);

    on<UpdateItemAddonsEvent>(_onUpdateItemAddons);
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
      final response = await _getFloors(request: event.request);
      response.when(
        success: (data) {
          if (data.result == 1) {
            emit(state.copyWith(status: PosStatus.loaded, floors: data.data));
          } else {
            emit(state.copyWith(status: PosStatus.error, apiResponse: data));
          }
        },
        failure: (errorHandler) => emit(
          state.copyWith(
            status: PosStatus.error,
            errorMessage: errorHandler.apiErrorModel.errorMessageAr,
          ),
        ),
      );
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
      final response = await _getTables(request: event.request);
      response.when(
        success: (data) {
          log("${data.data?.length}");
          if (data.result == 1) {
            emit(state.copyWith(status: PosStatus.loaded, tables: data.data));
          } else {
            emit(state.copyWith(status: PosStatus.error, apiResponse: data));
          }
        },

        failure: (errorHandler) {
          log(errorHandler.apiErrorModel.errorMessageAr.toString());
          emit(
            state.copyWith(
              status: PosStatus.error,
              errorMessage: errorHandler.apiErrorModel.errorMessageAr,
            ),
          );
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: PosStatus.error,
          errorMessage: 'فشل تحميل الطوابق. يرجى المحاولة مرة أخرى.',
        ),
      );
    }
  }

  Future<void> _onLoadDeliveryCompanies(
    LoadDeliveryCompaniesEvent event,
    Emitter<PosState> emit,
  ) async {
    emit(state.copyWith(status: PosStatus.loading));
    try {
      final response = await _getAllDeliveryCompanyUseCase(
        request: event.request,
      );
      response.when(
        success: (data) {
          if (data.result == 1) {
            emit(
              state.copyWith(
                status: PosStatus.loaded,
                deliveryCompanies: data.data,
              ),
            );
          } else {
            emit(state.copyWith(status: PosStatus.error, apiResponse: data));
          }
        },
        failure: (errorHandler) {
          emit(
            state.copyWith(
              status: PosStatus.error,
              errorMessage: errorHandler.apiErrorModel.errorMessageAr,
            ),
          );
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: PosStatus.error,
          errorMessage: ErrorHandler.handle(e).apiErrorModel.errorMessageAr,
        ),
      );
    }
  }

  Future<void> _onLoadCategories(
    LoadCategoriesEvent event,
    Emitter<PosState> emit,
  ) async {
    emit(state.copyWith(status: PosStatus.loading));

    try {
      final response = await _getMenuCategories();

      response.when(
        success: (data) {
          final firstCategory = data.data!.isNotEmpty ? data.data!.first : null;
          if (data.result == 1) {
            emit(
              state.copyWith(
                status: PosStatus.loaded,
                categories: data.data,
                selectedCategory: firstCategory,
              ),
            );
          } else {
            emit(state.copyWith(status: PosStatus.error, apiResponse: data));
          }

          if (firstCategory != null) {
            add(
              LoadItemsEvent(
                GetItemsRequestModel(
                  categoryId: firstCategory.id,
                  pageNumber: 1,
                  pageSize: 50,
                ),
              ),
            );
          }
        },
        failure: (errorHandeler) => emit(
          state.copyWith(
            status: PosStatus.error,
            errorMessage: errorHandeler.apiErrorModel.errorMessageAr,
          ),
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

  Future<void> _onLoadFoodAdditives(
    LoadFoodAdditivesEvent event,
    Emitter<PosState> emit,
  ) async {
    emit(state.copyWith(status: PosStatus.loading));

    try {
      final response = await _getfoodAdditivesUseCase(event.requestModel);
      response.when(
        success: (data) {
          if (data.result == 1) {
            emit(
              state.copyWith(status: PosStatus.loaded, additives: data.data),
            );
          } else {
            emit(state.copyWith(status: PosStatus.error, apiResponse: data));
          }
        },
        failure: (errorHandler) {
          emit(
            state.copyWith(
              status: PosStatus.error,
              errorMessage: errorHandler.apiErrorModel.errorMessageAr,
            ),
          );
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: PosStatus.error,
          errorMessage: ErrorHandler.handle(e).apiErrorModel.errorMessageAr,
        ),
      );
    }
  }

  Future<void> _onLoadItems(
    LoadItemsEvent event,
    Emitter<PosState> emit,
  ) async {
    emit(state.copyWith(status: PosStatus.loading));
    try {
      final response = await _itemsByCategoryUseCase(event.requestModel);
      response.when(
        success: (data) {
          if (data.result == 1) {
            emit(
              state.copyWith(
                status: PosStatus.loaded,
                currentMenuItems: data.data,
              ),
            );
          } else {
            emit(state.copyWith(status: PosStatus.error, apiResponse: data));
          }
        },
        failure: (errorHandler) => emit(
          state.copyWith(
            status: PosStatus.error,
            errorMessage: errorHandler.apiErrorModel.errorMessageAr,
          ),
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
    emit(state.copyWith(selectedCategory: event.category));

    add(
      LoadItemsEvent(
        GetItemsRequestModel(
          categoryId: event.category.id,
          pageNumber: 1,
          pageSize: 50,
        ),
      ),
    );
  }

  void _onUpdateItemAddons(
    UpdateItemAddonsEvent event,
    Emitter<PosState> emit,
  ) {
    final updatedItems = state.currentOrder.items.map((item) {
      if (item.menuItem.itemId == event.item.menuItem.itemId) {
        return item.copyWith(addons: event.addons);
      }
      return item;
    }).toList();

    emit(
      state.copyWith(
        currentOrder: state.currentOrder.copyWith(items: updatedItems),
      ),
    );
  }

  void _onAddItem(AddItemToOrderEvent event, Emitter<PosState> emit) {
    final existingItems = List<OrderItem>.from(state.currentOrder.items);
    final existingIndex = existingItems.indexWhere(
      (i) => i.menuItem.itemId == event.item.itemId,
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
        toastMessage: 'تمت إضافة "${event.item.itemNameAr}" إلى الطلب',
      ),
    );
  }

  void _onRemoveItem(RemoveItemFromOrderEvent event, Emitter<PosState> emit) {
    final items = state.currentOrder.items
        .where((i) => i.menuItem.itemId != int.parse(event.itemId))
        .toList();
    emit(
      state.copyWith(currentOrder: state.currentOrder.copyWith(items: items)),
    );
  }

  void _onIncrementItem(IncrementItemEvent event, Emitter<PosState> emit) {
    final items = state.currentOrder.items.map((item) {
      if (item.menuItem.itemId == event.itemId) {
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
          if (item.menuItem.itemId == event.itemId) {
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
          selectedCategory: state.selectedCategory,
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

  void _onSelectDeliveryCompany(
    SelectDeliveryCompanyEvent event,
    Emitter<PosState> emit,
  ) {
    emit(state.copyWith(selectedDeliveryCompany: event.deliveryCompanyModel));
    log(event.deliveryCompanyModel.arabicName.toString());
  }
}

import 'dart:developer';

import 'package:apex_restaurant/core/helpers/helper_methods.dart';
import 'package:apex_restaurant/core/service/api_error_handler.dart';
import 'package:apex_restaurant/core/service/api_result.dart';
import 'package:apex_restaurant/featchers/pos/domain/entities/get_items_request_model.dart';
import 'package:apex_restaurant/featchers/pos/domain/entities/menu_item.dart';
import 'package:apex_restaurant/featchers/pos/domain/usecases/pos_usecases.dart';
import 'package:apex_restaurant/featchers/pos/presentation/bloc/pos_event.dart';
import 'package:apex_restaurant/featchers/pos/presentation/bloc/pos_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PosBloc extends Bloc<PosEvent, PosState> {
  final GetSettingsUseCase _getSettingsUseCase;
  final GetMenuCategoriesUseCase _getMenuCategories;
  final GetMenuItemsByCategoryUseCase _itemsByCategoryUseCase;
  final GetFoodAdditivesUseCase _getfoodAdditivesUseCase;

  PosBloc({
    required this._getMenuCategories,
    required this._itemsByCategoryUseCase,
    required this._getfoodAdditivesUseCase,
    required this._getSettingsUseCase,
  }) : super(PosState.initial()) {
    on<LoadSettingsEvent>(_onLoadSettings);
    on<LoadCategoriesEvent>(_onLoadCategories);
    on<SelectCategoryEvent>(_onSelectCategory);

    on<LoadItemsEvent>(_onLoadItems);
    on<LoadFoodAdditivesEvent>(_onLoadFoodAdditives);

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
    on<SelectTableEvent>(_onSelectTable);
  }

  Future<void> _onLoadSettings(
    LoadSettingsEvent event,
    Emitter<PosState> emit,
  ) async {
    emit(state.copyWith(status: PosStatus.loading));
    try {
      final response = await _getSettingsUseCase();
      response.when(
        success: (data) {
          if (data.result == 1) {
            emit(state.copyWith(status: PosStatus.loaded, settings: data.data));
          } else {
            emit(
              state.copyWith(
                status: PosStatus.error,
                apiResponse: data,
                errorMessage: data.errorMessageAr ?? 'فشل في تحميل المنتجات',
              ),
            );
          }
        },
        failure: (errorHandler) {
          emit(
            state.copyWith(
              status: PosStatus.error,
              errorMessage:
                  errorHandler.apiErrorModel.errorMessageAr ??
                  'خطأ في الاتصال بالخادم',
            ),
          );
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: PosStatus.error,
          errorMessage:
              ErrorHandler.handle(e).apiErrorModel.errorMessageAr ??
              'حدث خطأ غير متوقع عند تحميل المنتجات',
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
          if (data.result == 1) {
            final categoriesList = data.data ?? [];
            final firstCategory = categoriesList.isNotEmpty
                ? categoriesList.first
                : null;

            emit(
              state.copyWith(
                status: PosStatus.loaded,
                categories: categoriesList,
                selectedCategory: firstCategory,
              ),
            );

            if (firstCategory != null) {
              add(SelectCategoryEvent(firstCategory));
              add(
                LoadItemsEvent(GetItemsRequest(categoryId: firstCategory.id)),
              );
            }
          } else {
            emit(
              state.copyWith(
                status: PosStatus.error,
                apiResponse: data,
                errorMessage: data.errorMessageAr ?? 'فشل في تحميل الأقسام',
              ),
            );
          }
        },
        failure: (errorHandler) {
          emit(
            state.copyWith(
              status: PosStatus.error,
              errorMessage:
                  errorHandler.apiErrorModel.errorMessageAr ??
                  'خطأ في الاتصال بالخادم',
            ),
          );
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: PosStatus.error,
          errorMessage:
              ErrorHandler.handle(e).apiErrorModel.errorMessageAr ??
              'حدث خطأ غير متوقع عند تحميل الأقسام',
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
            log("Food Additives Loaded: ${data.data?.length ?? 0}");
            emit(
              state.copyWith(
                status: PosStatus.loaded,
                additives: data.data ?? [],
              ),
            );
          } else {
            emit(
              state.copyWith(
                status: PosStatus.error,
                apiResponse: data,
                errorMessage: data.errorMessageAr ?? 'فشل في تحميل الإضافات',
              ),
            );
          }
        },
        failure: (errorHandler) {
          log(
            "errorHandler: ${errorHandler.apiErrorModel.errorMessageAr ?? 0}",
          );

          emit(
            state.copyWith(
              status: PosStatus.error,
              errorMessage:
                  errorHandler.apiErrorModel.errorMessageAr ??
                  'خطأ في الاتصال بالخادم',
            ),
          );
        },
      );
    } catch (e) {
      log("error: ${e.toString()}");
      emit(
        state.copyWith(
          status: PosStatus.error,
          errorMessage:
              ErrorHandler.handle(e).apiErrorModel.errorMessageAr ??
              'حدث خطأ غير متوقع عند تحميل الإضافات',
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
                currentMenuItems: data.data ?? [],
              ),
            );
          } else {
            emit(
              state.copyWith(
                status: PosStatus.error,
                apiResponse: data,
                errorMessage: data.errorMessageAr ?? 'فشل في تحميل المنتجات',
              ),
            );
          }
        },
        failure: (errorHandler) {
          emit(
            state.copyWith(
              status: PosStatus.error,
              errorMessage:
                  errorHandler.apiErrorModel.errorMessageAr ??
                  'خطأ في الاتصال بالخادم',
            ),
          );
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: PosStatus.error,
          errorMessage:
              ErrorHandler.handle(e).apiErrorModel.errorMessageAr ??
              'حدث خطأ غير متوقع عند تحميل المنتجات',
        ),
      );
    }
  }

  void _onSelectCategory(SelectCategoryEvent event, Emitter<PosState> emit) {
    log(
      "Selected Category: ${event.category.arabicName} (ID: ${event.category.id})",
    );
    emit(
      state.copyWith(
        selectedCategory: event.category,
        additives: event.category.additives,
        currentMenuItems: const [],
      ),
    );

    add(
      LoadItemsEvent(
        GetItemsRequest(
          categoryId: event.category.id == 0 ? null : event.category.id,
        ),
      ),
    );
  }

  void _onUpdateItemAddons(
    UpdateItemAddonsEvent event,
    Emitter<PosState> emit,
  ) {
    try {
      final currentItems = List<OrderItem>.from(state.currentOrder.items);

      // 1. Find the target item index to update
      final targetIndex = currentItems.indexWhere(
        (item) => item.menuItem.itemId == event.item.menuItem.itemId,
      );

      if (targetIndex == -1) return;

      // 2. Create the updated item with the new addons
      final updatedItem = currentItems[targetIndex].copyWith(
        addons: event.addons,
      );

      // 3. Remove the target item temporarily from the list to check for existing duplicates
      currentItems.removeAt(targetIndex);

      // 4. Look for an existing item that matches itemId, size, AND the new addons
      final duplicateIndex = currentItems.indexWhere(
        (i) =>
            i.menuItem.itemId == updatedItem.menuItem.itemId &&
            i.selectedSize?.sizeId == updatedItem.selectedSize?.sizeId &&
            _areAddonsEqual(i.addons, updatedItem.addons),
      );

      if (duplicateIndex >= 0) {
        // Match found: Merge quantity into the existing matching item
        currentItems[duplicateIndex] = currentItems[duplicateIndex].copyWith(
          quantity:
              currentItems[duplicateIndex].quantity + updatedItem.quantity,
        );
      } else {
        // No match found: Re-insert the updated item at its original position
        currentItems.insert(targetIndex, updatedItem);
      }

      emit(
        state.copyWith(
          currentOrder: state.currentOrder.copyWith(items: currentItems),
        ),
      );
    } catch (e) {
      emit(state.copyWith(errorMessage: 'فشل في تحديث الإضافات'));
    }
  }

  void _onAddItem(AddItemToOrderEvent event, Emitter<PosState> emit) {
    try {
      final existingItems = List<OrderItem>.from(state.currentOrder.items);

      final exactMatchIndex = existingItems.indexWhere(
        (i) =>
            i.menuItem.itemId == event.item.menuItem.itemId &&
            i.selectedSize?.sizeId == event.item.selectedSize?.sizeId &&
            _areAddonsEqual(i.addons, event.item.addons),
      );

      if (exactMatchIndex >= 0) {
        existingItems[exactMatchIndex] = existingItems[exactMatchIndex]
            .copyWith(
              quantity:
                  existingItems[exactMatchIndex].quantity + event.item.quantity,
            );
      } else {
        // 2. Look for a partial match (Same Item ID & Same Size, but different/new addons)
        final partialMatchIndex = existingItems.indexWhere(
          (i) =>
              i.menuItem.itemId == event.item.menuItem.itemId &&
              i.selectedSize?.sizeId == event.item.selectedSize?.sizeId,
        );

        if (partialMatchIndex >= 0) {
          // Merge unique addons from both items
          final mergedAddons = HelperMethods.mergeAddons(
            existingItems[partialMatchIndex].addons,
            event.item.addons,
          );

          // Update existing item with merged addons and increased quantity
          existingItems[partialMatchIndex] = existingItems[partialMatchIndex]
              .copyWith(
                quantity:
                    existingItems[partialMatchIndex].quantity +
                    event.item.quantity,
                addons: mergedAddons,
              );
        } else {
          // 3. Completely new item/variant: Add as a new entry
          existingItems.add(event.item);
        }
      }

      emit(
        state.copyWith(
          currentOrder: state.currentOrder.copyWith(items: existingItems),
          toastMessage:
              'تمت إضافة "${event.item.menuItem.itemNameAr}" إلى الطلب',
        ),
      );
    } catch (e) {
      emit(state.copyWith(errorMessage: 'فشل في إضافة العنصر إلى السلة'));
    }
  }

  bool _areAddonsEqual(List addons1, List addons2) {
    if (addons1.length != addons2.length) return false;
    for (int i = 0; i < addons1.length; i++) {
      if (addons1[i] != addons2[i]) return false;
    }
    return true;
  }

  void _onRemoveItem(RemoveItemFromOrderEvent event, Emitter<PosState> emit) {
    try {
      final targetId = int.tryParse(event.itemId);
      final items = state.currentOrder.items
          .where((i) => i.menuItem.itemId != targetId)
          .toList();

      emit(
        state.copyWith(currentOrder: state.currentOrder.copyWith(items: items)),
      );
    } catch (e) {
      emit(state.copyWith(errorMessage: 'فشل في حذف العنصر من السلة'));
    }
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

  void _onSendToKitchen(SendToKitchenEvent event, Emitter<PosState> emit) {
    emit(state.copyWith(isKitchenSent: true));
  }

  void _onPayOrder(PayOrderEvent event, Emitter<PosState> emit) {
    // Standard pay order handler logic
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

  void _onSelectTable(SelectTableEvent event, Emitter<PosState> emit) {
    emit(state.copyWith(selectedTable: event.table));
  }
}

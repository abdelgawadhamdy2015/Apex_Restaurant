import 'dart:developer';

import '../../../../core/service/api_error_handler.dart';
import '../../../../core/service/api_result.dart';
import '../../data/models/restaurant_item.dart';
import '../../domain/entities/get_items_request_model.dart';
import '../../domain/usecases/pos_usecases.dart';
import 'pos_event.dart';
import 'pos_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PosBloc extends Bloc<PosEvent, PosState> {
  final GetSettingsUseCase _getSettingsUseCase;
  final GetMenuCategoriesUseCase _getMenuCategories;
  final GetMenuItemsByCategoryUseCase _itemsByCategoryUseCase;
  final GetFoodAdditivesUseCase _getfoodAdditivesUseCase;
  final CloseRestaurantPosSessionUseCase _closeRestaurantPosSessionUseCase;
  final CurrentRestaurantPosSessionUseCase _currentRestaurantPosSessionUseCase;

  /// Number of items fetched per page for the menu grid (mobile & tablet).
  static const int _itemsPageSize = 20;

  PosBloc({
    required this._getMenuCategories,
    required this._itemsByCategoryUseCase,
    required this._getfoodAdditivesUseCase,
    required this._getSettingsUseCase,
    required this._closeRestaurantPosSessionUseCase,
    required this._currentRestaurantPosSessionUseCase,
  }) : super(PosState.initial()) {
    on<LoadSettingsEvent>(_onLoadSettings);
    on<LoadCategoriesEvent>(_onLoadCategories);
    on<SelectCategoryEvent>(_onSelectCategory);

    on<LoadItemsEvent>(_onLoadItems);
    on<LoadMoreItemsEvent>(_onLoadMoreItems);
    on<LoadFoodAdditivesEvent>(_onLoadFoodAdditives);

    //on<UpdateItemAddonsEvent>(_onUpdateItemAddons);
    // on<AddItemToOrderEvent>(_onAddItem);
    // on<RemoveItemFromOrderEvent>(_onRemoveItem);
    // on<IncrementItemEvent>(_onIncrementItem);
    // on<DecrementItemEvent>(_onDecrementItem);
    // on<SendToKitchenEvent>(_onSendToKitchen);
    // on<PayOrderEvent>(_onPayOrder);
    on<ShowToastEvent>(_onShowToast);
    on<DismissToastEvent>(_onDismissToast);
    on<SelectTableEvent>(_onSelectTable);

    //  Session Handler
    on<CurrentRestaurantPosSessionEvent>(_getCurrentSession);
    on<CloseRestaurantPosSessionEvent>(_onCloseSession);
  }
  Future<void> _getCurrentSession(
    CurrentRestaurantPosSessionEvent event,
    Emitter<PosState> emit,
  ) async {
    emit(state.copyWith(status: PosStatus.loading));

    try {
      final response = await _currentRestaurantPosSessionUseCase();

      response.when(
        success: (data) {
          if (data.result == 1) {
            emit(
              state.copyWith(
                status: PosStatus.closeSession, // أو حالة نجاح مخصصة عند الرغبة
                currentSessionId: data.id,
                clear: true,
              ),
            );
          } else {
            emit(
              state.copyWith(
                status: PosStatus.error,
                apiResponse: data,
                errorMessage:
                    data.errorMessageAr ?? data.note ?? 'فشل في إغلاق الجلسة',
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
                  'خطأ في الاتصال بالخادم عند إغلاق الجلسة',
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
              'حدث خطأ غير متوقع عند إغلاق الجلسة',
        ),
      );
    }
  }

  Future<void> _onCloseSession(
    CloseRestaurantPosSessionEvent event,
    Emitter<PosState> emit,
  ) async {
    emit(state.copyWith(status: PosStatus.loading));

    try {
      final response = await _closeRestaurantPosSessionUseCase(
        sessionId: event.sessionId,
      );

      response.when(
        success: (data) {
          if (data.result == 1) {
            emit(
              state.copyWith(
                status: PosStatus.loaded, // أو حالة نجاح مخصصة عند الرغبة
                toastMessage: 'تم إغلاق الجلسة بنجاح',
                currentSessionId: null,
                clear: true,
              ),
            );
          } else {
            emit(
              state.copyWith(
                status: PosStatus.error,
                apiResponse: data,
                errorMessage:
                    data.errorMessageAr ?? data.note ?? 'فشل في إغلاق الجلسة',
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
                  'خطأ في الاتصال بالخادم عند إغلاق الجلسة',
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
              'حدث خطأ غير متوقع عند إغلاق الجلسة',
        ),
      );
    }
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
    final isFirstPage = !event.loadMore;

    if (isFirstPage) {
      emit(
        state.copyWith(
          status: PosStatus.loading,
          currentMenuItems: const [],
          itemsPageNumber: 1,
          hasMoreItems: true,
        ),
      );
    } else {
      if (!state.hasMoreItems || state.isLoadingMoreItems) return;
      emit(state.copyWith(isLoadingMoreItems: true));
    }

    final nextPage = isFirstPage ? 1 : state.itemsPageNumber + 1;
    final baseRequest = event.requestModel ?? state.currentItemsRequest;
    final requestWithPaging = GetItemsRequest(
      pageNumber: nextPage,
      pageSize: _itemsPageSize,
      statues: baseRequest?.statues,
      name: baseRequest?.name,
      categoryId: baseRequest?.categoryId,
      companyId: baseRequest?.companyId,
      searchKey: baseRequest?.searchKey,
    );

    try {
      final response = await _itemsByCategoryUseCase(requestWithPaging);
      response.when(
        success: (data) {
          if (data.result == 1) {
            final newItems = data.data ?? [];
            final combinedItems = isFirstPage
                ? newItems
                : [...state.currentMenuItems, ...newItems];

            emit(
              state.copyWith(
                status: PosStatus.loaded,
                currentMenuItems: combinedItems,
                itemsPageNumber: nextPage,
                hasMoreItems: newItems.length >= _itemsPageSize,
                isLoadingMoreItems: false,
                currentItemsRequest: requestWithPaging,
              ),
            );
          } else {
            emit(
              state.copyWith(
                status: PosStatus.error,
                apiResponse: data,
                errorMessage: data.errorMessageAr ?? 'فشل في تحميل المنتجات',
                isLoadingMoreItems: false,
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
              isLoadingMoreItems: false,
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
          isLoadingMoreItems: false,
        ),
      );
    }
  }

  void _onLoadMoreItems(LoadMoreItemsEvent event, Emitter<PosState> emit) {
    add(LoadItemsEvent(state.currentItemsRequest, loadMore: true));
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

  Future<RestaurantItem?> fetchItemDetails({
    required int categoryId,
    required int itemId,
  }) async {
    try {
      final response = await _itemsByCategoryUseCase(
        GetItemsRequest(categoryId: categoryId, itemId: itemId),
      );

      RestaurantItem? result;
      response.when(
        success: (data) {
          final items = data.data ?? [];
          if (items.isNotEmpty) {
            result = items.first;
          }
        },
        failure: (errorHandler) {
          log(
            "fetchItemDetails failure: ${errorHandler.apiErrorModel.errorMessageAr}",
          );
        },
      );
      return result;
    } catch (e, s) {
      log("fetchItemDetails error: $e\n$s");
      return null;
    }
  }

  bool _areAddonsEqual(List addons1, List addons2) {
    if (addons1.length != addons2.length) return false;
    for (int i = 0; i < addons1.length; i++) {
      if (addons1[i] != addons2[i]) return false;
    }
    return true;
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

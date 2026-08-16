import '../../../../core/shared/contracts/errorable_state.dart';
import '../../../../core/shared/model/base_response.dart';
import '../../../../core/shared/model/settings_model.dart';
import '../../data/enums/pos_order_type.dart';
import '../../data/models/category_model.dart';
import '../../data/models/delivery_company.dart';
import '../../data/models/floor_model.dart';
import '../../data/models/restaurant_item.dart';
import '../../domain/entities/get_items_request_model.dart';
import '../../domain/entities/menu_item.dart';
import '../../../tables/data/models/table_model.dart';
import 'package:equatable/equatable.dart';

enum PosStatus { initial, loading, loaded, error, submitting, submitted }

class PosState extends Equatable implements ErrorableState {
  final PosStatus status;
  final SettingsModel? settings;
  @override
  final BaseResponse? apiResponse;
  final List<FloorModel> floors;
  final List<TableModel> tables;
  final List<CategoryModel> categories;
  final CategoryModel? selectedCategory;
  final List<AdditiveModel>? additives;
  final List<DeliveryCompanyModel> deliveryCompanies;
  final DeliveryCompanyModel? selectedDeliveryCompany;

  final List<RestaurantItem> currentMenuItems;
  final OrderItem? selectedOrderItem;

  /// Pagination state for [currentMenuItems].
  final int itemsPageNumber;
  final bool hasMoreItems;
  final bool isLoadingMoreItems;

  /// The filter fields (category/search/etc.) currently applied to the
  /// items grid — reused when requesting the next page via
  /// [LoadMoreItemsEvent].
  final GetItemsRequest? currentItemsRequest;

  final String? errorMessage;
  final String? toastMessage;
  final bool isKitchenSent;
  final PosOrderType orderType;
  final FloorModel? selectedFloor;
  final TableModel? selectedTable;

  // session
  final int? currentSessionId;
  const PosState({
    this.status = PosStatus.initial,
    this.apiResponse,
    this.categories = const [],
    this.deliveryCompanies = const [],
    this.selectedDeliveryCompany,
    this.selectedCategory,
    this.currentMenuItems = const [],
    this.selectedOrderItem,
    this.itemsPageNumber = 1,
    this.hasMoreItems = true,
    this.isLoadingMoreItems = false,
    this.currentItemsRequest,
    this.errorMessage,
    this.toastMessage,
    this.isKitchenSent = false,
    this.orderType = PosOrderType.takeaway,
    this.selectedFloor,
    this.selectedTable,
    this.floors = const [],
    this.tables = const [],
    this.additives,
    this.settings,
    this.currentSessionId,
  });

  // ── ErrorableState contract ──
  @override
  bool get hasError => status == PosStatus.error;

  factory PosState.initial() => PosState();

  PosState copyWith({
    SettingsModel? settings,
    BaseResponse? apiResponse,
    PosStatus? status,
    List<FloorModel>? floors,
    List<TableModel>? tables,
    List<AdditiveModel>? additives,
    List<CategoryModel>? categories,
    List<DeliveryCompanyModel>? deliveryCompanies,
    DeliveryCompanyModel? selectedDeliveryCompany,
    CategoryModel? selectedCategory,
    List<RestaurantItem>? currentMenuItems,
    OrderItem? selectedOrderItem,
    int? itemsPageNumber,
    bool? hasMoreItems,
    bool? isLoadingMoreItems,
    GetItemsRequest? currentItemsRequest,
    String? errorMessage,
    String? toastMessage,
    bool clearToast = false,
    bool? isKitchenSent,
    PosOrderType? orderType,
    TableModel? selectedTable,
    FloorModel? selectedFloor,
    int? currentSessionId,
    bool clear = false,
  }) {
    return PosState(
      settings: settings ?? this.settings,
      apiResponse: apiResponse ?? this.apiResponse,
      status: status ?? this.status,
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      deliveryCompanies: deliveryCompanies ?? this.deliveryCompanies,
      selectedDeliveryCompany:
          selectedDeliveryCompany ?? this.selectedDeliveryCompany,
      currentMenuItems: currentMenuItems ?? this.currentMenuItems,
      selectedOrderItem: selectedOrderItem ?? this.selectedOrderItem,
      itemsPageNumber: itemsPageNumber ?? this.itemsPageNumber,
      hasMoreItems: hasMoreItems ?? this.hasMoreItems,
      isLoadingMoreItems: isLoadingMoreItems ?? this.isLoadingMoreItems,
      currentItemsRequest: currentItemsRequest ?? this.currentItemsRequest,
      errorMessage: errorMessage ?? this.errorMessage,
      toastMessage: clearToast ? null : (toastMessage ?? this.toastMessage),
      isKitchenSent: isKitchenSent ?? this.isKitchenSent,
      orderType: orderType ?? this.orderType,
      selectedTable: selectedTable ?? this.selectedTable,
      selectedFloor: selectedFloor ?? this.selectedFloor,
      floors: floors ?? this.floors,
      tables: tables ?? this.tables,
      additives: additives ?? this.additives,
      currentSessionId: clear
          ? currentSessionId
          : currentSessionId ?? this.currentSessionId,
    );
  }

  @override
  List<Object?> get props => [
    settings,
    apiResponse,
    status,
    categories,
    selectedCategory,
    deliveryCompanies,
    selectedDeliveryCompany,
    currentMenuItems,
    selectedOrderItem,
    itemsPageNumber,
    hasMoreItems,
    isLoadingMoreItems,
    errorMessage,
    toastMessage,
    isKitchenSent,
    orderType,
    selectedTable,
    selectedFloor,
    floors,
    tables,
    currentSessionId,
  ];
}

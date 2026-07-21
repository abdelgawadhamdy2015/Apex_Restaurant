import 'package:apex_restaurant/core/shared/contracts/errorable_state.dart';
import 'package:apex_restaurant/core/shared/model/base_response.dart';
import 'package:apex_restaurant/featchers/pos/data/enums/pos_order_type.dart';
import 'package:apex_restaurant/featchers/pos/data/models/category_model.dart';
import 'package:apex_restaurant/featchers/pos/data/models/delivery_company.dart';
import 'package:apex_restaurant/featchers/pos/data/models/floor_model.dart';
import 'package:apex_restaurant/featchers/pos/data/models/restaurant_item.dart';
import 'package:apex_restaurant/featchers/pos/data/models/table_model.dart';
import 'package:apex_restaurant/featchers/pos/domain/entities/menu_item.dart';
import 'package:equatable/equatable.dart';

enum PosStatus { initial, loading, loaded, error, submitting, submitted }

class PosState extends Equatable implements ErrorableState {
  final PosStatus status;
  @override
  final BaseResponse? apiResponse;
  final List<FloorModel> floors;
  final List<TableModel> tables;
  final List<AdditiveModel> additives;
  final List<CategoryModel> categories;
  final CategoryModel? selectedCategory;

  final List<DeliveryCompanyModel> deliveryCompanies;
  final DeliveryCompanyModel? selectedDeliveryCompany;

  final List<RestaurantItem> currentMenuItems;
  final OrderItem? selectedOrderItem;

  final Order currentOrder;
  final String? errorMessage;
  final String? toastMessage;
  final bool isKitchenSent;
  final PosOrderType orderType;
  final FloorModel? selectedFloor;
  final TableModel? selectedTable;
  const PosState({
    this.status = PosStatus.initial,
    this.apiResponse,
    this.categories = const [],
    this.deliveryCompanies = const [],
    this.selectedDeliveryCompany,
    this.selectedCategory,
    this.currentMenuItems = const [],
    this.selectedOrderItem,
    required this.currentOrder,
    this.errorMessage,
    this.toastMessage,
    this.isKitchenSent = false,
    this.orderType = PosOrderType.takeaway,
    this.selectedFloor,
    this.selectedTable,
    this.floors = const [],
    this.tables = const [],
    this.additives = const [],
  });

  // ── ErrorableState contract ──
  @override
  bool get hasError => status == PosStatus.error;

  factory PosState.initial() => PosState(
    currentOrder: const Order(tableId: '12', items: []),
  );

  PosState copyWith({
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
    Order? currentOrder,
    String? errorMessage,
    String? toastMessage,
    bool clearToast = false,
    bool? isKitchenSent,
    PosOrderType? orderType,
    TableModel? selectedTable,
    FloorModel? selectedFloor,
  }) {
    return PosState(
      apiResponse: apiResponse ?? this.apiResponse,
      status: status ?? this.status,
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      deliveryCompanies: deliveryCompanies ?? this.deliveryCompanies,
      selectedDeliveryCompany:
          selectedDeliveryCompany ?? this.selectedDeliveryCompany,
      currentMenuItems: currentMenuItems ?? this.currentMenuItems,
      selectedOrderItem: selectedOrderItem ?? this.selectedOrderItem,
      currentOrder: currentOrder ?? this.currentOrder,
      errorMessage: errorMessage ?? this.errorMessage,
      toastMessage: clearToast ? null : (toastMessage ?? this.toastMessage),
      isKitchenSent: isKitchenSent ?? this.isKitchenSent,
      orderType: orderType ?? this.orderType,
      selectedTable: selectedTable ?? this.selectedTable,
      selectedFloor: selectedFloor ?? this.selectedFloor,
      floors: floors ?? this.floors,
      tables: tables ?? this.tables,
      additives: additives ?? this.additives,
    );
  }

  @override
  List<Object?> get props => [
    apiResponse,
    status,
    categories,
    selectedCategory,
    deliveryCompanies,
    selectedDeliveryCompany,
    currentMenuItems,
    selectedOrderItem,
    currentOrder,
    errorMessage,
    toastMessage,
    isKitchenSent,
    orderType,
    selectedTable,
    selectedFloor,
    floors,
    tables,
    additives,
  ];
}

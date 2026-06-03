import 'package:apex_restaurant/featchers/pos/data/enums/pos_order_type.dart';
import 'package:apex_restaurant/featchers/pos/data/models/category_model.dart';
import 'package:apex_restaurant/featchers/pos/data/models/floor_model.dart';
import 'package:apex_restaurant/featchers/pos/data/models/menu_item_model.dart';
import 'package:apex_restaurant/featchers/pos/data/models/table_model.dart';
import 'package:apex_restaurant/featchers/pos/domain/entities/menu_item.dart';
import 'package:equatable/equatable.dart';

enum PosStatus { initial, loading, loaded, error, submitting, submitted }

class PosState extends Equatable {
  final PosStatus status;
  final List<FloorModel> floors;
  final List<TableModel> tables;

  final List<CategoryModel> categories;
  final CategoryModel? selectedCategory;
  final List<MenuItemModel> currentMenuItems;
  final Order currentOrder;
  final String? errorMessage;
  final String? toastMessage;
  final bool isKitchenSent;
  final PosOrderType orderType;
  final FloorModel? selectedFloor;
  final TableModel? selectedTable;
  const PosState({
    this.status = PosStatus.initial,
    this.categories = const [],
    this.selectedCategory,
    this.currentMenuItems = const [],
    required this.currentOrder,
    this.errorMessage,
    this.toastMessage,
    this.isKitchenSent = false,
    this.orderType = PosOrderType.takeaway,
    this.selectedFloor,
    this.selectedTable,
    this.floors = const [],
    this.tables = const [],
  });

  factory PosState.initial() => PosState(
    currentOrder: const Order(tableId: '12', items: []),
  );

  PosState copyWith({
    PosStatus? status,
    List<FloorModel>? floors,
    List<TableModel>? tables,
    List<CategoryModel>? categories,
    CategoryModel? selectedCategory,
    List<MenuItemModel>? currentMenuItems,
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
      status: status ?? this.status,
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      currentMenuItems: currentMenuItems ?? this.currentMenuItems,
      currentOrder: currentOrder ?? this.currentOrder,
      errorMessage: errorMessage ?? this.errorMessage,
      toastMessage: clearToast ? null : (toastMessage ?? this.toastMessage),
      isKitchenSent: isKitchenSent ?? this.isKitchenSent,
      orderType: orderType ?? this.orderType,
      selectedTable: selectedTable ?? this.selectedTable,
      selectedFloor: selectedFloor ?? this.selectedFloor,
      floors: floors ?? this.floors,
      tables: tables ?? this.tables,
    );
  }

  @override
  List<Object?> get props => [
    status,
    categories,
    selectedCategory,
    currentMenuItems,
    currentOrder,
    errorMessage,
    toastMessage,
    isKitchenSent,
    orderType,
    selectedTable,
    selectedFloor,
    floors,
    tables,
  ];
}

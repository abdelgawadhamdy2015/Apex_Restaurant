import 'package:apex_restaurant/featchers/pos/data/models/food_additive_model.dart';
import 'package:apex_restaurant/featchers/pos/data/models/menu_item_model.dart';
import 'package:equatable/equatable.dart';

class MenuItem extends Equatable {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String categoryId;
  final bool isAvailable;

  const MenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.categoryId,
    this.isAvailable = true,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    price,
    imageUrl,
    categoryId,
    isAvailable,
  ];
}

class MenuCategory extends Equatable {
  final String id;
  final String name;
  final String icon;
  final List<MenuItem> items;

  const MenuCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.items,
  });

  @override
  List<Object?> get props => [id, name, icon, items];
}

class OrderItem extends Equatable {
  final MenuItemModel menuItem;
  final int quantity;
  final String? notes;
  final List<FoodAdditiveModel> addons;

  const OrderItem({
    required this.menuItem,
    required this.quantity,
    this.notes,
    this.addons = const [],
  });

  double get totalPrice => (menuItem.units?.first.salePrice1 ?? 0) * quantity;

  OrderItem copyWith({
    MenuItemModel? menuItem,
    int? quantity,
    String? notes,
    List<FoodAdditiveModel>? addons,
  }) {
    return OrderItem(
      menuItem: menuItem ?? this.menuItem,
      quantity: quantity ?? this.quantity,
      notes: notes ?? this.notes,
      addons: addons ?? this.addons,
    );
  }

  @override
  List<Object?> get props => [menuItem, quantity, notes, addons];
}

class Order extends Equatable {
  final String tableId;
  final List<OrderItem> items;
  final double taxRate;

  const Order({
    required this.tableId,
    required this.items,
    this.taxRate = 0.15,
  });

  double get subtotal => items.fold(0, (sum, item) => sum + item.totalPrice);
  double get tax => subtotal * taxRate;
  double get total => subtotal + tax;

  Order copyWith({String? tableId, List<OrderItem>? items, double? taxRate}) {
    return Order(
      tableId: tableId ?? this.tableId,
      items: items ?? this.items,
      taxRate: taxRate ?? this.taxRate,
    );
  }

  @override
  List<Object?> get props => [tableId, items, taxRate];
}

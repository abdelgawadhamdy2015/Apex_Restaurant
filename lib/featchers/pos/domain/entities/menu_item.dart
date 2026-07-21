// import 'package:apex_restaurant/featchers/pos/data/models/category_response.dart';
// import 'package:apex_restaurant/featchers/pos/data/models/restaurant_item_response.dart';
// import 'package:equatable/equatable.dart';

// class MenuItem extends Equatable {
//   final String id;
//   final String name;
//   final String description;
//   final double price;
//   final String imageUrl;
//   final String categoryId;
//   final bool isAvailable;

//   const MenuItem({
//     required this.id,
//     required this.name,
//     required this.description,
//     required this.price,
//     required this.imageUrl,
//     required this.categoryId,
//     this.isAvailable = true,
//   });

//   @override
//   List<Object?> get props => [
//     id,
//     name,
//     description,
//     price,
//     imageUrl,
//     categoryId,
//     isAvailable,
//   ];
// }

// class MenuCategory extends Equatable {
//   final String id;
//   final String name;
//   final String icon;
//   final List<MenuItem> items;

//   const MenuCategory({
//     required this.id,
//     required this.name,
//     required this.icon,
//     required this.items,
//   });

//   @override
//   List<Object?> get props => [id, name, icon, items];
// }

// class OrderItem extends Equatable {
//   final RestaurantItemResponse menuItem;
//   final int quantity;
//   final String? notes;
//   final List<AdditiveModel> addons;

//   const OrderItem({
//     required this.menuItem,
//     required this.quantity,
//     this.notes,
//     this.addons = const [],
//   });

//   double get totalPrice => (menuItem.sizes.first.price) * quantity;

//   OrderItem copyWith({
//     RestaurantItemResponse? menuItem,
//     int? quantity,
//     String? notes,
//     List<AdditiveModel>? addons,
//   }) {
//     return OrderItem(
//       menuItem: menuItem ?? this.menuItem,
//       quantity: quantity ?? this.quantity,
//       notes: notes ?? this.notes,
//       addons: addons ?? this.addons,
//     );
//   }

//   @override
//   List<Object?> get props => [menuItem, quantity, notes, addons];
// }

// class Order extends Equatable {
//   final String tableId;
//   final List<OrderItem> items;
//   final double taxRate;

//   const Order({
//     required this.tableId,
//     required this.items,
//     this.taxRate = 0.15,
//   });

//   double get subtotal => items.fold(0, (sum, item) => sum + item.totalPrice);
//   double get tax => subtotal * taxRate;
//   double get total => subtotal + tax;

//   Order copyWith({String? tableId, List<OrderItem>? items, double? taxRate}) {
//     return Order(
//       tableId: tableId ?? this.tableId,
//       items: items ?? this.items,
//       taxRate: taxRate ?? this.taxRate,
//     );
//   }

//   @override
//   List<Object?> get props => [tableId, items, taxRate];
// }
import 'package:apex_restaurant/featchers/pos/data/models/category_model.dart';
import 'package:apex_restaurant/featchers/pos/data/models/restaurant_item.dart';
import 'package:equatable/equatable.dart';

class OrderItem extends Equatable {
  final RestaurantItem menuItem;
  final ItemSize? selectedSize;
  final int quantity;
  final String? notes;
  final List<AdditiveModel> addons;
  final double discount;
  final bool isPercentageDiscount;

  const OrderItem({
    required this.menuItem,
    this.selectedSize,
    required this.quantity,
    this.notes,
    this.addons = const [],
    this.discount = 0.0,
    this.isPercentageDiscount = false,
  });

  /// Alias getter for selectedAddons
  List<AdditiveModel> get selectedAddons => addons;

  /// Base price based on selected size or default item price
  double get unitBasePrice {
    if (selectedSize != null) {
      return selectedSize!.price;
    }
    if (itemHasSizes) {
      return menuItem.sizes.first.price;
    }
    return menuItem.defaultPrice;
  }

  bool get itemHasSizes => menuItem.sizes.isNotEmpty;

  /// Total price of all selected additives/addons per single item
  double get addonsTotalPrice {
    return addons.fold(0.0, (sum, addon) => sum + (addon.price));
  }

  /// Price per single item before applying item-level discount
  double get unitPriceBeforeDiscount => unitBasePrice + addonsTotalPrice;

  /// Calculated discount value per single unit
  double get unitDiscountAmount {
    if (discount <= 0) return 0.0;
    if (isPercentageDiscount) {
      return (unitPriceBeforeDiscount * discount) / 100;
    }
    {
      return discount;
    }
  }

  /// Price per single item after applying discount
  double get unitPrice {
    final netPrice = unitPriceBeforeDiscount - unitDiscountAmount;
    return netPrice > 0 ? netPrice : 0.0;
  }

  /// Final total price for this order item line
  double get totalPrice => unitPrice * quantity;

  OrderItem copyWith({
    RestaurantItem? menuItem,
    ItemSize? selectedSize,
    int? quantity,
    String? notes,
    List<AdditiveModel>? addons,
    double? discount,
    bool? isPercentageDiscount,
  }) {
    return OrderItem(
      menuItem: menuItem ?? this.menuItem,
      selectedSize: selectedSize ?? this.selectedSize,
      quantity: quantity ?? this.quantity,
      notes: notes ?? this.notes,
      addons: addons ?? this.addons,
      discount: discount ?? this.discount,
      isPercentageDiscount: isPercentageDiscount ?? this.isPercentageDiscount,
    );
  }

  @override
  List<Object?> get props => [
    menuItem,
    selectedSize,
    quantity,
    notes,
    addons,
    discount,
    isPercentageDiscount,
  ];
}

class Order extends Equatable {
  final String tableId;
  final List<OrderItem> items;
  final double taxRate;
  final double orderDiscount;
  final bool isOrderDiscountPercentage;

  const Order({
    required this.tableId,
    required this.items,
    this.taxRate = 0.15,
    this.orderDiscount = 0.0,
    this.isOrderDiscountPercentage = false,
  });

  /// Total items count inside the cart
  int get totalItemCount => items.fold(0, (sum, item) => sum + item.quantity);

  /// Subtotal before order-level tax and discounts
  double get subtotal => items.fold(0.0, (sum, item) => sum + item.totalPrice);

  /// Order level discount amount
  double get orderDiscountAmount {
    if (orderDiscount <= 0) return 0.0;
    if (isOrderDiscountPercentage) {
      return (subtotal * orderDiscount) / 100;
    }
    {
      return orderDiscount;
    }
  }

  /// Amount after applying order-level discount
  double get netSubtotal {
    final net = subtotal - orderDiscountAmount;
    return net > 0 ? net : 0.0;
  }

  /// VAT / Tax amount calculated on net subtotal
  double get tax => netSubtotal * taxRate;

  /// Final order total amount payable
  double get total => netSubtotal + tax;

  Order copyWith({
    String? tableId,
    List<OrderItem>? items,
    double? taxRate,
    double? orderDiscount,
    bool? isOrderDiscountPercentage,
  }) {
    return Order(
      tableId: tableId ?? this.tableId,
      items: items ?? this.items,
      taxRate: taxRate ?? this.taxRate,
      orderDiscount: orderDiscount ?? this.orderDiscount,
      isOrderDiscountPercentage:
          isOrderDiscountPercentage ?? this.isOrderDiscountPercentage,
    );
  }

  @override
  List<Object?> get props => [
    tableId,
    items,
    taxRate,
    orderDiscount,
    isOrderDiscountPercentage,
  ];
}

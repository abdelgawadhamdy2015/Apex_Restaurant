import 'package:apex_restaurant/featchers/pos/data/models/category_model.dart';
import 'package:apex_restaurant/featchers/pos/data/models/restaurant_item.dart';
import 'package:equatable/equatable.dart';

class OrderItem extends Equatable {
  final int transactionId;
  final RestaurantItem menuItem;
  final ItemSize? selectedSize;
  final int quantity;
  final String? notes;
  final List<AdditiveModel> addons;
  final double discount;
  final bool isPercentageDiscount;

  const OrderItem({
    required this.transactionId,
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

  /// Total price of all selected additives/addons for this line item.
  /// Independent of `quantity` — addons don't scale with how many
  /// units of the item were ordered.
  double get addonsTotalPrice {
    return addons.fold(0.0, (sum, addon) => sum + (addon.price));
  }

  /// Base price scaled by quantity (addons are NOT included here).
  double get basePriceTotal => unitBasePrice * quantity;

  /// Full line total before discount: quantity-scaled base price + addons.
  double get totalPriceBeforeDiscount => basePriceTotal + addonsTotalPrice;

  /// Discount amount applied on the full line total (not per unit).
  double get discountAmount {
    if (discount <= 0) return 0.0;
    if (isPercentageDiscount) {
      return (totalPriceBeforeDiscount * discount) / 100;
    }
    return discount;
  }

  /// Final total price for this order item line.
  double get totalPrice {
    final net = totalPriceBeforeDiscount - discountAmount;
    return net > 0 ? net : 0.0;
  }

  OrderItem copyWith({
    int? transactionId,
    RestaurantItem? menuItem,
    ItemSize? selectedSize,
    int? quantity,
    String? notes,
    List<AdditiveModel>? addons,
    double? discount,
    bool? isPercentageDiscount,
  }) {
    return OrderItem(
      transactionId: transactionId ?? this.transactionId,
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
    transactionId,
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

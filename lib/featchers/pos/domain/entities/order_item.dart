import '../../data/models/category_model.dart';
import '../../data/models/restaurant_item.dart';
import 'package:equatable/equatable.dart';

class OrderItem extends Equatable {
  final String transactionId;
  final RestaurantItem menuItem;
  final ItemSize? selectedSize;
  final int quantity;
  final String? notes;
  final List<AdditiveModel> addons;
  final double discount;
  final bool isPercentageDiscount;
  final double? availableQuantity;

  final int? invoiceDetailsId;

  const OrderItem({
    required this.transactionId,
    required this.menuItem,
    this.selectedSize,
    required this.quantity,
    this.notes,
    this.addons = const [],
    this.discount = 0.0,
    this.isPercentageDiscount = false,
    this.invoiceDetailsId,
    this.availableQuantity,
  });

  /// Alias getter for selectedAddons.
  List<AdditiveModel> get selectedAddons => addons;

  /// Base price based on selected size or default item price.
  double get unitBasePrice {
    if (selectedSize != null) {
      return selectedSize?.price ?? 0;
    }

    if (itemHasSizes) {
      return menuItem.sizes.first.price ?? 0;
    }

    return menuItem.defaultPrice;
  }

  bool get itemHasSizes => menuItem.sizes.isNotEmpty;

  /// Quantity used for calculating the main item price.
  /// In return invoices, use availableQuantity when applicable.
  double get effectiveQuantity =>
      (invoiceDetailsId != null && invoiceDetailsId! > 0)
      ? availableQuantity ?? quantity.toDouble()
      : quantity.toDouble();

  /// Main item price scaled by quantity.
  /// Addons are excluded.
  double get basePriceTotal => unitBasePrice * effectiveQuantity;

  /// Total price of all selected additives.
  /// Addons are independent of the main item discount.
  double get addonsTotalPrice {
    return addons.fold(0.0, (sum, addon) => sum + addon.price);
  }

  /// Full line total before discount: main item + addons.
  double get totalPriceBeforeDiscount => basePriceTotal + addonsTotalPrice;

  /// Discount amount applied ONLY to the main item.
  double get discountAmount {
    if (discount <= 0) return 0.0;

    if (isPercentageDiscount) {
      final percentage = discount.clamp(0.0, 100.0);
      return basePriceTotal * percentage / 100.0;
    }

    // Fixed discount is applied to the main item line only.
    return discount.clamp(0.0, basePriceTotal);
  }

  /// Final total: discounted main item + full addons price.
  double get totalPrice {
    final mainItemAfterDiscount = basePriceTotal - discountAmount;
    return mainItemAfterDiscount + addonsTotalPrice;
  }

  OrderItem copyWith({
    String? transactionId,
    RestaurantItem? menuItem,
    ItemSize? selectedSize,
    int? quantity,
    String? notes,
    List<AdditiveModel>? addons,
    double? discount,
    bool? isPercentageDiscount,
    int? invoiceDetailsId,
    double? availableQuantity,
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
      invoiceDetailsId: invoiceDetailsId ?? this.invoiceDetailsId,
      availableQuantity: availableQuantity ?? this.availableQuantity,
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
    invoiceDetailsId,
    availableQuantity,
  ];
}

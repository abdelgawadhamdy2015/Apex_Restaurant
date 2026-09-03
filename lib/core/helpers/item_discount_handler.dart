import 'package:apex_restaurant/featchers/cart/presentation/bloc/cart_bloc.dart';
import 'package:apex_restaurant/featchers/pos/data/models/category_model.dart';
import 'package:apex_restaurant/featchers/pos/data/models/restaurant_item.dart';
import 'package:apex_restaurant/featchers/pos/domain/entities/menu_item.dart';
import 'package:apex_restaurant/featchers/pos/presentation/bloc/pos_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

mixin ItemDiscountHandler<T extends StatefulWidget> on State<T> {
  // Shared state fields
  int quantity = 1;
  int selectedSizeIndex = 0;
  bool isPercentageDiscount = true;
  bool addonsPrefilled = false;

  final Map<int, int> addonQuantities = {};
  final TextEditingController discountController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  RestaurantItem get item;

  @override
  void dispose() {
    discountController.dispose();
    notesController.dispose();
    super.dispose();
  }

  // --- PREFILL LOGIC ---

  /// Prefills fields when editing an existing cart item
  void prefillFromExistingItem(OrderItem? existing) {
    if (existing == null) return;

    final existingSize = existing.selectedSize;
    if (existingSize != null) {
      final idx = item.sizes.indexWhere(
        (s) => s.sizeNameAr == existingSize.sizeNameAr,
      );
      if (idx != -1) selectedSizeIndex = idx;
    }

    quantity = existing.quantity;
    notesController.text = existing.notes ?? '';
    isPercentageDiscount = existing.isPercentageDiscount;

    if (existing.discount != 0) {
      discountController.text = existing.discount.toString();
    }
  }

  /// Prefills addons once when additives are loaded
  void prefillAddonsOnce(List<AdditiveModel> additives, OrderItem? existing) {
    if (addonsPrefilled || additives.isEmpty || existing == null) return;

    addonQuantities.clear();
    for (final addon in existing.addons) {
      final idx = additives.indexWhere((a) => a.arabicName == addon.arabicName);
      if (idx != -1) {
        addonQuantities[idx] = (addonQuantities[idx] ?? 0) + 1;
      }
    }
    addonsPrefilled = true;
  }

  // --- ADDON & CATEGORY HELPERS ---

  /// Retrieves additives for the item's category
  List<AdditiveModel> additivesFor(PosState posState) {
    final matchCat = posState.categories.where(
      (cat) => cat.id == item.categoryId,
    );
    return matchCat.isNotEmpty ? (matchCat.first.additives ?? []) : [];
  }

  /// Converts selected addon quantities map to a flattened list of additives
  List<AdditiveModel> getSelectedAddonsList(List<AdditiveModel> additives) {
    final List<AdditiveModel> selectedList = [];
    addonQuantities.forEach((index, qty) {
      if (index < additives.length) {
        for (int i = 0; i < qty; i++) {
          selectedList.add(additives[index]);
        }
      }
    });
    return selectedList;
  }

  // --- DISCOUNT HELPERS ---

  ItemDiscount? currentSizeDiscount(BuildContext context) {
    if (item.sizes.isEmpty) return null;
    final cartState = context.read<CartBloc>().state;
    return cartState.dynamicDiscountForSize(item.sizes[selectedSizeIndex]);
  }

  void syncDiscountFieldsWithSize(BuildContext context) {
    final discount = currentSizeDiscount(context);
    if (discount != null) {
      isPercentageDiscount = discount.discountNatural == 1;
      discountController.text = formatDiscountValue(discount.discountValue);
    }
  }

  String formatDiscountValue(double value) {
    return value == value.roundToDouble()
        ? value.toInt().toString()
        : value.toString();
  }

  bool calculateIsDiscountEnabled(BuildContext context) {
    final cartState = context.read<CartBloc>().state;
    final discountValue = cartState.restaurantPosDiscountRequest?.value ?? 0;
    final hasDynamicSizeDiscount = currentSizeDiscount(context) != null;
    final invoiceDynamicDiscount = cartState.dynamicDiscountIsActive;
    final invoiceDiscount = cartState.isCustomerDiscountApplied;
    return !hasDynamicSizeDiscount &&
        discountValue <= 0 &&
        !invoiceDynamicDiscount &&
        !invoiceDiscount &&
        !item.isOffer;
  }

  // --- PRICE CALCULATION ---

  double calculateTotalPrice({required List<AdditiveModel> additives}) {
    final basePrice = item.sizes.isNotEmpty
        ? item.sizes[selectedSizeIndex].price ?? 0
        : 0.0;

    double addonsTotal = 0.0;
    addonQuantities.forEach((index, qty) {
      if (index < additives.length) {
        addonsTotal += additives[index].price * qty;
      }
    });

    double itemTotal = (basePrice * quantity) + addonsTotal;
    double discountVal = double.tryParse(discountController.text) ?? 0.0;

    if (isPercentageDiscount) {
      itemTotal = itemTotal * (1 - (discountVal / 100));
    } else {
      itemTotal = (itemTotal - discountVal).clamp(0.0, double.infinity);
    }

    return itemTotal;
  }
}

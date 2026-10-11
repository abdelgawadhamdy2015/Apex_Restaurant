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

  /// Prefills addons once when additives are loaded.
  /// Return invoice: the amount shown is the addon's availableQuantity.
  void prefillAddonsOnce(
    List<AdditiveModel> additives,
    OrderItem? existing, {
    bool isReturn = false,
  }) {
    if (addonsPrefilled || additives.isEmpty || existing == null) return;

    addonQuantities.clear();
    if (isReturn) {
      final handled = <String>{};
      for (final addon in existing.addons) {
        if (!handled.add(addon.arabicName)) continue;
        final idx = additives.indexWhere(
          (a) => a.arabicName == addon.arabicName,
        );
        final qty = (addon.availableQuantity ?? 0).toInt();
        if (idx != -1 && qty > 0) addonQuantities[idx] = qty;
      }
    } else {
      for (final addon in existing.addons) {
        final idx = additives.indexWhere(
          (a) => a.arabicName == addon.arabicName,
        );
        if (idx != -1) {
          addonQuantities[idx] = (addonQuantities[idx] ?? 0) + 1;
        }
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

  /// Converts selected addon quantities map to a flattened list of additives.
  ///
  /// When editing an existing cart item, addons that were already on it are
  /// reused (matched by arabicName) so they keep their invoiceDetailsId,
  /// transactionId and parentTransactionId. Only addons added during the edit
  /// come from the fresh menu [additives].
  List<AdditiveModel> getSelectedAddonsList(
    List<AdditiveModel> additives, {
    OrderItem? existing,
    bool isReturn = false,
  }) {
    // Return invoice: clone the original addon line (keeps invoiceDetailsId
    // and transaction ids) once per selected unit, and store the selected
    // amount in availableQuantity. New addons can't be added to a return.
    if (isReturn && existing != null) {
      final templates = <String, AdditiveModel>{};
      for (final a in existing.addons) {
        templates.putIfAbsent(a.arabicName, () => a);
      }
      final result = <AdditiveModel>[];
      addonQuantities.forEach((index, qty) {
        if (index >= additives.length || qty <= 0) return;
        final template = templates[additives[index].arabicName];
        if (template == null) return;
        for (int i = 0; i < qty; i++) {
          result.add(template.copyWith(availableQuantity: qty.toDouble()));
        }
      });
      return result;
    }

    final existingPool = <String, List<AdditiveModel>>{};
    for (final addon in existing?.addons ?? const <AdditiveModel>[]) {
      existingPool.putIfAbsent(addon.arabicName, () => []).add(addon);
    }

    final List<AdditiveModel> selectedList = [];
    addonQuantities.forEach((index, qty) {
      if (index < additives.length) {
        final menuAddon = additives[index];
        final reusable = existingPool[menuAddon.arabicName];
        for (int i = 0; i < qty; i++) {
          if (reusable != null && reusable.isNotEmpty) {
            selectedList.add(reusable.removeAt(0));
          } else {
            selectedList.add(menuAddon);
          }
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
        cartState.settingsModel?.posRestaurant?.activeDiscount == true &&
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

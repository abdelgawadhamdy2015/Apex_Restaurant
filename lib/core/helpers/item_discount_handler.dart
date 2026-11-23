import 'dart:async';

import 'package:apex_restaurant/featchers/calculation/data/models/item_line_preview.dart';
import 'package:apex_restaurant/featchers/cart/presentation/bloc/cart_bloc.dart';
import 'package:apex_restaurant/featchers/cart/presentation/bloc/cart_state.dart';
import 'package:apex_restaurant/featchers/pos/data/models/category_model.dart';
import 'package:apex_restaurant/featchers/pos/data/models/restaurant_item.dart';
import 'package:apex_restaurant/featchers/pos/domain/entities/order_item.dart';
import 'package:apex_restaurant/featchers/pos/presentation/bloc/pos_state.dart';
import 'package:material_ui/material_ui.dart';
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

  // ---- server preview state ----
  ItemLinePreview? _preview;
  String? _previewKey; // signature the _preview belongs to
  String? _pendingKey;
  OrderItem? _pendingDraft;
  String? _previewCartId;
  CartBloc? _cartBloc;
  Timer? _previewTimer;
  bool _previewRunning = false;
  bool _previewDirty = false;

  /// Latest server numbers (gross / discount / vat) if they are up to date.
  ItemLinePreview? get currentPreview =>
      (_preview != null && _previewKey == _signature()) ? _preview : null;

  @override
  void dispose() {
    _previewTimer?.cancel();
    final id = _previewCartId;
    if (id != null) _cartBloc?.discardPreviewCart(id);
    discountController.dispose();
    notesController.dispose();
    super.dispose();
  }

  // --- PREFILL LOGIC ---

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

  List<AdditiveModel> additivesFor(PosState posState) {
    final matchCat = posState.categories.where(
      (cat) => cat.id == item.categoryId,
    );
    return matchCat.isNotEmpty ? (matchCat.first.additives ?? []) : [];
  }

  List<AdditiveModel> getSelectedAddonsList(
    List<AdditiveModel> additives, {
    OrderItem? existing,
    bool isReturn = false,
  }) {
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
        !cartState.isReturn &&
        cartState.settingsModel?.posRestaurant?.activeDiscount == true &&
        !item.isOffer;
  }

  // --- LOCAL PRICE (fallback while the server answer is not ready) ---

  double calculateTotalPrice({required List<AdditiveModel> additives}) {
    final basePrice = item.sizes.isNotEmpty
        ? item.sizes[selectedSizeIndex].price ?? 0.0
        : 0.0;

    double addonsTotal = 0.0;
    addonQuantities.forEach((index, qty) {
      if (index < additives.length) {
        addonsTotal += additives[index].price * qty;
      }
    });

    final mainItemTotal = basePrice * quantity;
    final discountVal = double.tryParse(discountController.text) ?? 0.0;

    double discountedMainItem;
    if (isPercentageDiscount) {
      final percentage = discountVal.clamp(0.0, 100.0);
      discountedMainItem = mainItemTotal * (1 - percentage / 100);
    } else {
      discountedMainItem = (mainItemTotal - discountVal).clamp(
        0.0,
        double.infinity,
      );
    }
    return discountedMainItem + addonsTotal;
  }

  // --- SERVER PREVIEW ---

  /// What the sheet shows: server value if fresh, local value otherwise.
  double previewTotal(List<AdditiveModel> additives) =>
      currentPreview?.total ?? calculateTotalPrice(additives: additives);

  String _signature() {
    final addons = addonQuantities.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    return [
      item.itemId,
      selectedSizeIndex,
      quantity,
      isPercentageDiscount,
      discountController.text.trim(),
      addons.map((e) => '${e.key}:${e.value}').join(','),
    ].join('|');
  }

  OrderItem _buildDraft(List<AdditiveModel> additives, OrderItem? existing) {
    // Fresh addon objects: no transaction ids of the real cart leak into the
    // preview cart.
    final addons = getSelectedAddonsList(additives, existing: existing)
        .map(
          (a) => AdditiveModel(
            id: a.id,
            arabicName: a.arabicName,
            latinName: a.latinName,
            price: a.price,
          ),
        )
        .toList();

    return OrderItem(
      transactionId: 'preview',
      menuItem: item,
      selectedSize: item.sizes.isNotEmpty
          ? item.sizes[selectedSizeIndex]
          : null,
      quantity: quantity,
      addons: addons,
      discount: double.tryParse(discountController.text) ?? 0.0,
      isPercentageDiscount: isPercentageDiscount,
    );
  }

  /// Call from build(). Starts a (debounced) server calculation whenever an
  /// input changed. Does nothing for return invoices (local calculation).
  void syncPreview(
    List<AdditiveModel> additives, {
    OrderItem? existing,
    bool isReturn = false,
  }) {
    if (isReturn || item.sizes.isEmpty) return;
    final key = _signature();
    if (key == _pendingKey) return;

    _pendingKey = key;
    _pendingDraft = _buildDraft(additives, existing);
    _previewTimer?.cancel();
    _previewTimer = Timer(const Duration(milliseconds: 300), _runPreview);
  }

  Future<void> _runPreview() async {
    if (!mounted) return;
    if (_previewRunning) {
      _previewDirty = true;
      return;
    }
    _previewRunning = true;
    try {
      do {
        _previewDirty = false;
        final draft = _pendingDraft;
        final key = _pendingKey;
        if (draft == null || key == null) break;

        final bloc = _cartBloc ??= context.read<CartBloc>();
        if (_previewCartId == null) {
          final id = await bloc.openPreviewCart();
          if (!mounted) {
            if (id != null) bloc.discardPreviewCart(id);
            return;
          }
          _previewCartId = id;
        }
        final cartId = _previewCartId;
        if (cartId == null) break;

        final result = await bloc.previewLine(cartId, draft);
        if (!mounted) return;
        if (key == _pendingKey) {
          setState(() {
            _preview = result;
            _previewKey = key;
          });
        }
      } while (_previewDirty && mounted);
    } finally {
      _previewRunning = false;
    }
  }
}

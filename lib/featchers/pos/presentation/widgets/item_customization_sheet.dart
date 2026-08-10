import 'dart:developer';

import 'package:apex_restaurant/core/helpers/extensions.dart';
import 'package:apex_restaurant/core/helpers/helper_methods.dart';
import 'package:apex_restaurant/featchers/cart/presentation/bloc/cart_bloc.dart';
import 'package:apex_restaurant/featchers/pos/data/models/category_model.dart';
import 'package:apex_restaurant/featchers/pos/data/models/restaurant_item.dart';
import 'package:apex_restaurant/featchers/pos/domain/entities/menu_item.dart';
import 'package:apex_restaurant/featchers/pos/presentation/bloc/pos_bloc.dart';
import 'package:apex_restaurant/featchers/pos/presentation/bloc/pos_state.dart';
import 'package:apex_restaurant/featchers/pos/presentation/widgets/add_to_cart_bar.dart';
import 'package:apex_restaurant/featchers/pos/presentation/widgets/discount_type_toggle.dart';
import 'package:apex_restaurant/featchers/pos/presentation/widgets/item_addon_tile.dart';
import 'package:apex_restaurant/featchers/pos/presentation/widgets/item_customization_header.dart';
import 'package:apex_restaurant/featchers/pos/presentation/widgets/item_size_selector.dart';
import 'package:apex_restaurant/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ItemCustomizationSheet extends StatefulWidget {
  final RestaurantItem item;

  final PosBloc posBloc;

  final Function(
    RestaurantItem item,
    List<AdditiveModel> additives, {
    required ItemSize selectedSize,
    required List<AdditiveModel> selectedAddons,
    required double discount,
    required bool isPercentageDiscount,
    required String notes,
    required int quantity,
  })
  onConfirm;

  final OrderItem? existingItem;
  final int? cartIndex;

  const ItemCustomizationSheet({
    super.key,
    required this.item,
    required this.posBloc,
    required this.onConfirm,
    this.existingItem,
    this.cartIndex,
  });

  static void show(
    BuildContext context,
    RestaurantItem item,
    PosBloc posBloc,
    final Function(
      RestaurantItem item,
      List<AdditiveModel> additives, {
      required dynamic selectedSize,
      required List<AdditiveModel> selectedAddons,
      required double discount,
      required bool isPercentageDiscount,
      required String notes,
      required int quantity,
    })
    onConfirm, {
    OrderItem? existingItem,
    int? cartIndex,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: ItemCustomizationSheet(
          item: item,
          posBloc: posBloc,
          onConfirm: onConfirm,
          existingItem: existingItem,
          cartIndex: cartIndex,
        ),
      ),
    );
  }

  @override
  State<ItemCustomizationSheet> createState() => _ItemCustomizationSheetState();
}

class _ItemCustomizationSheetState extends State<ItemCustomizationSheet> {
  int _quantity = 1;
  int _selectedSizeIndex = 0;

  final Map<int, int> _addonQuantities = {};

  bool _addonsPrefilled = false;

  bool _isPercentageDiscount = true;
  final TextEditingController _discountController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  bool get _isEditMode => widget.existingItem != null;

  double get _currentBasePrice => widget.item.sizes.isNotEmpty
      ? widget.item.sizes[_selectedSizeIndex].price
      : 0.0;

  double _totalPrice(List<AdditiveModel> additives) {
    double addonsTotal = 0.0;
    _addonQuantities.forEach((index, qty) {
      if (index < additives.length) {
        addonsTotal += additives[index].price * qty;
      }
    });

    // double itemTotal = (_currentBasePrice + addonsTotal) * _quantity;
    double itemTotal = (_currentBasePrice * _quantity) + addonsTotal;

    double discountVal = double.tryParse(_discountController.text) ?? 0.0;
    if (_isPercentageDiscount) {
      itemTotal = itemTotal * (1 - (discountVal / 100));
    } else {
      itemTotal = (itemTotal - discountVal).clamp(0.0, double.infinity);
    }

    return itemTotal;
  }

  List<AdditiveModel> _getSelectedAddonsList(List<AdditiveModel> additives) {
    final List<AdditiveModel> selectedList = [];
    _addonQuantities.forEach((index, qty) {
      if (index < additives.length) {
        for (int i = 0; i < qty; i++) {
          selectedList.add(additives[index]);
        }
      }
    });
    return selectedList;
  }

  /// Every category is already loaded up-front with its own additives
  /// embedded (`CategoryModel.additives`). So resolving an item's
  /// additives is just: find the category this item belongs to, then
  /// read its additives — no API call, and identical no matter which
  /// screen opened the sheet.
  List<AdditiveModel> _additivesFor(PosState posState) {
    log("categoris:  ${posState.categories.length.toString()}");
    final matchCat = posState.categories.where(
      (cat) => cat.id == widget.item.categoryId,
    );
    return matchCat.isNotEmpty ? (matchCat.first.additives ?? []) : [];
  }

  @override
  void initState() {
    super.initState();
    _prefillSizeAndFieldsFromExistingItemIfAny();
  }

  void _prefillSizeAndFieldsFromExistingItemIfAny() {
    final existing = widget.existingItem;
    if (existing == null) return;

    final existingSize = existing.selectedSize;
    if (existingSize != null) {
      final idx = widget.item.sizes.indexWhere(
        (s) => s.sizeNameAr == existingSize.sizeNameAr,
      );
      if (idx != -1) _selectedSizeIndex = idx;
    }

    _quantity = existing.quantity;
    _notesController.text = existing.notes ?? '';

    _isPercentageDiscount = existing.isPercentageDiscount;
    if (existing.discount != 0) {
      _discountController.text = existing.discount.toString();
    }
  }

  void _prefillAddonsOnceIfNeeded(List<AdditiveModel> additives) {
    if (_addonsPrefilled || additives.isEmpty) return;
    final existing = widget.existingItem;
    if (existing != null) {
      _addonQuantities.clear();
      for (final addon in existing.addons) {
        final idx = additives.indexWhere(
          (a) => a.arabicName == addon.arabicName,
        );
        if (idx != -1) {
          _addonQuantities[idx] = (_addonQuantities[idx] ?? 0) + 1;
        }
      }
    }
    _addonsPrefilled = true;
  }

  @override
  void dispose() {
    _discountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final spacing = context.spacing;
    final lang = S.of(context);
    final dyanmicDiscountisActive = context
        .read<CartBloc>()
        .state
        .dynamicDiscountIsActive;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(spacing.radiusPill),
        ),
      ),
      height: MediaQuery.of(context).size.height * 0.9,
      child: BlocBuilder<PosBloc, PosState>(
        bloc: widget.posBloc,
        builder: (context, posState) {
          // Categories (and their additives) haven't finished their
          // very first load yet — this can only happen if the sheet is
          // somehow opened before the app's initial category fetch
          // completes.
          final isLoadingAddons =
              posState.categories.isEmpty &&
              posState.status == PosStatus.loading;

          final List<AdditiveModel> additives = _additivesFor(posState);

          _prefillAddonsOnceIfNeeded(additives);
          final discountValue =
              context.read<CartBloc>().state.saveDiscountModel?.value ?? 0;

          final isRadioEnabled = !dyanmicDiscountisActive && discountValue <= 0;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ItemCustomizationHeader(
                itemNameAr: widget.item.itemNameAr,
                imagePath: widget.item.imagePath,
              ),
              const Divider(height: 1),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.all(spacing.md),
                  children: [
                    Text(
                      lang.productSize,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: spacing.sm),
                    ItemSizeSelector(
                      sizes: widget.item.sizes,
                      selectedIndex: _selectedSizeIndex,
                      onSelected: (index) =>
                          setState(() => _selectedSizeIndex = index),
                    ),
                    SizedBox(height: spacing.xl),
                    Text(
                      lang.addons,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: spacing.xs),
                    if (isLoadingAddons)
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: spacing.lg),
                        child: const Center(child: CircularProgressIndicator()),
                      )
                    else if (additives.isEmpty)
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: spacing.sm),
                        child: Text(
                          'لا توجد إضافات متاحة',
                          style: textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      )
                    else
                      ...List.generate(additives.length, (index) {
                        final addon = additives[index];
                        final currentQty = _addonQuantities[index] ?? 0;

                        return ItemAddonTile(
                          addon: addon,
                          quantity: currentQty,
                          onDecrement: () {
                            setState(() {
                              if (currentQty > 1) {
                                _addonQuantities[index] = currentQty - 1;
                              } else {
                                _addonQuantities.remove(index);
                              }
                            });
                          },
                          onIncrement: () {
                            setState(() {
                              _addonQuantities[index] = currentQty + 1;
                            });
                          },
                        );
                      }),
                    SizedBox(height: spacing.sm),
                    Text(
                      lang.specialNotes,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: spacing.xl),
                    TextField(
                      controller: _notesController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: lang.specialNotesHint,
                        fillColor: theme.colorScheme.surfaceContainerHighest,
                      ),
                    ),
                    SizedBox(height: spacing.xl),
                    Text(
                      lang.specialDiscount,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: spacing.sm),
                    DiscountTypeToggle(
                      enabled: isRadioEnabled,
                      isPercentage: _isPercentageDiscount,
                      onChanged: (value) =>
                          setState(() => _isPercentageDiscount = value),
                    ),
                    SizedBox(height: spacing.sm),
                    TextField(
                      enabled: isRadioEnabled,
                      controller: _discountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: lang.enterDiscountValue,
                        fillColor: theme.colorScheme.onSurface,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: theme.colorScheme.outlineVariant,
                          ),
                        ),
                      ),
                      onChanged: (value) => setState(() {}),
                    ),
                    SizedBox(height: spacing.xl),
                  ],
                ),
              ),
              AddToCartBar(
                quantity: _quantity,
                onIncrement: () => setState(() => _quantity++),
                onDecrement: () {
                  if (_quantity > 1) setState(() => _quantity--);
                },
                totalPrice: _totalPrice(additives),
                onConfirm: () {
                  if (widget.item.sizes.isEmpty ||
                      (widget.item.sizes[_selectedSizeIndex].sizeId <= 0 &&
                          widget.item.sizes.length == 1)) {
                    {
                      HelperMethods.showSnackBar(
                        context: context,
                        message: S.of(context).thisItemHasNoValidSize,
                        isError: true,
                      );
                      return;
                    }
                  }

                  if (widget.item.sizes[_selectedSizeIndex].sizeId <= 0 &&
                      widget.item.sizes.length > 1) {
                    {
                      HelperMethods.showSnackBar(
                        context: context,
                        message: S.of(context).pleaseSelectValidSize,
                        isError: true,
                      );
                      return;
                    }
                  }
                  Navigator.pop(context);
                  widget.onConfirm(
                    widget.item,
                    additives,
                    selectedSize: widget.item.sizes[_selectedSizeIndex],
                    selectedAddons: _getSelectedAddonsList(additives),
                    discount: double.tryParse(_discountController.text) ?? 0.0,
                    isPercentageDiscount: _isPercentageDiscount,
                    notes: _notesController.text,
                    quantity: _quantity,
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

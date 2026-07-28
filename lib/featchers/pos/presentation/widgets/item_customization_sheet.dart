import 'package:apex_restaurant/core/helpers/extensions.dart';
import 'package:apex_restaurant/featchers/pos/data/models/category_model.dart';
import 'package:apex_restaurant/featchers/pos/data/models/restaurant_item.dart';
import 'package:apex_restaurant/featchers/pos/presentation/widgets/add_to_cart_bar.dart';
import 'package:apex_restaurant/featchers/pos/presentation/widgets/discount_type_toggle.dart';
import 'package:apex_restaurant/featchers/pos/presentation/widgets/item_addon_tile.dart';
import 'package:apex_restaurant/featchers/pos/presentation/widgets/item_customization_header.dart';
import 'package:apex_restaurant/featchers/pos/presentation/widgets/item_size_selector.dart';
import 'package:apex_restaurant/generated/l10n.dart';
import 'package:flutter/material.dart';

class ItemCustomizationSheet extends StatefulWidget {
  final RestaurantItem item;
  final List<AdditiveModel> additives;
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

  const ItemCustomizationSheet({
    super.key,
    required this.item,
    required this.onConfirm,
    required this.additives,
  });

  static void show(
    BuildContext context,
    RestaurantItem item,
    List<AdditiveModel> additives,
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
    onConfirm,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: ItemCustomizationSheet(
          item: item,
          onConfirm: onConfirm,
          additives: additives,
        ),
      ),
    );
  }

  @override
  State<ItemCustomizationSheet> createState() => _ItemCustomizationSheetState();
}

class _ItemCustomizationSheetState extends State<ItemCustomizationSheet> {
  int _quantity = 1;
  int _selectedSizeIndex = 0; // Default to Medium

  // Tracks quantities per additive index: { additiveIndex: quantity }
  final Map<int, int> _addonQuantities = {};

  bool _isPercentageDiscount = true;
  final TextEditingController _discountController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  double get _currentBasePrice => widget.item.sizes[_selectedSizeIndex].price;

  double get _totalPrice {
    double addonsTotal = 0.0;
    _addonQuantities.forEach((index, qty) {
      addonsTotal += widget.additives[index].price * qty;
    });

    double itemTotal = (_currentBasePrice + addonsTotal) * _quantity;

    double discountVal = double.tryParse(_discountController.text) ?? 0.0;
    if (_isPercentageDiscount) {
      itemTotal = itemTotal * (1 - (discountVal / 100));
    } else {
      itemTotal = (itemTotal - discountVal).clamp(0.0, double.infinity);
    }

    return itemTotal;
  }

  List<AdditiveModel> _getSelectedAddonsList() {
    final List<AdditiveModel> selectedList = [];
    _addonQuantities.forEach((index, qty) {
      for (int i = 0; i < qty; i++) {
        selectedList.add(widget.additives[index]);
      }
    });
    return selectedList;
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

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(spacing.radiusPill),
        ),
      ),
      height: MediaQuery.of(context).size.height * 0.9,
      child: Column(
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
                ...List.generate(widget.additives.length, (index) {
                  final addon = widget.additives[index];
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
                SizedBox(height: spacing.xl),
                Text(
                  lang.specialDiscount,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: spacing.sm),
                DiscountTypeToggle(
                  isPercentage: _isPercentageDiscount,
                  onChanged: (value) =>
                      setState(() => _isPercentageDiscount = value),
                ),
                SizedBox(height: spacing.sm),
                TextField(
                  controller: _discountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: lang.enterDiscountValue,
                    fillColor: theme.colorScheme.surfaceContainerHighest,
                  ),
                  onChanged: (value) => setState(() {}),
                ),
                SizedBox(height: spacing.xl),
                Text(
                  lang.specialNotes,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: spacing.sm),
                TextField(
                  controller: _notesController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: lang.specialNotesHint,
                    fillColor: theme.colorScheme.surfaceContainerHighest,
                  ),
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
            totalPrice: _totalPrice,
            onConfirm: () {
              Navigator.pop(context);
              widget.onConfirm(
                widget.item,
                widget.additives,
                selectedSize: widget.item.sizes[_selectedSizeIndex],
                selectedAddons: _getSelectedAddonsList(),
                discount: double.tryParse(_discountController.text) ?? 0.0,
                isPercentageDiscount: _isPercentageDiscount,
                notes: _notesController.text,
                quantity: _quantity,
              );
            },
          ),
        ],
      ),
    );
  }
}

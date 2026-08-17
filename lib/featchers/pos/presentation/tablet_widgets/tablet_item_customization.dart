import 'package:apex_restaurant/core/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/helpers/extensions.dart';
import '../../../../core/helpers/helper_methods.dart';
import '../../../../generated/l10n.dart';
import '../../../cart/presentation/bloc/cart_bloc.dart';
import '../../data/models/category_model.dart';
import '../../data/models/restaurant_item.dart';
import '../../domain/entities/menu_item.dart';
import '../bloc/pos_bloc.dart';
import '../bloc/pos_state.dart';
import '../widgets/discount_type_toggle.dart';
import '../widgets/item_addon_tile.dart';
import '../widgets/item_size_selector.dart';

class TabletItemCustomizationDialog extends StatefulWidget {
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

  const TabletItemCustomizationDialog({
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
    Function(
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
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          clipBehavior: Clip.antiAlias,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 40,
            vertical: 24,
          ),
          child: SizedBox(
            width: 850,
            height: 600,
            child: TabletItemCustomizationDialog(
              item: item,
              posBloc: posBloc,
              onConfirm: onConfirm,
              existingItem: existingItem,
              cartIndex: cartIndex,
            ),
          ),
        ),
      ),
    );
  }

  @override
  State<TabletItemCustomizationDialog> createState() =>
      _TabletItemCustomizationDialogState();
}

class _TabletItemCustomizationDialogState
    extends State<TabletItemCustomizationDialog> {
  int _quantity = 1;
  int _selectedSizeIndex = 0;
  final Map<int, int> _addonQuantities = {};
  bool _addonsPrefilled = false;
  bool _isPercentageDiscount = true;

  final TextEditingController _discountController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  bool get _isEditMode => widget.existingItem != null;

  double get _currentBasePrice => widget.item.sizes.isNotEmpty
      ? widget.item.sizes[_selectedSizeIndex].price ?? 0
      : 0.0;

  double _totalPrice(List<AdditiveModel> additives) {
    double addonsTotal = 0.0;
    _addonQuantities.forEach((index, qty) {
      if (index < additives.length) {
        addonsTotal += additives[index].price * qty;
      }
    });

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

  List<AdditiveModel> _additivesFor(PosState posState) {
    final matchCat = posState.categories.where(
      (cat) => cat.id == widget.item.categoryId,
    );
    return matchCat.isNotEmpty ? (matchCat.first.additives ?? []) : [];
  }

  @override
  void initState() {
    super.initState();
    _prefillFieldsFromExistingItem();
  }

  void _prefillFieldsFromExistingItem() {
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

  void _prefillAddonsOnce(List<AdditiveModel> additives) {
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

    final dynamicDiscountIsActive = context
        .read<CartBloc>()
        .state
        .dynamicDiscountIsActive;
    final discountValue =
        context.read<CartBloc>().state.restaurantPosDiscountRequest?.value ?? 0;
    final isDiscountEnabled = !dynamicDiscountIsActive && discountValue <= 0;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: BlocBuilder<PosBloc, PosState>(
        bloc: widget.posBloc,
        builder: (context, posState) {
          final additives = _additivesFor(posState);
          _prefillAddonsOnce(additives);

          return Column(
            children: [
              // ---------------- MAIN HEADER ----------------
              _buildHeader(theme, textTheme),
              const Divider(height: 1),

              // ---------------- TWO COLUMN BODY ----------------
              Expanded(
                child: Row(
                  children: [
                    //  COLUMN: Sizes & Add-ons
                    Expanded(
                      flex: 5,
                      child: ListView(
                        padding: EdgeInsets.all(spacing.lg),
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
                            onSelected: (idx) =>
                                setState(() => _selectedSizeIndex = idx),
                          ),
                          SizedBox(height: spacing.lg),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                lang.addons,
                                style: textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'بحد أقصى 3 إضافات',
                                style: textTheme.bodySmall?.copyWith(
                                  color: AppColors.amber,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: spacing.sm),

                          if (additives.isEmpty)
                            Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: spacing.lg,
                              ),
                              child: Text(
                                'لا توجد إضافات متاحة',
                                style: textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSecondary,
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
                        ],
                      ),
                    ),
                    VerticalDivider(
                      width: 1,
                      thickness: 1,
                      color: theme.dividerColor.withOpacity(0.1),
                    ),
                    //  COLUMN: Notes, Discounts, Quantity, Add to Cart Action
                    Expanded(
                      flex: 4,
                      child: Padding(
                        padding: EdgeInsets.all(spacing.lg),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              lang.specialNotes,
                              style: textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: spacing.xs),
                            TextField(
                              controller: _notesController,
                              maxLines: 3,
                              decoration: InputDecoration(
                                hintText: lang.specialNotesHint,
                                fillColor:
                                    theme.colorScheme.surfaceContainerHighest,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                            SizedBox(height: spacing.lg),

                            Text(
                              lang.specialDiscount,
                              style: textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: spacing.xs),
                            DiscountTypeToggle(
                              enabled: isDiscountEnabled,
                              isPercentage: _isPercentageDiscount,
                              onChanged: (val) =>
                                  setState(() => _isPercentageDiscount = val),
                            ),
                            SizedBox(height: spacing.xs),
                            TextField(
                              enabled: isDiscountEnabled,
                              controller: _discountController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: lang.enterDiscountValue,
                                fillColor: theme.colorScheme.surface,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              onChanged: (_) => setState(() {}),
                            ),

                            const Spacer(),

                            // Quantity Stepper Controls
                            Container(
                              height: 48,
                              decoration: BoxDecoration(
                                color: theme.colorScheme.surface,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove),
                                    onPressed: _quantity > 1
                                        ? () => setState(() => _quantity--)
                                        : null,
                                  ),
                                  Text(
                                    '$_quantity',
                                    style: textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.add),
                                    onPressed: () =>
                                        setState(() => _quantity++),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: spacing.md),

                            // Submit Button
                            SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: theme.colorScheme.primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: () =>
                                    _handleConfirm(context, additives, lang),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      _isEditMode ? 'تعديل السلة' : 'أضف للسلة',
                                      style: textTheme.titleMedium?.copyWith(
                                        color: theme.colorScheme.onPrimary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '${_totalPrice(additives).toStringAsFixed(2)} ر.س',
                                      style: textTheme.titleMedium?.copyWith(
                                        color: theme.colorScheme.onPrimary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, TextTheme textTheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: theme.colorScheme.surface,
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
          if (_isEditMode) ...[
            const SizedBox(width: 8),
            Chip(
              avatar: const Icon(Icons.edit, size: 16),
              label: const Text('تعديل'),
              backgroundColor: theme.colorScheme.primaryContainer,
            ),
          ],
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.item.itemNameAr,
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'اختر الحجم المناسب والإضافات المرغوبة',
                style: textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child:
                widget.item.imagePath != null &&
                    widget.item.imagePath!.isNotEmpty
                ? Image.network(
                    widget.item.imagePath!,
                    width: 48,
                    height: 48,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _buildPlaceholderImage(theme),
                  )
                : _buildPlaceholderImage(theme),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderImage(ThemeData theme) {
    return Container(
      width: 48,
      height: 48,
      color: theme.colorScheme.surfaceContainerHighest,
      child: Icon(Icons.fastfood, color: theme.colorScheme.onSurfaceVariant),
    );
  }

  void _handleConfirm(
    BuildContext context,
    List<AdditiveModel> additives,
    S lang,
  ) {
    if (widget.item.sizes.isEmpty) {
      HelperMethods.showSnackBar(
        context: context,
        message: lang.thisItemHasNoValidSize,
        isError: true,
      );
      return;
    }

    final selectedSize = widget.item.sizes[_selectedSizeIndex];

    if (widget.item.sizes.length > 1 && (selectedSize.sizeId ?? 0) <= 0) {
      HelperMethods.showSnackBar(
        context: context,
        message: lang.pleaseSelectValidSize,
        isError: true,
      );
      return;
    }

    Navigator.pop(context);
    widget.onConfirm(
      widget.item,
      additives,
      selectedSize: selectedSize,
      selectedAddons: _getSelectedAddonsList(additives),
      discount: double.tryParse(_discountController.text) ?? 0.0,
      isPercentageDiscount: _isPercentageDiscount,
      notes: _notesController.text,
      quantity: _quantity,
    );
  }
}

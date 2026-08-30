import 'package:apex_restaurant/core/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/helpers/extensions.dart';
import '../../../../core/helpers/helper_methods.dart';
import '../../../../core/helpers/item_discount_handler.dart';
import '../../../../generated/l10n.dart';
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
    extends State<TabletItemCustomizationDialog>
    with ItemDiscountHandler<TabletItemCustomizationDialog> {
  @override
  RestaurantItem get item => widget.item;
  bool get _isEditMode => widget.existingItem != null;

  @override
  void initState() {
    super.initState();
    prefillFromExistingItem(widget.existingItem);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() => syncDiscountFieldsWithSize(context));
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final spacing = context.spacing;
    final lang = S.of(context);
    final isDiscountEnabled = calculateIsDiscountEnabled(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: BlocBuilder<PosBloc, PosState>(
        bloc: widget.posBloc,
        builder: (context, posState) {
          final additives = additivesFor(posState);
          prefillAddonsOnce(additives, widget.existingItem);

          return Column(
            children: [
              _buildHeader(theme, textTheme),
              const Divider(height: 1),
              Expanded(
                child: Row(
                  children: [
                    // Column 1: Sizes & Addons
                    Expanded(
                      flex: 5,
                      child: ListView(
                        padding: EdgeInsets.all(spacing.lg),
                        children: [
                          Text(lang.productSize, style: textTheme.titleMedium),
                          SizedBox(height: spacing.sm),
                          ItemSizeSelector(
                            sizes: widget.item.sizes,
                            selectedIndex: selectedSizeIndex,
                            onSelected: (idx) {
                              setState(() {
                                selectedSizeIndex = idx;
                                syncDiscountFieldsWithSize(context);
                              });
                            },
                          ),
                          SizedBox(height: spacing.lg),
                          Text(lang.addons, style: textTheme.titleMedium),
                          SizedBox(height: spacing.sm),
                          if (additives.isEmpty)
                            Text(
                              'لا توجد إضافات متاحة',
                              style: textTheme.bodyMedium,
                            )
                          else
                            ...List.generate(additives.length, (index) {
                              final addon = additives[index];
                              final currentQty = addonQuantities[index] ?? 0;

                              return ItemAddonTile(
                                addon: addon,
                                quantity: currentQty,
                                onDecrement: () => setState(() {
                                  if (currentQty > 1) {
                                    addonQuantities[index] = currentQty - 1;
                                  } else {
                                    addonQuantities.remove(index);
                                  }
                                }),
                                onIncrement: () => setState(() {
                                  addonQuantities[index] = currentQty + 1;
                                }),
                              );
                            }),
                        ],
                      ),
                    ),
                    VerticalDivider(
                      width: 1,
                      color: theme.dividerColor.withOpacity(0.1),
                    ),

                    // Column 2: Controls & Actions
                    Expanded(
                      flex: 4,
                      child: Padding(
                        padding: EdgeInsets.all(spacing.lg),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              lang.specialNotes,
                              style: textTheme.titleMedium,
                            ),
                            TextField(controller: notesController, maxLines: 3),
                            SizedBox(height: spacing.lg),
                            Text(
                              lang.specialDiscount,
                              style: textTheme.titleMedium,
                            ),
                            DiscountTypeToggle(
                              enabled: isDiscountEnabled,
                              isPercentage: isPercentageDiscount,
                              onChanged: (val) =>
                                  setState(() => isPercentageDiscount = val),
                            ),
                            TextField(
                              enabled: isDiscountEnabled,
                              controller: discountController,
                              keyboardType: TextInputType.number,
                              onChanged: (_) => setState(() {}),
                            ),
                            const Spacer(),

                            // Stepper
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.remove,
                                    color: theme.colorScheme.onSecondary,
                                  ),
                                  onPressed: quantity > 1
                                      ? () => setState(() => quantity--)
                                      : null,
                                ),
                                Text('$quantity', style: textTheme.titleMedium),
                                IconButton(
                                  icon: Icon(
                                    Icons.add,
                                    color: theme.colorScheme.onSecondary,
                                  ),
                                  onPressed: () => setState(() => quantity++),
                                ),
                              ],
                            ),
                            SizedBox(height: spacing.md),

                            // Submit Button
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: theme.colorScheme.primary,
                                foregroundColor: AppColors.white,
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
                                  ),
                                  Text(
                                    '${calculateTotalPrice(additives: additives).toStringAsFixed(2)} ر.س',
                                  ),
                                ],
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

    final selectedSize = widget.item.sizes[selectedSizeIndex];
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
      selectedAddons: getSelectedAddonsList(additives),
      discount: double.tryParse(discountController.text) ?? 0.0,
      isPercentageDiscount: isPercentageDiscount,
      notes: notesController.text,
      quantity: quantity,
    );
  }

  Widget _buildHeader(ThemeData theme, TextTheme textTheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: theme.colorScheme.surface,
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.close, color: theme.colorScheme.onSecondary),
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

  // void _handleConfirm(
  //   BuildContext context,
  //   List<AdditiveModel> additives,
  //   S lang,
  // ) {
  //   if (widget.item.sizes.isEmpty) {
  //     HelperMethods.showSnackBar(
  //       context: context,
  //       message: lang.thisItemHasNoValidSize,
  //       isError: true,
  //     );
  //     return;
  //   }

  //   final selectedSize = widget.item.sizes[selectedSizeIndex];

  //   if (widget.item.sizes.length > 1 && (selectedSize.sizeId ?? 0) <= 0) {
  //     HelperMethods.showSnackBar(
  //       context: context,
  //       message: lang.pleaseSelectValidSize,
  //       isError: true,
  //     );
  //     return;
  //   }

  //   Navigator.pop(context);
  //   widget.onConfirm(
  //     widget.item,
  //     additives,
  //     selectedSize: selectedSize,
  //     selectedAddons: _getSelectedAddonsList(additives),
  //     discount: double.tryParse(discountController.text) ?? 0.0,
  //     isPercentageDiscount: isPercentageDiscount,
  //     notes: notesController.text,
  //     quantity: _quantity,
  //   );
  // }
}

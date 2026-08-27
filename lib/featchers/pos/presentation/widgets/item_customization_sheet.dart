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
import 'add_to_cart_bar.dart';
import 'discount_type_toggle.dart';
import 'item_addon_tile.dart';
import 'item_customization_header.dart';
import 'item_size_selector.dart';

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

class _ItemCustomizationSheetState extends State<ItemCustomizationSheet>
    with ItemDiscountHandler<ItemCustomizationSheet> {
  @override
  RestaurantItem get item => widget.item;

  @override
  void initState() {
    super.initState();
    prefillFromExistingItem(widget.existingItem);

    // مزامنة الخصم التلقائي بعد رسم الشاشة
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

    // التحقق من تفعيل الخصم اليدوي بناءً على الـ Mixin
    final isDiscountEnabled = calculateIsDiscountEnabled(context);

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
          final isLoadingAddons =
              posState.categories.isEmpty &&
              posState.status == PosStatus.loading;
          final List<AdditiveModel> additives = additivesFor(posState);

          prefillAddonsOnce(additives, widget.existingItem);

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // رأس النموذج
              ItemCustomizationHeader(
                itemNameAr: widget.item.itemNameAr,
                imagePath: widget.item.imagePath,
              ),
              const Divider(height: 1),

              // محتوى خيارات المنتج
              Expanded(
                child: ListView(
                  padding: EdgeInsets.all(spacing.md),
                  children: [
                    // اختيار الحجم
                    Text(
                      lang.productSize,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: spacing.sm),
                    ItemSizeSelector(
                      sizes: widget.item.sizes,
                      selectedIndex: selectedSizeIndex,
                      onSelected: (index) {
                        setState(() {
                          selectedSizeIndex = index;
                          syncDiscountFieldsWithSize(context);
                        });
                      },
                    ),
                    SizedBox(height: spacing.xl),

                    // قائمة الإضافات
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
                        final currentQty = addonQuantities[index] ?? 0;

                        return ItemAddonTile(
                          addon: addon,
                          quantity: currentQty,
                          onDecrement: () {
                            setState(() {
                              if (currentQty > 1) {
                                addonQuantities[index] = currentQty - 1;
                              } else {
                                addonQuantities.remove(index);
                              }
                            });
                          },
                          onIncrement: () {
                            setState(() {
                              addonQuantities[index] = currentQty + 1;
                            });
                          },
                        );
                      }),
                    SizedBox(height: spacing.sm),

                    // الملاحظات الخاصة
                    Text(
                      lang.specialNotes,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: spacing.sm),
                    TextField(
                      controller: notesController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: lang.specialNotesHint,
                        fillColor: theme.colorScheme.surfaceContainerHighest,
                      ),
                    ),
                    SizedBox(height: spacing.xl),

                    // الخصم الخاص
                    Text(
                      lang.specialDiscount,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: spacing.sm),
                    DiscountTypeToggle(
                      enabled: isDiscountEnabled,
                      isPercentage: isPercentageDiscount,
                      onChanged: (value) =>
                          setState(() => isPercentageDiscount = value),
                    ),
                    SizedBox(height: spacing.sm),
                    TextField(
                      enabled: isDiscountEnabled,
                      controller: discountController,
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
                      onChanged: (_) => setState(() {}),
                    ),
                    SizedBox(height: spacing.xl),
                  ],
                ),
              ),

              // شريط إضافة إلى السلة والسعر الإجمالي
              AddToCartBar(
                quantity: quantity,
                onIncrement: () => setState(() => quantity++),
                onDecrement: () {
                  if (quantity > 1) setState(() => quantity--);
                },
                totalPrice: calculateTotalPrice(additives: additives),
                onConfirm: () => _handleConfirm(context, additives, lang),
              ),
            ],
          );
        },
      ),
    );
  }

  // تأكيد الإضافة للسلة والتحقق من صحة المدخلات
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
}

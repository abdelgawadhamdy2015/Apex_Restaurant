import 'package:apex_restaurant/core/helpers/extensions.dart';
import 'package:apex_restaurant/featchers/cart/presentation/bloc/cart_bloc.dart';
import 'package:apex_restaurant/featchers/cart/presentation/bloc/cart_event.dart';
import 'package:apex_restaurant/featchers/pos/domain/entities/get_food_additive_request.dart';
import 'package:apex_restaurant/featchers/pos/domain/entities/menu_item.dart';
import 'package:apex_restaurant/featchers/pos/presentation/bloc/pos_bloc.dart';
import 'package:apex_restaurant/featchers/pos/presentation/bloc/pos_event.dart';
import 'package:apex_restaurant/featchers/pos/presentation/widgets/item_customization_sheet.dart';
import 'package:apex_restaurant/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// A single order item row: image, name, price, size/addons/notes and
/// quantity controls. Tapping the tile opens the customization sheet.
class CartItemTile extends StatelessWidget {
  const CartItemTile({super.key, required this.index, required this.item});

  final int index;
  final OrderItem item;

  List<String> _formattedAddons() {
    final addonCounts = <String, int>{};
    for (final addon in item.addons) {
      addonCounts[addon.arabicName] = (addonCounts[addon.arabicName] ?? 0) + 1;
    }
    return addonCounts.entries
        .map((entry) => '+ ${entry.key} ${entry.value}x')
        .toList();
  }

  void _openEditSheet(BuildContext context) {
    final posBloc = context.read<PosBloc>();
    final cartBloc = context.read<CartBloc>();
    posBloc.state.additives?.clear();
    posBloc.add(
      LoadFoodAdditivesEvent(
        requestModel: GetFoodAdditivesRequest(
          categoryID: item.menuItem.categoryId,
        ),
      ),
    );

    final restaurantItem = posBloc.state.currentMenuItems.firstWhere(
      (m) => m.itemId == item.menuItem.itemId,
      orElse: () => item.menuItem,
    );

    ItemCustomizationSheet.show(
      context,
      restaurantItem,
      posBloc, // sheet now watches this bloc directly via BlocBuilder
      (
        restaurantItem,
        additives, {
        required selectedSize,
        required selectedAddons,
        required discount,
        required isPercentageDiscount,
        required String notes,
        required int quantity,
      }) {
        cartBloc.add(
          EditCartItemEvent(
            index: index,
            selectedSize: selectedSize,
            selectedAddons: selectedAddons,
            discount: discount,
            isPercentageDiscount: isPercentageDiscount,
            notes: notes,
            quantity: quantity,
          ),
        );
      },
      existingItem: item,
      cartIndex: index,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final icons = context.iconSizes;
    final lang = S.of(context);

    final sizeName = item.selectedSize?.sizeNameAr ?? '';
    final formattedAddons = _formattedAddons();
    final hasNotes = item.notes != null && item.notes!.isNotEmpty;

    return InkWell(
      onTap: () => _openEditSheet(context),
      borderRadius: BorderRadius.circular(spacing.radiusLg),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: spacing.sm),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(spacing.radiusLg),
                  child: Container(
                    width: 80,
                    height: 80,
                    color: theme.colorScheme.surfaceContainerHighest,
                    child: item.menuItem.imagePath != null
                        ? Image.network(
                            item.menuItem.imagePath!,
                            fit: BoxFit.cover,
                          )
                        : Icon(
                            Icons.fastfood,
                            color: theme.colorScheme.onSurfaceVariant,
                            size: icons.lg,
                          ),
                  ),
                ),
                SizedBox(width: spacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              item.menuItem.itemNameAr,
                              textAlign: TextAlign.right,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                          ),
                          SizedBox(width: spacing.xs),
                          Text(
                            '${item.totalPrice.toStringAsFixed(2)} ${lang.currencySar}',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                      if (sizeName.isNotEmpty) ...[
                        SizedBox(height: spacing.xxs),
                        Text(
                          lang.sizeWithVal(sizeName),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                      if (formattedAddons.isNotEmpty) ...[
                        SizedBox(height: spacing.xxs),
                        ...formattedAddons.map(
                          (addonText) => Padding(
                            padding: EdgeInsets.only(top: spacing.xxs / 2),
                            child: Text(
                              addonText,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.secondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                      if (hasNotes) ...[
                        SizedBox(height: spacing.xxs),
                        Text(
                          item.notes!,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                      SizedBox(height: spacing.sm),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.delete_outline_rounded,
                              color: theme.colorScheme.error,
                              size: icons.md,
                            ),
                            onPressed: () => context.read<CartBloc>().add(
                              RemoveItemEvent(index),
                            ),
                          ),
                          const Spacer(),
                          Container(
                            height: 38,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(
                                spacing.radiusMd,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.add, size: 18),
                                  color: theme.colorScheme.onSurface,
                                  onPressed: () => context.read<CartBloc>().add(
                                    UpdateItemQuantityEvent(index, 1),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: spacing.xs,
                                  ),
                                  child: Text(
                                    '${item.quantity}',
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.remove, size: 18),
                                  color: theme.colorScheme.onSurface,
                                  onPressed: () => context.read<CartBloc>().add(
                                    UpdateItemQuantityEvent(index, -1),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: spacing.md),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
            thickness: 0.8,
            color: theme.colorScheme.outlineVariant.withOpacity(0.5),
          ),
        ],
      ),
    );
  }
}

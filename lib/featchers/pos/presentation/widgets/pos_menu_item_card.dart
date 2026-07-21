// lib/featchers/pos/presentation/widgets/pos_menu_item_card.dart
import 'package:apex_restaurant/core/helpers/extensions.dart';
import 'package:apex_restaurant/featchers/pos/data/models/restaurant_item.dart';
import 'package:flutter/material.dart';

/// Single menu item tile shown in the POS menu grid: image, name (ar/en),
/// price, and a quick-add button.
class PosMenuItemCard extends StatelessWidget {
  const PosMenuItemCard({
    super.key,
    required this.item,
    required this.onAddPressed,
  });

  final RestaurantItem item;
  final VoidCallback onAddPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final iconSizes = context.iconSizes;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: item.imagePath != null
                      ? Image.network(
                          item.imagePath!,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          color: theme.colorScheme.surfaceContainerHighest,
                          child: Center(
                            child: Icon(
                              Icons.fastfood,
                              size: iconSizes.xl,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                ),
                Positioned(
                  top: spacing.xs,
                  left: spacing.xs,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: spacing.xs,
                      vertical: spacing.xxs,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.tertiary,
                      borderRadius: BorderRadius.circular(spacing.radiusLg),
                    ),
                    child: Text(
                      item.isOffer ? 'عرض' : 'جديد',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onTertiary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(spacing.sm),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.itemNameAr,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    // Was AppColors.textPrimary.
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: spacing.xxs / 2),
                Text(
                  item.itemNameEn,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    // Was AppColors.textSecondary.
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: spacing.xs),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${item.defaultPrice.toStringAsFixed(2)} ر.س',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        // Was AppColors.primary.
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    InkWell(
                      onTap: onAddPressed,
                      child: Container(
                        padding: EdgeInsets.all(spacing.xxs),
                        decoration: BoxDecoration(
                          // Was AppColors.primary.
                          color: theme.colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.add,
                          // Was Colors.white.
                          color: theme.colorScheme.onPrimary,
                          size: iconSizes.md,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

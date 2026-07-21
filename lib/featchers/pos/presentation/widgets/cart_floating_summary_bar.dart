// lib/featchers/pos/presentation/widgets/cart_floating_summary_bar.dart
import 'package:apex_restaurant/core/helpers/extensions.dart';
import 'package:flutter/material.dart';

/// Floating pill shown above the bottom nav bar once the cart has items:
/// item count + total, with a button to jump to the cart screen.
class CartFloatingSummaryBar extends StatelessWidget {
  const CartFloatingSummaryBar({
    super.key,
    required this.itemCount,
    required this.totalAmount,
    required this.onViewCartPressed,
  });

  final int itemCount;
  final double totalAmount;
  final VoidCallback onViewCartPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final iconSizes = context.iconSizes;

    return Container(
      margin: EdgeInsets.all(spacing.md),
      padding: EdgeInsets.symmetric(
        horizontal: spacing.md,
        vertical: spacing.sm,
      ),
      decoration: BoxDecoration(
        // Was AppColors.primary.
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    padding: EdgeInsets.all(spacing.xs),
                    decoration: BoxDecoration(
                      // Was Colors.white.withOpacity(0.2) — onPrimary is
                      // white in both your themes, kept semantic here.
                      color: theme.colorScheme.onPrimary.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.shopping_basket_outlined,
                      color: theme.colorScheme.onPrimary,
                      size: iconSizes.lg,
                    ),
                  ),
                  Positioned(
                    top: -4,
                    right: -4,
                    child: CircleAvatar(
                      radius: 10,
                      // Was AppColors.badgeOrange.
                      backgroundColor: theme.colorScheme.secondary,
                      child: Text(
                        '$itemCount',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSecondary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(width: spacing.sm),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$itemCount أصناف',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '${totalAmount.toStringAsFixed(2)} ر.س',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          ElevatedButton.icon(
            onPressed: onViewCartPressed,
            style: ElevatedButton.styleFrom(
              // Was Colors.white / AppColors.primary — inverted so the
              // button reads clearly on top of the primary-colored bar
              // regardless of what the accent color is.
              backgroundColor: theme.colorScheme.onPrimary,
              foregroundColor: theme.colorScheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(spacing.radiusLg),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: spacing.md,
                vertical: spacing.xs,
              ),
            ),
            icon: Icon(Icons.arrow_back, size: iconSizes.md),
            label: const Text(
              'عرض السلة',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

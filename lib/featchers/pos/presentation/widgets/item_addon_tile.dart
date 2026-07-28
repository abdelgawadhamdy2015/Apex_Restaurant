import 'package:apex_restaurant/core/helpers/extensions.dart';
import 'package:apex_restaurant/featchers/pos/data/models/category_model.dart';
import 'package:apex_restaurant/generated/l10n.dart';
import 'package:flutter/material.dart';

class ItemAddonTile extends StatelessWidget {
  const ItemAddonTile({
    super.key,
    required this.addon,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
    this.isPopular = false,
  });

  final AdditiveModel addon;
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final bool isPopular;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final spacing = context.spacing;
    final lang = S.of(context);

    final bool isSelected = quantity > 0;
    const Color activeGreenColor = Color(
      0xFF10B981,
    ); // Bright green border color

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: EdgeInsets.only(bottom: spacing.xs),
      padding: EdgeInsets.all(spacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(spacing.radiusMd),
        border: Border.all(
          color: isSelected
              ? activeGreenColor
              : theme.colorScheme.outlineVariant.withOpacity(0.5),
          width: isSelected ? 2.0 : 1.0,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 1. Quantity Stepper Counter (- 0 +)
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFEEF2FF), // Soft light blue/grey background
              borderRadius: BorderRadius.circular(spacing.radiusSm),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: spacing.xs,
              vertical: spacing.xxs,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildStepperButton(
                  icon: Icons.remove,
                  onTap: onDecrement,
                  theme: theme,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: spacing.md),
                  child: Text(
                    '$quantity',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ),
                _buildStepperButton(
                  icon: Icons.add,
                  onTap: onIncrement,
                  theme: theme,
                ),
              ],
            ),
          ),

          // 2. Addon Info (Name, Tag, Price)
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isPopular) ...[
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: spacing.xs,
                        vertical: spacing.xxs / 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(
                          0xFFFFEAEA,
                        ), // Light red badge background
                        borderRadius: BorderRadius.circular(spacing.radiusLg),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            lang.popular,
                            style: textTheme.labelSmall?.copyWith(
                              color: const Color(0xFFE53935),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: spacing.xxs / 2),
                          const Icon(
                            Icons.whatshot_outlined,
                            color: Color(0xFFE53935),
                            size: 12,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: spacing.xs),
                  ],
                  Text(
                    addon.arabicName,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              SizedBox(height: spacing.xxs),
              Text(
                addon.price > 0
                    ? '+${addon.price.toStringAsFixed(2)} ${lang.currencySar}'
                    : lang.free,
                style: textTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStepperButton({
    required IconData icon,
    required VoidCallback onTap,
    required ThemeData theme,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Icon(icon, size: 18, color: theme.colorScheme.onSurfaceVariant),
      ),
    );
  }
}

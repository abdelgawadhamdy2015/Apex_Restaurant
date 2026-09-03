import 'package:apex_restaurant/core/themes/app_colors.dart';

import '../../../../core/helpers/extensions.dart';
import '../../data/models/category_model.dart';
import '../../../../generated/l10n.dart';
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
    const Color activeGreenColor = AppColors.green; // Bright green border color

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: EdgeInsets.only(bottom: spacing.xs),
      padding: EdgeInsets.all(spacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.onSurface,
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                        color: const Color(0xFFFFEAEA), //

                        borderRadius: BorderRadius.circular(spacing.radiusLg),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            lang.popular,
                            style: textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.errorContainer,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: spacing.xxs / 2),
                          Icon(
                            Icons.whatshot_outlined,
                            color: theme.colorScheme.errorContainer,
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
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                ],
              ),
              SizedBox(height: spacing.xxs),
              Text(
                addon.price > 0
                    ? '+${addon.price.toStringAsFixed(2)} ${lang.currencySarShort}'
                    : lang.free,
                style: textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSecondary,
                ),
              ),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(spacing.radiusSm),
              border: Border.all(color: theme.colorScheme.outlineVariant),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: spacing.xs,
              vertical: spacing.xxs,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildStepperButton(
                  context: context,
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
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                ),
                _buildStepperButton(
                  context: context,
                  icon: Icons.add,
                  onTap: onIncrement,
                  theme: theme,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepperButton({
    required IconData icon,
    required VoidCallback onTap,
    required ThemeData theme,
    required BuildContext context,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Icon(
          icon,
          size: context.iconSizes.md,
          color: theme.colorScheme.onSecondary,
        ),
      ),
    );
  }
}

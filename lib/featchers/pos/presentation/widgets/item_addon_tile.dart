// lib/featchers/pos/presentation/widgets/item_addon_tile.dart
import 'package:apex_restaurant/core/helpers/extensions.dart';
import 'package:apex_restaurant/featchers/pos/data/models/category_model.dart';
import 'package:flutter/material.dart';

/// Single addon row in the item customization sheet, with a "popular"
/// badge and a toggle button to add/remove it.
class ItemAddonTile extends StatelessWidget {
  const ItemAddonTile({
    super.key,
    required this.addon,
    required this.isSelected,
    required this.onToggle,
  });

  final AdditiveModel addon;
  final bool isSelected;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final spacing = context.spacing;
    final iconSizes = context.iconSizes;

    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Row(
            children: [
              Text(addon.arabicName, style: textTheme.bodyLarge),
              SizedBox(width: spacing.xs),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: spacing.xs,
                  vertical: spacing.xxs / 2,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(spacing.radiusSm),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.whatshot,
                      color: theme.colorScheme.secondary,
                      size: 12,
                    ),
                    SizedBox(width: spacing.xxs / 2),
                    Text(
                      'شائع',
                      style: textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.secondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          subtitle: Text(
            addon.price > 0 ? '+${addon.price} ر.س' : 'مجاناً',
            style: textTheme.bodyMedium?.copyWith(
              // Was theme.hintColor.
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          trailing: IconButton(
            icon: Icon(
              isSelected ? Icons.check_circle : Icons.add_circle_outline,
              color: theme.colorScheme.primary,
              size: iconSizes.xl,
            ),
            onPressed: onToggle,
          ),
        ),
        const Divider(height: 1),
      ],
    );
  }
}

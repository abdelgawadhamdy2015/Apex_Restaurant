// lib/featchers/pos/presentation/widgets/item_size_selector.dart
import 'package:apex_restaurant/core/helpers/extensions.dart';
import 'package:apex_restaurant/featchers/pos/data/models/restaurant_item.dart';
import 'package:flutter/material.dart';

/// Row of selectable size options (small/medium/large) shown in the item
/// customization sheet.
class ItemSizeSelector extends StatelessWidget {
  const ItemSizeSelector({
    super.key,
    required this.sizes,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<ItemSize> sizes;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final spacing = context.spacing;
    final iconSizes = context.iconSizes;

    return Row(
      children: List.generate(sizes.length, (index) {
        final size = sizes[index];
        final isSelected = selectedIndex == index;
        return Expanded(
          child: GestureDetector(
            onTap: () => onSelected(index),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: spacing.xxs),
              padding: EdgeInsets.all(spacing.sm),
              decoration: BoxDecoration(
                color: isSelected
                    ? theme.colorScheme.primary.withOpacity(0.04)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(spacing.radiusLg),
                border: Border.all(
                  color: isSelected
                      ? theme.colorScheme.primary
                      // Was theme.dividerColor.withOpacity(0.1).
                      : theme.colorScheme.outlineVariant,
                  width: 2,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        size.sizeNameAr,
                        style: textTheme.bodyLarge?.copyWith(
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                      Icon(
                        isSelected
                            ? Icons.radio_button_checked
                            : Icons.radio_button_off,
                        color: isSelected
                            ? theme.colorScheme.primary
                            // Was theme.hintColor.withOpacity(0.5).
                            : theme.colorScheme.onSurfaceVariant.withOpacity(
                                0.5,
                              ),
                        size: iconSizes.md,
                      ),
                    ],
                  ),
                  SizedBox(height: spacing.xs),
                  Text(
                    '${size.price} ريال',
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isSelected
                          ? theme.colorScheme.primary
                          // Was theme.hintColor.
                          : theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

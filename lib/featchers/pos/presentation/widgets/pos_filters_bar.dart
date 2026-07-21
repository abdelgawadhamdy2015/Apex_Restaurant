// lib/featchers/pos/presentation/widgets/pos_filters_bar.dart
import 'package:apex_restaurant/core/helpers/extensions.dart';
import 'package:flutter/material.dart';

/// Horizontal row of quick filter chips (Best Seller, Favorites, etc.)
/// shown under the categories bar on the POS menu screen.
class PosFiltersBar extends StatelessWidget {
  const PosFiltersBar({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelected;

  static const filters = [
    'الكل',
    '🔥 الأكثر مبيعاً',
    '⭐ المفضلة',
    '🆕 جديد',
    '🎁 عروض اليوم',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;

    return SizedBox(
      height: 38,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: spacing.md),
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (_, __) => SizedBox(width: spacing.xs),
        itemBuilder: (context, index) {
          final isSelected = selectedIndex == index;
          return ChoiceChip(
            label: Text(filters[index]),
            selected: isSelected,
            // Was AppColors.badgeOrange — mapped to colorScheme.secondary
            // (already your amber accent) so this reacts to theme/accent
            // changes instead of always being one fixed orange.
            selectedColor: theme.colorScheme.secondary.withOpacity(0.2),
            // Was AppColors.surface.
            backgroundColor: theme.colorScheme.surface,
            labelStyle: theme.textTheme.bodySmall?.copyWith(
              // Was AppColors.textPrimary / AppColors.textSecondary.
              color: isSelected
                  ? theme.colorScheme.onSurface
                  : theme.colorScheme.onSurfaceVariant,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(
                // Was AppColors.badgeOrange / AppColors.border.
                color: isSelected
                    ? theme.colorScheme.secondary
                    : theme.colorScheme.outlineVariant,
              ),
            ),
            onSelected: (_) => onSelected(index),
          );
        },
      ),
    );
  }
}

import 'package:apex_restaurant/core/helpers/extensions.dart';
import 'package:apex_restaurant/generated/l10n.dart';
import 'package:flutter/material.dart';

class PosFiltersBar extends StatelessWidget {
  const PosFiltersBar({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final lang = S.of(context);

    final filters = [
      lang.filterAll,
      lang.filterBestSeller,
      lang.filterFavorites,
      lang.filterNew,
      lang.filterTodayOffers,
    ];

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
            selectedColor: theme.colorScheme.secondary.withOpacity(0.2),
            backgroundColor: theme.colorScheme.surface,
            labelStyle: theme.textTheme.bodySmall?.copyWith(
              color: isSelected
                  ? theme.colorScheme.onSurface
                  : theme.colorScheme.onSurfaceVariant,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(
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

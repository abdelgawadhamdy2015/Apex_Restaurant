// lib/featchers/pos/presentation/widgets/pos_categories_bar.dart
import 'package:apex_restaurant/core/helpers/extensions.dart';
import 'package:apex_restaurant/featchers/pos/data/models/category_model.dart';
import 'package:flutter/material.dart';

/// Horizontal scrolling row of menu categories shown at the top of the
/// POS menu screen.
class PosCategoriesBar extends StatelessWidget {
  const PosCategoriesBar({
    super.key,
    required this.categories,
    required this.selectedCategoryId,
    required this.onCategorySelected,
  });

  final List<CategoryModel> categories;
  final int? selectedCategoryId;
  final ValueChanged<CategoryModel> onCategorySelected;

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final spacing = context.spacing;

    return SizedBox(
      height: 72,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: spacing.md),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => SizedBox(width: spacing.sm),
        itemBuilder: (context, index) {
          final cat = categories[index];
          final isSelected = selectedCategoryId == cat.id;

          return InkWell(
            onTap: () => onCategorySelected(cat),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    // Was AppColors.primary / AppColors.surface.
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(spacing.radiusLg),
                    border: Border.all(
                      // Was AppColors.primary / AppColors.border.
                      color: isSelected
                          ? theme.colorScheme.primary
                          : theme.colorScheme.outlineVariant,
                    ),
                  ),
                  child: Icon(
                    Icons.restaurant_menu,
                    // Was Colors.white / AppColors.textPrimary.
                    color: isSelected
                        ? theme.colorScheme.onPrimary
                        : theme.colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: spacing.xxs),
                Text(
                  cat.arabicName,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                    // Was AppColors.primary / AppColors.textPrimary.
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

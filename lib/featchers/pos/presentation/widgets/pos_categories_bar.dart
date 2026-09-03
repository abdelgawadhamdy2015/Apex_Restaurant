import '../../../../core/helpers/extensions.dart';
import '../../data/models/category_model.dart';
import 'package:flutter/material.dart';

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
                    color: isSelected
                        ? theme.colorScheme.onSurface
                        : theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(spacing.radiusLg),
                    border: Border.all(
                      color: isSelected
                          ? theme.colorScheme.primary
                          : theme.colorScheme.surface,
                    ),
                  ),
                  child: cat.imagePath != null && cat.imagePath!.isNotEmpty
                      ? Image.network(
                          cat.imagePath!,
                          // width: double.infinity,
                          // fit: BoxFit.cover,
                        )
                      : Icon(
                          Icons.restaurant_menu,
                          color: isSelected
                              ? theme.colorScheme.onPrimary
                              : theme.colorScheme.onPrimary,
                        ),
                ),
                SizedBox(height: spacing.xxs),
                Text(
                  cat.arabicName,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSecondary,
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

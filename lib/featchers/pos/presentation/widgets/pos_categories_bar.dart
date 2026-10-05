import 'package:apex_restaurant/gen/assets.gen.dart';
import 'package:svg_flutter/svg_flutter.dart';

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
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(spacing.radiusLg),
                          child: Image.network(
                            cat.imagePath!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return FittedBox(
                                fit: BoxFit.scaleDown,
                                child: SvgPicture.asset(Assets.iconSvg),
                              );
                            },
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              }

                              return const Center(
                                child: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      : FittedBox(
                          fit: BoxFit.scaleDown,
                          child: SvgPicture.asset(Assets.iconSvg),
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

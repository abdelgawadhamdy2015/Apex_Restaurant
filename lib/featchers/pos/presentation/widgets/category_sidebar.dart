import 'package:apex_restaurant/core/theme/app_theme.dart';
import 'package:apex_restaurant/core/theme/size_config.dart';
import 'package:apex_restaurant/featchers/pos/data/models/category_model.dart';
import 'package:apex_restaurant/featchers/pos/presentation/bloc/pos_bloc.dart';
import 'package:apex_restaurant/featchers/pos/presentation/bloc/pos_event.dart';
import 'package:apex_restaurant/featchers/pos/presentation/bloc/pos_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class CategorySidebar extends StatelessWidget {
  const CategorySidebar({super.key});

  IconData _getCategoryIcon(String icon) {
    switch (icon) {
      case 'restaurant':
        return Icons.restaurant_menu_outlined;
      case 'dining':
        return Icons.dinner_dining_outlined;
      case 'local_bar':
        return Icons.local_bar_outlined;
      case 'icecream':
        return Icons.icecream_outlined;
      default:
        return Icons.restaurant_menu_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.screenWidth! * .15,
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(left: BorderSide(color: AppColors.border, width: 1)),
      ),
      child: BlocBuilder<PosBloc, PosState>(
        builder: (context, state) {
          return Column(
            children: [
              const SizedBox(height: AppSpacing.md),
              ...state.categories.map((category) {
                final isSelected = category == state.selectedCategory;
                return _CategoryItem(
                  category: category,
                  isSelected: isSelected,
                  icon: _getCategoryIcon(category.arabicName!),
                  onTap: () => context.read<PosBloc>().add(
                    SelectCategoryEvent(category),
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }
}

class _CategoryItem extends StatelessWidget {
  final CategoryModel category;
  final bool isSelected;
  final IconData icon;
  final VoidCallback onTap;

  const _CategoryItem({
    required this.category,
    required this.isSelected,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(
          bottom: AppSpacing.xs,
          left: AppSpacing.sm,
          right: AppSpacing.sm,
        ),
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.md,
          horizontal: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.sidebarActive : Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: isSelected
              ? Border.all(color: AppColors.accent.withOpacity(0.3), width: 1)
              : null,
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 24,
              color: isSelected ? AppColors.accent : AppColors.textMuted,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              category.arabicName ?? "",
              textAlign: TextAlign.center,
              style: GoogleFonts.cairo(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? AppColors.accent : AppColors.textSecondary,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

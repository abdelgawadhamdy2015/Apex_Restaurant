import 'package:apex_restaurant/core/themes/app_colors.dart';
import 'package:apex_restaurant/core/themes/app_spacing_theme.dart';
import 'package:flutter/material.dart';

class CustomBottomNavItem extends BottomNavigationBarItem {
  CustomBottomNavItem({
    required IconData icon,
    required String label,
    required ThemeData theme,
    required AppSpacing spacing,
  }) : super(
         icon: _buildItemContainer(
           icon: icon,
           label: label,
           backgroundColor: theme.colorScheme.surface,
           foregroundColor: theme.colorScheme.onPrimary,
           borderRadius: spacing.sm,
           theme: theme,
         ),
         activeIcon: _buildItemContainer(
           icon: icon,
           label: label,
           backgroundColor: theme.colorScheme.secondary,
           foregroundColor: AppColors.white,
           borderRadius: spacing.sm,
           theme: theme,
         ),
         label: "",
       );

  static Widget _buildItemContainer({
    required IconData icon,
    required String label,
    required Color backgroundColor,
    required Color foregroundColor,
    required double borderRadius,
    required ThemeData theme,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: foregroundColor),
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(color: foregroundColor),
          ),
        ],
      ),
    );
  }
}

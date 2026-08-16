import '../../../../core/helpers/extensions.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/themes/app_spacing_theme.dart';
import '../../../../generated/l10n.dart';
import 'package:flutter/material.dart';

class PosBottomNavBar extends StatelessWidget {
  const PosBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final lang = S.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.onSurface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(spacing.radiusPill),
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: theme.colorScheme.secondary,
        unselectedItemColor: theme.colorScheme.onSecondary,
        items: [
          _buildNavItem(
            icon: Icons.more_horiz,
            label: lang.more,
            theme: theme,
            spacing: spacing,
          ),
          _buildNavItem(
            icon: Icons.receipt_long_outlined,
            label: lang.navOrders,
            theme: theme,
            spacing: spacing,
          ),
          _buildNavItem(
            icon: Icons.restaurant_outlined,
            label: lang.navMenu,
            theme: theme,
            spacing: spacing,
          ),
        ],
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem({
    required IconData icon,
    required String label,
    required ThemeData theme,
    required AppSpacing spacing,
  }) {
    return BottomNavigationBarItem(
      icon: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 04),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(spacing.sm),
        ),
        child: Column(
          children: [
            Icon(icon, color: theme.colorScheme.onPrimary),
            Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onPrimary,
              ),
            ),
          ],
        ),
      ),
      activeIcon: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 04),
        decoration: BoxDecoration(
          color: theme.colorScheme.secondary,
          borderRadius: BorderRadius.circular(spacing.sm),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.white),
            Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.white,
              ),
            ),
          ],
        ),
      ),
      label: "",
    );
  }
}

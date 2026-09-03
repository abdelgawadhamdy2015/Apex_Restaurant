import 'package:apex_restaurant/core/helpers/extensions.dart';
import 'package:apex_restaurant/core/themes/app_colors.dart';
import 'package:apex_restaurant/core/themes/app_spacing_theme.dart';
import 'package:apex_restaurant/featchers/pos/presentation/pages/pos_page.dart';
import 'package:apex_restaurant/generated/l10n.dart';
import 'package:flutter/material.dart';

class PosBottomNavBar extends StatelessWidget {
  const PosBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  final PosBottomNavEnm currentIndex;
  final ValueChanged<PosBottomNavEnm> onTap;
  final List<PosBottomNavEnm> items;

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
        currentIndex: items.indexOf(currentIndex),
        onTap: (index) => onTap(items[index]),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: theme.colorScheme.secondary,
        unselectedItemColor: theme.colorScheme.onSecondary,
        items: items.map((item) {
          return _buildNavItem(
            item: item,
            label: _getLabel(item, lang),
            icon: _getIcon(item),
            theme: theme,
            spacing: spacing,
          );
        }).toList(),
      ),
    );
  }

  IconData _getIcon(PosBottomNavEnm item) {
    switch (item) {
      case PosBottomNavEnm.menu:
        return Icons.restaurant_outlined;

      case PosBottomNavEnm.orders:
        return Icons.receipt_long_outlined;

      case PosBottomNavEnm.customers:
        return Icons.people_outline;

      case PosBottomNavEnm.tables:
        return Icons.table_restaurant_outlined;

      case PosBottomNavEnm.more:
        return Icons.more_horiz;
    }
  }

  String _getLabel(PosBottomNavEnm item, S lang) {
    switch (item) {
      case PosBottomNavEnm.menu:
        return lang.navMenu;

      case PosBottomNavEnm.orders:
        return lang.navOrders;

      case PosBottomNavEnm.customers:
        return lang.customers;

      case PosBottomNavEnm.tables:
        return lang.tables;

      case PosBottomNavEnm.more:
        return lang.more;
    }
  }

  BottomNavigationBarItem _buildNavItem({
    required PosBottomNavEnm item,
    required IconData icon,
    required String label,
    required ThemeData theme,
    required AppSpacing spacing,
  }) {
    return BottomNavigationBarItem(
      icon: _buildItem(
        icon: icon,
        label: label,
        theme: theme,
        spacing: spacing,
        isSelected: false,
      ),
      activeIcon: _buildItem(
        icon: icon,
        label: label,
        theme: theme,
        spacing: spacing,
        isSelected: true,
      ),
      label: '',
    );
  }

  Widget _buildItem({
    required IconData icon,
    required String label,
    required ThemeData theme,
    required AppSpacing spacing,
    required bool isSelected,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: isSelected
            ? theme.colorScheme.secondary
            : theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(spacing.sm),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? AppColors.white : theme.colorScheme.onPrimary,
          ),
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isSelected ? AppColors.white : theme.colorScheme.onPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

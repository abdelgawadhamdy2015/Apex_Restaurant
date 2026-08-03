import 'package:apex_restaurant/core/helpers/extensions.dart';
import 'package:apex_restaurant/featchers/cart/presentation/bloc/cart_bloc.dart';
import 'package:apex_restaurant/featchers/cart/presentation/bloc/cart_event.dart';
import 'package:apex_restaurant/featchers/cart/presentation/bloc/cart_state.dart';
import 'package:apex_restaurant/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Horizontal row of chips letting the user pick the order type
/// (takeaway, dine-in, delivery or delivery company).
class OrderTypeSelector extends StatelessWidget {
  const OrderTypeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    final lang = S.of(context);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _OrderTypeChip(
            type: OrderType.takeaway,
            label: lang.takeaway,
            icon: Icons.shopping_bag_outlined,
          ),
          SizedBox(width: spacing.xs),
          _OrderTypeChip(
            type: OrderType.dineIn,
            label: lang.dineIn,
            icon: Icons.restaurant,
          ),
          SizedBox(width: spacing.xs),
          _OrderTypeChip(
            type: OrderType.delivery,
            label: lang.delivery,
            icon: Icons.two_wheeler,
          ),
          SizedBox(width: spacing.xs),
          _OrderTypeChip(
            type: OrderType.deliveryCompany,
            label: lang.deliveryCompanies,
            icon: Icons.storefront,
          ),
        ],
      ),
    );
  }
}

class _OrderTypeChip extends StatelessWidget {
  const _OrderTypeChip({
    required this.type,
    required this.label,
    required this.icon,
  });

  final OrderType type;
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final icons = context.iconSizes;
    final isSelected = context.select(
      (CartBloc b) => b.state.selectedOrderType == type,
    );

    final activeColor = theme.colorScheme.primary;
    final inactiveColor = theme.colorScheme.surfaceContainerHighest;
    final activeTextColor = theme.colorScheme.onPrimary;
    final inactiveTextColor = theme.colorScheme.onSurfaceVariant;

    return InkWell(
      onTap: () => context.read<CartBloc>().add(ChangeOrderTypeEvent(type)),
      borderRadius: BorderRadius.circular(spacing.radiusPill),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: spacing.md,
          vertical: spacing.xs,
        ),
        decoration: BoxDecoration(
          color: isSelected ? activeColor : inactiveColor,
          borderRadius: BorderRadius.circular(spacing.radiusPill),
          border: Border.all(
            color: isSelected ? activeColor : theme.colorScheme.outlineVariant,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: icons.sm,
              color: isSelected ? activeTextColor : inactiveTextColor,
            ),
            SizedBox(width: spacing.xxs + spacing.xxs / 2),
            Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: isSelected ? activeTextColor : inactiveTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:apex_restaurant/core/helpers/extensions.dart';
import 'package:apex_restaurant/core/themes/app_colors.dart';
import 'package:apex_restaurant/featchers/orders/data/model/order_model.dart';
import 'package:apex_restaurant/featchers/orders/presentation/bloc/orders_bloc.dart';
import 'package:apex_restaurant/featchers/orders/presentation/bloc/orders_event.dart';
import 'package:apex_restaurant/featchers/orders/presentation/bloc/orders_state.dart';
import 'package:apex_restaurant/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Segmented control used to switch between "Held" and "Previous" order tabs.
class OrdersSegmentedTab extends StatelessWidget {
  final OrdersState state;
  final S l10n;

  const OrdersSegmentedTab({
    super.key,
    required this.state,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;

    return Container(
      padding: EdgeInsets.all(spacing.xxs),
      decoration: BoxDecoration(
        color: context.appExtraTheme.togelBackground,
        borderRadius: BorderRadius.circular(spacing.radiusSm),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () =>
                  context.read<OrdersBloc>().add(SwitchTabEvent(OrderTab.held)),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: spacing.xxs),
                decoration: BoxDecoration(
                  color: state.activeTab == OrderTab.held
                      ? theme.colorScheme.primary
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(spacing.radiusLg),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      l10n.heldOrders,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: state.activeTab == OrderTab.held
                            ? AppColors.white
                            : theme.colorScheme.onSecondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: spacing.xs),

                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.secondary,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '3',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSecondary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => context.read<OrdersBloc>().add(
                SwitchTabEvent(OrderTab.previous),
              ),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: spacing.xs),
                decoration: BoxDecoration(
                  color: state.activeTab == OrderTab.previous
                      ? theme.colorScheme.primary
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(spacing.radiusLg),
                ),
                child: Text(
                  l10n.previousOrders,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: state.activeTab == OrderTab.previous
                        ? AppColors.white
                        : theme.colorScheme.onSecondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

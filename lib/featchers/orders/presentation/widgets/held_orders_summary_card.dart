import 'package:apex_restaurant/core/helpers/extensions.dart';
import 'package:apex_restaurant/generated/l10n.dart';
import 'package:flutter/material.dart';

/// Header card on the "Held Orders" tab showing the total held-order count.
class HeldOrdersSummaryCard extends StatelessWidget {
  final int totalCount;
  final S l10n;

  const HeldOrdersSummaryCard({
    super.key,
    required this.totalCount,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final iconSizes = context.iconSizes;

    return Container(
      padding: EdgeInsets.all(spacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.onSurface,
        borderRadius: BorderRadius.circular(spacing.radiusLg),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.totalHeldOrders,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSecondary,
                ),
              ),
              Text(
                l10n.ordersCount(totalCount),
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.all(spacing.md),
            decoration: BoxDecoration(
              color: theme.colorScheme.secondary.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.hourglass_empty_rounded,
              color: theme.colorScheme.secondary,
              size: iconSizes.lg,
            ),
          ),
        ],
      ),
    );
  }
}

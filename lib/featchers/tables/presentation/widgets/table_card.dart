import 'package:apex_restaurant/core/helpers/extensions.dart';
import 'package:apex_restaurant/featchers/pos/data/enums/table_status.dart';
import 'package:apex_restaurant/featchers/tables/domain/entities/table_entity.dart';
import 'package:apex_restaurant/generated/l10n.dart';
import 'package:flutter/material.dart';

class TableCard extends StatelessWidget {
  const TableCard({super.key, required this.table});

  final TableEntity table;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final iconSizes = context.iconSizes;
    final l10n = S.of(context);
    final isAvailable = table.status == TableStatus.available;

    return Container(
      padding: EdgeInsets.all(spacing.sm),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(spacing.radiusLg),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            height: 60,
            width: 90,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(spacing.radiusSm),
              border: Border.all(
                color: isAvailable
                    ? Colors.blue.shade300
                    : Colors.purple.shade200,
                width: 2,
              ),
            ),
          ),
          Text(
            '${l10n.table} ${table.arabicName}',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.people_outline,
                size: iconSizes.xs,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              SizedBox(width: spacing.xxs),
              Text(
                '${table.seatNumbers} ${l10n.seats}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: spacing.sm,
              vertical: spacing.xxs,
            ),
            decoration: BoxDecoration(
              color: isAvailable ? Colors.green.shade50 : Colors.red.shade50,
              borderRadius: BorderRadius.circular(spacing.radiusLg),
            ),
            child: Text(
              isAvailable ? l10n.available : l10n.reserved,
              style: theme.textTheme.labelSmall?.copyWith(
                color: isAvailable ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

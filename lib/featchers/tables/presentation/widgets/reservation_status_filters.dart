import 'package:apex_restaurant/core/helpers/extensions.dart';
import 'package:apex_restaurant/featchers/tables/domain/entities/reservation_entity.dart';
import 'package:apex_restaurant/generated/l10n.dart';
import 'package:flutter/material.dart';

class ReservationStatusFilters extends StatelessWidget {
  const ReservationStatusFilters({
    super.key,
    required this.selectedIndex,
    required this.reservations,
    required this.onFilterChanged,
  });

  final int selectedIndex;
  final List<ReservationEntity> reservations;
  final ValueChanged<int> onFilterChanged;

  List<String> _labels(S l10n) => [
    l10n.all,
    l10n.pending,
    l10n.confirmed,
    l10n.cancelled,
  ];

  int _countFor(int index) {
    switch (index) {
      case 0:
        return reservations.length;
      case 1:
        return reservations
            .where((r) => r.status == ReservationStatus.pending)
            .length;
      case 2:
        return reservations
            .where((r) => r.status == ReservationStatus.confirmed)
            .length;
      default:
        return reservations
            .where((r) => r.status == ReservationStatus.cancelled)
            .length;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final labels = _labels(S.of(context));

    return Container(
      padding: EdgeInsets.all(spacing.xxs),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withOpacity(0.2),
        borderRadius: BorderRadius.circular(spacing.radiusLg),
      ),
      child: Row(
        children: List.generate(labels.length, (index) {
          return Expanded(
            child: _FilterTab(
              label: labels[index],
              count: _countFor(index),
              isSelected: selectedIndex == index,
              onTap: () => onFilterChanged(index),
            ),
          );
        }),
      ),
    );
  }
}

class _FilterTab extends StatelessWidget {
  const _FilterTab({
    required this.label,
    required this.count,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final int count;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: spacing.xs),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.onSurfaceVariant.withOpacity(0.5)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(spacing.radiusLg),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: isSelected
                    ? Colors.white
                    : theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '($count)',
              style: theme.textTheme.labelSmall?.copyWith(
                color: isSelected
                    ? Colors.white
                    : theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

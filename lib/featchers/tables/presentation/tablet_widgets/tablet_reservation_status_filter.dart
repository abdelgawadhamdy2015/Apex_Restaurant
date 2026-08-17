import 'package:flutter/material.dart';
import '../../../../core/helpers/extensions.dart';
import '../../../../generated/l10n.dart';
import '../../domain/entities/reservation_entity.dart';

class TabletReservationStatusFilters extends StatelessWidget {
  const TabletReservationStatusFilters({
    super.key,
    required this.selectedIndex,
    required this.reservations,
    required this.onFilterChanged,
  });

  final int selectedIndex;
  final List<ReservationEntity> reservations;
  final ValueChanged<int> onFilterChanged;

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    final l10n = S.of(context);

    final allCount = reservations.length;
    final pendingCount = reservations
        .where((r) => r.status == ReservationStatus.pending)
        .length;
    final confirmedCount = reservations
        .where((r) => r.status == ReservationStatus.confirmed)
        .length;
    final cancelledCount = reservations
        .where((r) => r.status == ReservationStatus.cancelled)
        .length;

    final filters = [
      {'label': '${l10n.all} ($allCount)', 'index': 0},
      {'label': '${l10n.pending} ($pendingCount)', 'index': 1},
      {'label': '${l10n.confirmed} ($confirmedCount)', 'index': 2},
      {'label': '${l10n.cancelled} ($cancelledCount)', 'index': 3},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: filters.map((filter) {
        final index = filter['index'] as int;
        final isSelected = selectedIndex == index;

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: spacing.xs),
          child: ChoiceChip(
            label: Text(filter['label'] as String),
            selected: isSelected,
            onSelected: (_) => onFilterChanged(index),
            selectedColor: const Color(0xFF64748B),
            backgroundColor: const Color(0xFFF1F5F9),
            labelStyle: TextStyle(
              color: isSelected ? Colors.white : const Color(0xFF475569),
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(spacing.radiusLg),
            ),
            showCheckmark: false,
          ),
        );
      }).toList(),
    );
  }
}

import 'package:apex_restaurant/core/helpers/extensions.dart';
import 'package:apex_restaurant/featchers/tables/domain/entities/reservation_entity.dart';
import 'package:apex_restaurant/featchers/tables/presentation/bloc/tables_bloc.dart';
import 'package:apex_restaurant/featchers/tables/presentation/bloc/tables_event.dart';
import 'package:apex_restaurant/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReservationItemCard extends StatelessWidget {
  const ReservationItemCard({super.key, required this.reservation});

  final ReservationEntity reservation;

  (Color, String) _statusInfo(S l10n) {
    switch (reservation.status) {
      case ReservationStatus.confirmed:
        return (Colors.green, l10n.confirmed);
      case ReservationStatus.cancelled:
        return (Colors.red.shade300, l10n.cancelled);
      default:
        return (Colors.amber, l10n.pending);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final iconSizes = context.iconSizes;
    final lang = S.of(context);
    final isCancelled = reservation.status == ReservationStatus.cancelled;
    final (statusColor, statusText) = _statusInfo(lang);

    final formattedDate =
        '${reservation.dateTime.hour.toString().padLeft(2, '0')}:${reservation.dateTime.minute.toString().padLeft(2, '0')} • '
        '${reservation.dateTime.year}-${reservation.dateTime.month.toString().padLeft(2, '0')}-${reservation.dateTime.day.toString().padLeft(2, '0')}';

    return Container(
      padding: EdgeInsets.all(spacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(spacing.radiusLg),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _TableInfo(
                tableNumber: reservation.tableNumber,
                formattedDate: formattedDate,
              ),
              _StatusBadge(color: statusColor, label: statusText),
            ],
          ),
          Divider(height: spacing.lg, color: theme.colorScheme.outlineVariant),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _InfoColumn(
                crossAxisAlignment: CrossAxisAlignment.start,
                label: lang.customerName,
                value: reservation.customerName,
              ),
              _InfoColumn(
                crossAxisAlignment: CrossAxisAlignment.start,
                label: lang.seatsAndDurationHeader,
                value:
                    '${reservation.seatsCount} ${lang.seats} / ${reservation.durationHours} ${lang.hour}',
              ),
            ],
          ),
          SizedBox(height: spacing.md),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: Icon(
                    Icons.edit_outlined,
                    color: theme.colorScheme.primary,
                    size: iconSizes.xs,
                  ),
                  label: Text(
                    lang.edit,
                    style: TextStyle(color: theme.colorScheme.primary),
                  ),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primaryContainer
                        .withOpacity(0.2),
                    side: BorderSide.none,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(spacing.radiusLg),
                    ),
                  ),
                ),
              ),
              SizedBox(width: spacing.sm),

              Expanded(
                child: OutlinedButton.icon(
                  onPressed: isCancelled
                      ? null
                      : () => context.read<TablesBloc>().add(
                          CancelReservationEvent(reservation.id),
                        ),
                  icon: Icon(
                    Icons.close,
                    color: isCancelled ? Colors.grey : Colors.red,
                    size: iconSizes.xs,
                  ),
                  label: Text(
                    isCancelled ? lang.cancelled : lang.cancel,
                    style: TextStyle(
                      color: isCancelled ? Colors.grey : Colors.red,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: isCancelled
                        ? Colors.grey.shade100
                        : Colors.red.shade50,
                    side: BorderSide.none,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(spacing.radiusLg),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: spacing.sm,
        vertical: spacing.xxs,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(spacing.radiusLg),
      ),
      child: Row(
        children: [
          CircleAvatar(radius: 4, backgroundColor: color),
          SizedBox(width: spacing.xxs),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _TableInfo extends StatelessWidget {
  const _TableInfo({required this.tableNumber, required this.formattedDate});

  final String tableNumber;
  final String formattedDate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;

    return Row(
      children: [
        CircleAvatar(
          backgroundColor: theme.colorScheme.primaryContainer.withOpacity(0.4),
          child: Text(
            tableNumber.replaceAll(RegExp(r'[^0-9]'), ''),
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(width: spacing.xs),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tableNumber,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              formattedDate,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _InfoColumn extends StatelessWidget {
  const _InfoColumn({
    required this.crossAxisAlignment,
    required this.label,
    required this.value,
  });

  final CrossAxisAlignment crossAxisAlignment;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

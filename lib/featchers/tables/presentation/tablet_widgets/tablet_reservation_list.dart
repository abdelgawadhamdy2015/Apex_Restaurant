import 'package:apex_restaurant/core/helpers/restaurant_constants.dart';
import 'package:flutter/material.dart';
import '../../../../core/helpers/extensions.dart';
import '../../../../generated/l10n.dart';
import '../../domain/entities/reservation_entity.dart';

class TabletReservationCardsList extends StatelessWidget {
  const TabletReservationCardsList({super.key, required this.reservations});

  final List<ReservationEntity> reservations;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final l10n = S.of(context);

    if (reservations.isEmpty) {
      return Center(
        child: Text(l10n.noResultsFound, style: theme.textTheme.bodyMedium),
      );
    }

    return Column(
      children: [
        // Table Header
        Container(
          color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
          padding: EdgeInsets.symmetric(
            horizontal: spacing.lg,
            vertical: spacing.md,
          ),
          child: Row(
            children: [
              _buildHeaderCell(l10n.table, flex: 2),
              _buildHeaderCell(l10n.date, flex: 2),
              _buildHeaderCell(l10n.time, flex: 2),
              _buildHeaderCell(l10n.customerName, flex: 3),
              _buildHeaderCell(l10n.seats, flex: 2),
              _buildHeaderCell(l10n.duration, flex: 2),
              _buildHeaderCell(l10n.status, flex: 2),
              _buildHeaderCell(l10n.actions, flex: 2, center: true),
            ],
          ),
        ),
        const Divider(height: 1),

        // Table Body
        Expanded(
          child: ListView.separated(
            itemCount: reservations.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final reservation = reservations[index];
              return Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: spacing.lg,
                  vertical: spacing.sm,
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        reservation.tableNumber,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        RestaurantConstants.dateFormat.format(
                          reservation.dateTime,
                        ),
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        RestaurantConstants.hoursFormat.format(
                          reservation.dateTime,
                        ),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFF0284C7),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        reservation.customerName,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        '${reservation.seatsCount}',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        '${reservation.durationMinutes}',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: _buildStatusBadge(context, reservation.status),
                    ),
                    Expanded(
                      flex: 2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildActionButton(
                            icon: Icons.edit_outlined,
                            color: const Color(0xFF0284C7),
                            bgColor: const Color(0xFFE0F2FE),
                            onTap: () {},
                          ),
                          SizedBox(width: spacing.xs),
                          _buildActionButton(
                            icon: Icons.delete_outline,
                            color: const Color(0xFFDC2626),
                            bgColor: const Color(0xFFFEE2E2),
                            onTap: () {},
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderCell(
    String title, {
    required int flex,
    bool center = false,
  }) {
    return Expanded(
      flex: flex,
      child: Text(
        title,
        textAlign: center ? TextAlign.center : TextAlign.start,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context, ReservationStatus status) {
    Color textColor;
    Color bgColor;
    String label;

    switch (status) {
      case ReservationStatus.pending:
        textColor = const Color(0xFFD97706);
        bgColor = const Color(0xFFFEF3C7);
        label = 'في الانتظار';
        break;
      case ReservationStatus.confirmed:
        textColor = const Color(0xFF16A34A);
        bgColor = const Color(0xFFDCFCE7);
        label = 'مؤكد';
        break;
      case ReservationStatus.cancelled:
        textColor = const Color(0xFFE11D48);
        bgColor = const Color(0xFFFFE4E6);
        label = 'ملغي';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(radius: 3, backgroundColor: textColor),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required Color bgColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 16, color: color),
      ),
    );
  }
}

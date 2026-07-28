import 'package:apex_restaurant/core/helpers/extensions.dart';
import 'package:apex_restaurant/featchers/tables/domain/entities/reservation_entity.dart';
import 'package:apex_restaurant/generated/l10n.dart';
import 'package:flutter/material.dart';

import 'reservation_item_card.dart';

class ReservationCardsList extends StatelessWidget {
  const ReservationCardsList({super.key, required this.reservations});

  final List<ReservationEntity> reservations;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final l10n = S.of(context);

    if (reservations.isEmpty) {
      return Padding(
        padding: EdgeInsets.all(spacing.lg),
        child: Text(l10n.noReservations, style: theme.textTheme.bodyMedium),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: reservations.length,
      separatorBuilder: (_, _) => SizedBox(height: spacing.md),
      itemBuilder: (context, index) =>
          ReservationItemCard(reservation: reservations[index]),
    );
  }
}

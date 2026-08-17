import 'package:apex_restaurant/featchers/tables/domain/entities/reservation_entity.dart';
import 'package:apex_restaurant/featchers/tables/presentation/tablet_widgets/tablet_add_customer_sheet.dart';
import 'package:apex_restaurant/featchers/tables/presentation/tablet_widgets/tablet_reservation_list.dart';
import 'package:apex_restaurant/featchers/tables/presentation/tablet_widgets/tablet_reservation_search_filter.dart';
import 'package:apex_restaurant/featchers/tables/presentation/tablet_widgets/tablet_reservation_status_filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/helpers/extensions.dart';
import '../../../../generated/l10n.dart';
import '../../../cart/data/models/pos_client_model.dart';
import '../../domain/entities/table_entity.dart';
import '../bloc/tables_bloc.dart';
import '../bloc/tables_event.dart';
import '../bloc/tables_state.dart';

class ReservationsTabletView extends StatefulWidget {
  const ReservationsTabletView({
    super.key,
    required this.tables,
    required this.personList,
  });

  final List<TableEntity> tables;
  final List<PosClientModel> personList;

  @override
  State<ReservationsTabletView> createState() => _ReservationsTabletViewState();
}

class _ReservationsTabletViewState extends State<ReservationsTabletView> {
  int _selectedStatusIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final l10n = S.of(context);

    return BlocBuilder<TablesBloc, TablesState>(
      builder: (context, state) {
        final filteredReservations = _filterByStatus(
          state.reservations,
          _selectedStatusIndex,
        );

        return Column(
          children: [
            // Top Action & Search Bar Area
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Add Reservation Yellow Button
                SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      TabletAddReservationBottomSheet.show(
                        context,
                        widget.tables,
                        widget.personList,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFEAB308),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(spacing.radiusMd),
                      ),
                      elevation: 0,
                      padding: EdgeInsets.symmetric(horizontal: spacing.md),
                    ),
                    child: Text(
                      l10n.addNewReservation,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: spacing.md),

                // Filter Fields (Floor, Customer, Date Range, Search)
                Expanded(
                  child: TabletReservationSearchFilterCard(
                    tables: widget.tables,
                    clients: widget.personList,
                    onSearch: (request) {
                      context.read<TablesBloc>().add(
                        FetchReservationsEvent(request),
                      );
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: spacing.md),

            // Filter Chips (All, Pending, Confirmed, Cancelled/Passed)
            TabletReservationStatusFilters(
              selectedIndex: _selectedStatusIndex,
              reservations: state.reservations,
              onFilterChanged: (index) {
                setState(() => _selectedStatusIndex = index);
              },
            ),
            SizedBox(height: spacing.md),

            // Reservations Data Table Container
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(spacing.radiusLg),
                  border: Border.all(color: theme.colorScheme.outlineVariant),
                ),
                child: state.status == TablesStatus.loading
                    ? const Center(child: CircularProgressIndicator())
                    : TabletReservationCardsList(
                        reservations: filteredReservations,
                      ),
              ),
            ),
          ],
        );
      },
    );
  }

  List<ReservationEntity> _filterByStatus(
    List<ReservationEntity> reservations,
    int filterIndex,
  ) {
    if (filterIndex == 0) return reservations;
    // Map index according to your status enum definitions:
    // 1: Pending (في الانتظار)
    // 2: Confirmed (مؤكد)
    // 3: Passed/Cancelled (ملغي)
    return reservations.where((res) {
      if (filterIndex == 1) return res.status == ReservationStatus.pending;
      if (filterIndex == 2) return res.status == ReservationStatus.confirmed;
      if (filterIndex == 3) return res.status == ReservationStatus.cancelled;
      return true;
    }).toList();
  }
}

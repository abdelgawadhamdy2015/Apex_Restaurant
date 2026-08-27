import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/helpers/extensions.dart';
import '../../../cart/data/models/pos_client_model.dart';
import '../../data/models/get_reservations_request.dart';
import '../../domain/entities/reservation_entity.dart';
import '../bloc/tables_bloc.dart';
import '../bloc/tables_event.dart';
import '../bloc/tables_state.dart';
import 'add_reservation_bottom_sheet.dart';
import 'add_reservation_button.dart';
import 'reservation_cards_list.dart';
import 'reservation_search_filter_card.dart';
import 'reservation_status_filters.dart';

class ReservationsTabView extends StatefulWidget {
  const ReservationsTabView({super.key, required this.personList});

  final List<PosClientModel> personList;

  @override
  State<ReservationsTabView> createState() => _ReservationsTabViewState();
}

class _ReservationsTabViewState extends State<ReservationsTabView> {
  int _selectedFilterIndex = 0;
  bool _searchFilterOpen = true;

  List<ReservationEntity> _filterReservations(
    List<ReservationEntity> reservations,
  ) {
    const statusByFilterIndex = {
      1: ReservationStatus.pending,
      2: ReservationStatus.confirmed,
      3: ReservationStatus.cancelled,
    };
    final status = statusByFilterIndex[_selectedFilterIndex];
    if (status == null) return reservations;
    return reservations.where((r) => r.status == status).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;

    // Narrow selectors so this widget only rebuilds when one of these
    // specific fields changes, instead of on every TablesBloc emission.
    final floors = context.select((TablesBloc b) => b.state.floors);
    final tables = context.select((TablesBloc b) => b.state.tables);
    final reservations = context.select((TablesBloc b) => b.state.reservations);
    final isLoading = context.select(
      (TablesBloc b) => b.state.status == TablesStatus.loading,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: AddReservationButton(
                onPressed: () {
                  AddReservationBottomSheet.show(
                    context,
                    tables,
                    widget.personList,
                  );
                },
              ),
            ),
            SizedBox(width: spacing.sm),

            // Toggle button: show/hide the search filter card
            SizedBox(
              height: 50,
              width: 50,
              child: Tooltip(
                message: _searchFilterOpen ? 'Hide filters' : 'Show filters',
                child: OutlinedButton(
                  onPressed: () =>
                      setState(() => _searchFilterOpen = !_searchFilterOpen),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    backgroundColor: _searchFilterOpen
                        ? theme.colorScheme.primary.withOpacity(.1)
                        : null,
                    side: BorderSide(color: theme.colorScheme.outlineVariant),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(spacing.radiusLg),
                    ),
                  ),
                  child: Icon(
                    _searchFilterOpen
                        ? Icons.filter_alt_outlined
                        : Icons.filter_alt_off_outlined,
                    color: _searchFilterOpen
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onPrimary,
                  ),
                ),
              ),
            ),
          ],
        ),
        if (_searchFilterOpen) ...[
          SizedBox(height: spacing.xxs),
          ReservationSearchFilterCard(
            floors: floors,
            clients: widget.personList,
            onSearch: (GetReservationRequest request) {
              context.read<TablesBloc>().add(FetchReservationsEvent(request));
            },
          ),
        ],
        SizedBox(height: spacing.xxs),
        ReservationStatusFilters(
          selectedIndex: _selectedFilterIndex,
          reservations: reservations,
          onFilterChanged: (index) =>
              setState(() => _selectedFilterIndex = index),
        ),
        SizedBox(height: spacing.xxs),
        if (isLoading)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 48.0),
            child: Center(child: CircularProgressIndicator()),
          )
        else
          ReservationCardsList(reservations: _filterReservations(reservations)),
      ],
    );
  }
}

import 'package:apex_restaurant/core/helpers/extensions.dart';
import 'package:apex_restaurant/core/shared/widgets/custom_app_bar.dart';
import 'package:apex_restaurant/featchers/cart/data/models/pos_client_model.dart';
import 'package:apex_restaurant/featchers/tables/data/models/get_floor_request.dart';
import 'package:apex_restaurant/featchers/tables/data/models/get_reservations_request.dart';
import 'package:apex_restaurant/featchers/tables/data/models/get_table_request.dart';
import 'package:apex_restaurant/featchers/tables/domain/entities/floor_entity.dart';
import 'package:apex_restaurant/featchers/tables/domain/entities/reservation_entity.dart';
import 'package:apex_restaurant/featchers/tables/presentation/bloc/tables_bloc.dart';
import 'package:apex_restaurant/featchers/tables/presentation/bloc/tables_event.dart';
import 'package:apex_restaurant/featchers/tables/presentation/bloc/tables_state.dart';
import 'package:apex_restaurant/featchers/tables/presentation/widgets/add_reservation_bottom_sheet.dart';
import 'package:apex_restaurant/featchers/tables/presentation/widgets/add_reservation_button.dart';
import 'package:apex_restaurant/featchers/tables/presentation/widgets/floor_selector.dart';
import 'package:apex_restaurant/featchers/tables/presentation/widgets/main_segmented_tab.dart';
import 'package:apex_restaurant/featchers/tables/presentation/widgets/reservation_cards_list.dart';
import 'package:apex_restaurant/featchers/tables/presentation/widgets/reservation_search_filter_card.dart';
import 'package:apex_restaurant/featchers/tables/presentation/widgets/reservation_status_filters.dart';
import 'package:apex_restaurant/featchers/tables/presentation/widgets/tables_grid.dart';
import 'package:apex_restaurant/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TablesScreen extends StatefulWidget {
  const TablesScreen({
    super.key,
    required this.branchId,
    required this.personList,
  });
  final int branchId;
  final List<PosClientModel> personList;

  @override
  State<TablesScreen> createState() => _TablesScreenState();
}

class _TablesScreenState extends State<TablesScreen> {
  int _selectedFloorIndex = 0;
  int _selectedFilterIndex = 0;

  @override
  void initState() {
    super.initState();
    final bloc = context.read<TablesBloc>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      bloc.add(FetchFloorsEvent(GetFloorsRequest(branchId: widget.branchId)));
    });
  }

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

  void _onFloorSelected(int index, List<FloorEntity> floors) {
    setState(() => _selectedFloorIndex = index);
    if (floors.isNotEmpty && index < floors.length) {
      final floor = floors[index];
      context.read<TablesBloc>().add(
        FetchTablesEvent(GetTablesRequest(floorID: floor.id, forPOS: true)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final l10n = S.of(context);

    return BlocConsumer<TablesBloc, TablesState>(
      listenWhen: (previous, current) =>
          previous.status != current.status ||
          previous.errorMessage != current.errorMessage,
      listener: (context, state) {
        if (state.status == TablesStatus.failure &&
            state.errorMessage != null &&
            state.errorMessage!.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: theme.colorScheme.error,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state.status == TablesStatus.loading;

        return Scaffold(
          backgroundColor: theme.colorScheme.surfaceContainerLowest,
          appBar: CustomAppBar(
            title: state.activeTab == 0 ? l10n.tables : l10n.reservations,
            onBackPressed: () => Navigator.of(context).maybePop(),
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(spacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                MainSegmentedTab(
                  activeTab: state.activeTab,
                  onTabChanged: (tab) =>
                      context.read<TablesBloc>().add(SwitchMainTabEvent(tab)),
                ),
                SizedBox(height: spacing.md),

                if (state.activeTab == 0) ...[
                  FloorSelector(
                    floors: state.floors,
                    selectedIndex: _selectedFloorIndex,
                    onFloorSelected: (index) =>
                        _onFloorSelected(index, state.floors),
                  ),
                  SizedBox(height: spacing.md),
                  if (isLoading && state.tables.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 48.0),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else
                    TablesGrid(tables: state.tables),
                ] else ...[
                  AddReservationButton(
                    onPressed: () => AddReservationBottomSheet.show(
                      context,
                      state.tables,
                      widget.personList,
                    ),
                  ),
                  SizedBox(height: spacing.md),
                  ReservationSearchFilterCard(
                    floors: state.floors,
                    onSearch: () {
                      context.read<TablesBloc>().add(
                        FetchReservationsEvent(
                          const GetReservationRequest(
                            pageSize: 20,
                            pageNumber: 1,
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: spacing.md),
                  ReservationStatusFilters(
                    selectedIndex: _selectedFilterIndex,
                    reservations: state.reservations,
                    onFilterChanged: (index) =>
                        setState(() => _selectedFilterIndex = index),
                  ),
                  SizedBox(height: spacing.md),
                  if (isLoading)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 48.0),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else
                    ReservationCardsList(
                      reservations: _filterReservations(state.reservations),
                    ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

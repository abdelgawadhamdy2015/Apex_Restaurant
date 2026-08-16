import '../../../../core/helpers/extensions.dart';
import '../../../../core/helpers/helper_methods.dart';
import '../../../../core/shared/widgets/custom_app_bar.dart';
import '../../../cart/data/models/pos_client_model.dart';
import '../../data/models/get_floor_request.dart';
import '../../data/models/get_reservations_request.dart';
import '../../data/models/get_table_request.dart';
import '../../domain/entities/floor_entity.dart';
import '../../domain/entities/reservation_entity.dart';
import '../bloc/tables_bloc.dart';
import '../bloc/tables_event.dart';
import '../bloc/tables_state.dart';
import '../widgets/add_reservation_bottom_sheet.dart';
import '../widgets/add_reservation_button.dart';
import '../widgets/floor_selector.dart';
import '../widgets/main_segmented_tab.dart';
import '../widgets/reservation_cards_list.dart';
import '../widgets/reservation_search_filter_card.dart';
import '../widgets/reservation_status_filters.dart';
import '../widgets/tables_grid.dart';
import '../../../../generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TablesScreen extends StatefulWidget {
  const TablesScreen({
    super.key,
    required this.branchId,
    required this.personList,
    required this.inCartScreen,
  });
  final int branchId;
  final List<PosClientModel> personList;
  final bool inCartScreen;

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
      bloc.add(
        FetchFloorsEvent(
          GetFloorsRequest(
            branchId: widget.branchId,
            pageNumber: 1,
            pageSize: 100,
          ),
        ),
      );
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
        FetchTablesEvent(
          GetTablesRequest(
            pageNumber: 1,
            pageSize: 100,
            floorID: floor.id,
            forPOS: false,
          ),
        ),
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
          HelperMethods.showSnackBar(
            context: context,
            message: state.errorMessage!,
            isError: true,
          );
        }
      },
      builder: (context, state) {
        final isLoading = state.status == TablesStatus.loading;

        return Scaffold(
          backgroundColor: theme.colorScheme.surface,
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
                    TablesGrid(
                      tables: state.tables,
                      inCartScreen: widget.inCartScreen,
                    ),
                ] else ...[
                  AddReservationButton(
                    onPressed: () {
                      AddReservationBottomSheet.show(
                        context,
                        state.tables,
                        widget.personList,
                      );
                    },
                  ),
                  SizedBox(height: spacing.md),
                  ReservationSearchFilterCard(
                    tables: state.tables,
                    clients: widget.personList,
                    onSearch: (GetReservationRequest request) {
                      context.read<TablesBloc>().add(
                        FetchReservationsEvent(request),
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

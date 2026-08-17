import 'package:apex_restaurant/featchers/cart/presentation/bloc/cart_bloc.dart';
import 'package:apex_restaurant/featchers/tables/presentation/tablet_widgets/reservation_tablet_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/helpers/extensions.dart';
import '../../../../core/helpers/helper_methods.dart';
import '../../../cart/data/models/pos_client_model.dart';
import '../../data/models/get_floor_request.dart';
import '../../data/models/get_table_request.dart';
import '../../domain/entities/floor_entity.dart';
import '../../domain/entities/reservation_entity.dart';
import '../bloc/tables_bloc.dart';
import '../bloc/tables_event.dart';
import '../bloc/tables_state.dart';
import '../widgets/floor_selector.dart';
import '../widgets/main_segmented_tab.dart';
import '../tablet_widgets/tables_grid.dart';

class TablesTabletScreen extends StatefulWidget {
  const TablesTabletScreen({
    super.key,
    required this.branchId,
    required this.personList,
    required this.inCartScreen,
  });

  final int branchId;
  final List<PosClientModel> personList;
  final bool inCartScreen;

  @override
  State<TablesTabletScreen> createState() => _TablesTabletScreenState();
}

class _TablesTabletScreenState extends State<TablesTabletScreen> {
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
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(spacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Top Main Tab Control Bar (Tables vs Reservations)
                  Container(
                    height: 52,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(spacing.radiusLg),
                    ),
                    child: MainSegmentedTab(
                      activeTab: state.activeTab,
                      onTabChanged: (tab) => context.read<TablesBloc>().add(
                        SwitchMainTabEvent(tab),
                      ),
                    ),
                  ),
                  SizedBox(height: spacing.md),

                  // TAB 1: Tables Arrangement View
                  if (state.activeTab == 0) ...[
                    // Horizontal Floor Chips
                    SizedBox(
                      height: 44,
                      child: FloorSelector(
                        floors: state.floors,
                        selectedIndex: _selectedFloorIndex,
                        onFloorSelected: (index) =>
                            _onFloorSelected(index, state.floors),
                      ),
                    ),
                    SizedBox(height: spacing.lg),

                    // Grid Content Area
                    Expanded(
                      child: isLoading && state.tables.isEmpty
                          ? const Center(child: CircularProgressIndicator())
                          : SingleChildScrollView(
                              child: TablesGrid(
                                tables: state.tables,
                                inCartScreen: widget.inCartScreen,
                              ),
                            ),
                    ),
                  ]
                  // TAB 2: Reservations View
                  else ...[
                    // Search & Actions Bar
                    Expanded(
                      child: ReservationsTabletView(
                        tables: state.tables,
                        personList: context.read<CartBloc>().state.persons,
                      ),
                    ),
                    // Row(
                    //   children: [
                    //     Expanded(
                    //       child: ReservationSearchFilterCard(
                    //         tables: state.tables,
                    //         clients: widget.personList,
                    //         onSearch: (GetReservationRequest request) {
                    //           context.read<TablesBloc>().add(
                    //             FetchReservationsEvent(request),
                    //           );
                    //         },
                    //       ),
                    //     ),
                    //     SizedBox(width: spacing.md),
                    //     SizedBox(
                    //       height: 48,
                    //       child: AddReservationButton(
                    //         onPressed: () {
                    //           AddReservationBottomSheet.show(
                    //             context,
                    //             state.tables,
                    //             widget.personList,
                    //           );
                    //         },
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    // SizedBox(height: spacing.md),

                    // // Filter Status Pills
                    // ReservationStatusFilters(
                    //   selectedIndex: _selectedFilterIndex,
                    //   reservations: state.reservations,
                    //   onFilterChanged: (index) =>
                    //       setState(() => _selectedFilterIndex = index),
                    // ),
                    // SizedBox(height: spacing.md),

                    // // Reservations Grid
                    // Expanded(
                    //   child: isLoading
                    //       ? const Center(child: CircularProgressIndicator())
                    //       : SingleChildScrollView(
                    //           child: ReservationCardsList(
                    //             reservations: _filterReservations(
                    //               state.reservations,
                    //             ),
                    //           ),
                    //         ),
                    // ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

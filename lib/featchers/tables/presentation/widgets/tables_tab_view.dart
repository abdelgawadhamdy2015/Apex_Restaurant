import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/helpers/extensions.dart';
import '../../data/models/get_table_request.dart';
import '../../domain/entities/floor_entity.dart';
import '../bloc/tables_bloc.dart';
import '../bloc/tables_event.dart';
import '../bloc/tables_state.dart';
import 'floor_selector.dart';
import '../tablet_widgets/tables_grid.dart';

class TablesTabView extends StatefulWidget {
  const TablesTabView({super.key, required this.inCartScreen});

  final bool inCartScreen;

  @override
  State<TablesTabView> createState() => _TablesTabViewState();
}

class _TablesTabViewState extends State<TablesTabView> {
  int _selectedFloorIndex = 0;

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
    final spacing = context.spacing;

    // Narrow selectors so this widget only rebuilds when one of these
    // specific fields changes, instead of on every TablesBloc emission.
    final floors = context.select((TablesBloc b) => b.state.floors);
    final tables = context.select((TablesBloc b) => b.state.tables);
    final isLoading = context.select(
      (TablesBloc b) => b.state.status == TablesStatus.loading,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FloorSelector(
          floors: floors,
          selectedIndex: _selectedFloorIndex,
          onFloorSelected: (index) => _onFloorSelected(index, floors),
        ),
        SizedBox(height: spacing.xxs),
        if (isLoading && tables.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 48.0),
            child: Center(child: CircularProgressIndicator()),
          )
        else
          TablesGrid(tables: tables, inCartScreen: widget.inCartScreen),
      ],
    );
  }
}

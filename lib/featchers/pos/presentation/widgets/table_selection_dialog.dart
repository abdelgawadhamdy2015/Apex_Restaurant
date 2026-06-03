import 'package:apex_restaurant/core/helpers/restaurant_constants.dart';
import 'package:apex_restaurant/featchers/pos/data/enums/table_status.dart';
import 'package:apex_restaurant/featchers/pos/data/models/floor_model.dart';
import 'package:apex_restaurant/featchers/pos/data/models/table_model.dart';
import 'package:apex_restaurant/featchers/pos/presentation/bloc/pos_bloc.dart';
import 'package:apex_restaurant/featchers/pos/presentation/bloc/pos_event.dart';
import 'package:apex_restaurant/featchers/pos/presentation/bloc/pos_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class TableSelectionDialog extends StatefulWidget {
  const TableSelectionDialog({super.key});

  @override
  State<TableSelectionDialog> createState() => _TableSelectionDialogState();
}

class _TableSelectionDialogState extends State<TableSelectionDialog> {
  FloorModel? selectedFloor;
  List<FloorModel> floors = [];
  List<TableModel> tables = [];

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getFloors();
    });
  }

  void _getFloors() {
    context.read<PosBloc>().add(
      LoadFloorsEvent(branchId: RestaurantConstants.currentBranch?.branchId),
    );

    if (selectedFloor != null) {
      context.read<PosBloc>().add(
        LoadTablesEvent(floorID: selectedFloor!.id, forPOS: true),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: 950,
        height: 600,
        child: Row(
          children: [
            BlocBuilder<PosBloc, PosState>(
              builder: (context, state) {
                selectedFloor ??= state.floors.isNotEmpty
                    ? state.floors.first
                    : null;
                return Container(
                  width: 220,
                  color: Colors.grey.shade100,
                  child: Column(
                    children: state.floors
                        .map((floor) => _floorButton(floor))
                        .toList(),
                  ),
                );
              },
            ),
            if (selectedFloor != null)
              BlocBuilder<PosBloc, PosState>(
                builder: (context, state) {
                  return Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.all(20),
                      itemCount: state.tables.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                      itemBuilder: (_, index) {
                        final table = state.tables[index];

                        return InkWell(
                          onTap: () {
                            context.pop(context);
                            context.read<PosBloc>().add(
                              SelectTableEvent(table: table),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(border: Border.all()),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(_icon(table.status!), size: 40),
                                const SizedBox(height: 8),
                                Text(
                                  table.arabicName ?? "",
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _floorButton(FloorModel floor) {
    final selected = selectedFloor == floor;

    return InkWell(
      onTap: () {
        setState(() {
          selectedFloor = floor;
        });

        context.read<PosBloc>().add(
          LoadTablesEvent(floorID: floor.id, forPOS: true),
        );
      },
      child: Container(
        height: 70,
        margin: const EdgeInsets.all(8),
        alignment: Alignment.center,
        color: selected ? Colors.green : Colors.white,
        child: Text(
          floor.arabicName ?? "",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  IconData _icon(TableStatus status) {
    switch (status) {
      case TableStatus.available:
        return Icons.table_restaurant;
      case TableStatus.occupied:
        return Icons.people;
      case TableStatus.maintenance:
        return Icons.build;
      case TableStatus.reserved:
        return Icons.event_seat;
    }
  }
}

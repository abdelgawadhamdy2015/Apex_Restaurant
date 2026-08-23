import 'package:apex_restaurant/featchers/tables/data/models/get_table_request.dart';
import 'package:apex_restaurant/featchers/tables/domain/entities/floor_entity.dart';
import 'package:apex_restaurant/featchers/tables/domain/entities/table_entity.dart';
import 'package:apex_restaurant/featchers/tables/presentation/bloc/tables_bloc.dart';
import 'package:apex_restaurant/featchers/tables/presentation/bloc/tables_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/helpers/extensions.dart';
import '../../../../generated/l10n.dart';
import '../../../cart/data/models/pos_client_model.dart';
import '../../data/models/get_reservations_request.dart';

class TabletReservationSearchFilterCard extends StatefulWidget {
  const TabletReservationSearchFilterCard({
    super.key,
    required this.floors,
    required this.clients,
    required this.onSearch,
  });

  final List<FloorEntity> floors;
  final List<PosClientModel> clients;
  final ValueChanged<GetReservationRequest> onSearch;

  @override
  State<TabletReservationSearchFilterCard> createState() =>
      _TabletReservationSearchFilterCardState();
}

class _TabletReservationSearchFilterCardState
    extends State<TabletReservationSearchFilterCard> {
  final TextEditingController _fromDateController = TextEditingController();
  final TextEditingController _toDateController = TextEditingController();

  PosClientModel? _selectedClient;

  @override
  void dispose() {
    _fromDateController.dispose();
    _toDateController.dispose();
    super.dispose();
  }

  void _onFloorSelected(FloorEntity? floor) {
    if (floor == null) return;
    context.read<TablesBloc>().add(SelectFloorEvent(floorEntity: floor));
    context.read<TablesBloc>().add(
      FetchTablesEvent(
        GetTablesRequest(
          floorID: floor.id,
          pageNumber: 1,
          pageSize: 100,
          forPOS: false,
        ),
      ),
    );
  }

  void _onTableSelected(TableEntity? table) {
    if (table == null) return;
    context.read<TablesBloc>().add(SelectTableEvent(tableEntity: table));
  }

  void _triggerSearch() {
    final selectedTable = context.read<TablesBloc>().state.selectedTable;
    widget.onSearch(
      GetReservationRequest(
        dateFrom: _fromDateController.text,
        dateTo: _toDateController.text,
        customerName: _selectedClient?.arabicName,
        pageNumber: 1,
        pageSize: 20,
        foodTableName: selectedTable?.id,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final l10n = S.of(context);

    // Narrow, independent selectors: this widget only rebuilds when one of
    // these three specific fields actually changes, instead of on every
    // TablesBloc emission.
    final selectedFloor = context.select(
      (TablesBloc b) => b.state.selectedFloor,
    );
    final tables = context.select((TablesBloc b) => b.state.tables);
    final selectedTable = context.select(
      (TablesBloc b) => b.state.selectedTable,
    );

    return Container(
      padding: EdgeInsets.all(spacing.sm),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(spacing.radiusLg),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // From Date
              Expanded(
                child: _buildDateField(
                  context,
                  controller: _fromDateController,
                  hint: 'mm/dd/yyyy',
                  label: l10n.fromDate,
                ),
              ),
              SizedBox(width: spacing.sm),

              // To Date
              Expanded(
                child: _buildDateField(
                  context,
                  controller: _toDateController,
                  hint: 'mm/dd/yyyy',
                  label: l10n.toDate,
                ),
              ),
              SizedBox(width: spacing.sm),

              // Client Selector Dropdown
              Expanded(
                child: SizedBox(
                  height: 44,
                  child: DropdownButtonFormField<PosClientModel?>(
                    initialValue: _selectedClient,
                    isExpanded: true,
                    items: [
                      DropdownMenuItem<PosClientModel?>(
                        value: null,
                        child: Text(l10n.all),
                      ),
                      ...widget.clients.map(
                        (c) => DropdownMenuItem<PosClientModel?>(
                          value: c,
                          child: Text(
                            c.arabicName ?? '',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                    onChanged: (val) => setState(() => _selectedClient = val),
                    decoration: InputDecoration(
                      labelText: l10n.customerName,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: spacing.sm,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(spacing.radiusMd),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: spacing.sm),

              // Floor Selector Dropdown
              Expanded(
                child: SizedBox(
                  height: 44,
                  child: DropdownButtonFormField<FloorEntity?>(
                    initialValue: selectedFloor,
                    isExpanded: true,
                    items: [
                      DropdownMenuItem<FloorEntity?>(
                        value: null,
                        child: Text(l10n.selectFloor),
                      ),
                      ...widget.floors.map(
                        (f) => DropdownMenuItem<FloorEntity?>(
                          value: f,
                          child: Text(
                            f.arabicName,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                    onChanged: _onFloorSelected,
                    decoration: InputDecoration(
                      labelText: l10n.floor,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: spacing.sm,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(spacing.radiusMd),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: spacing.sm),

              // Table Selector Dropdown
              Expanded(
                child: SizedBox(
                  height: 44,
                  child: DropdownButtonFormField<TableEntity?>(
                    initialValue: selectedTable,
                    isExpanded: true,
                    items: [
                      DropdownMenuItem<TableEntity?>(
                        value: null,
                        child: Text(l10n.selectTable),
                      ),
                      ...tables.map(
                        (t) => DropdownMenuItem<TableEntity?>(
                          value: t,
                          child: Text(
                            t.arabicName ?? '',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                    onChanged: _onTableSelected,
                    decoration: InputDecoration(
                      labelText: l10n.table,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: spacing.sm,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(spacing.radiusMd),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: spacing.sm),
          SizedBox(
            height: 44,
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _triggerSearch,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0265DC),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(spacing.radiusMd),
                ),
                elevation: 0,
              ),
              icon: const Icon(Icons.search, size: 18),
              label: Text(l10n.search),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateField(
    BuildContext context, {
    required TextEditingController controller,
    required String hint,
    required String label,
  }) {
    final spacing = context.spacing;
    return SizedBox(
      height: 44,
      child: TextField(
        controller: controller,
        readOnly: true,
        onTap: () async {
          final date = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2020),
            lastDate: DateTime(2030),
          );
          if (date != null) {
            setState(() {
              controller.text =
                  "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
            });
          }
        },
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          contentPadding: EdgeInsets.symmetric(horizontal: spacing.sm),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(spacing.radiusMd),
          ),
        ),
      ),
    );
  }
}

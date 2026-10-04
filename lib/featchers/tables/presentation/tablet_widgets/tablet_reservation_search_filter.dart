import 'package:apex_restaurant/featchers/tables/data/models/get_table_request.dart';
import 'package:apex_restaurant/featchers/tables/domain/entities/floor_entity.dart';
import 'package:apex_restaurant/featchers/tables/domain/entities/table_entity.dart';
import 'package:apex_restaurant/featchers/tables/presentation/bloc/tables_bloc.dart';
import 'package:apex_restaurant/featchers/tables/presentation/bloc/tables_event.dart';
import 'package:apex_restaurant/featchers/tables/presentation/bloc/tables_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/helpers/extensions.dart';
import '../../../../core/helpers/helper_methods.dart';
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

  // ---------------------------------------------------------------------------
  // Dates (same behaviour as the mobile card)
  // ---------------------------------------------------------------------------

  String _formatDate(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  DateTime? _parseDate(String value) {
    if (value.trim().isEmpty) return null;
    return DateTime.tryParse(value);
  }

  Future<void> _pickDate(
    TextEditingController controller, {
    DateTime? firstDate,
  }) async {
    final existing = _parseDate(controller.text);
    final effectiveFirstDate = firstDate ?? DateTime(2000);

    var initial = existing ?? DateTime.now();
    if (initial.isBefore(effectiveFirstDate)) {
      initial = effectiveFirstDate;
    }

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: effectiveFirstDate,
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        controller.text = _formatDate(picked);
        // If "from" was pushed later than an already-picked "to",
        // clear the now-invalid "to" date.
        if (controller == _fromDateController) {
          final toDate = _parseDate(_toDateController.text);
          if (toDate != null && toDate.isBefore(picked)) {
            _toDateController.clear();
          }
        }
      });
    }
  }

  void _pickFromDate() => _pickDate(_fromDateController);

  void _pickToDate() {
    final fromDate = _parseDate(_fromDateController.text);
    _pickDate(_toDateController, firstDate: fromDate);
  }

  // ---------------------------------------------------------------------------
  // Floor / table / search
  // ---------------------------------------------------------------------------

  void _onFloorSelected(FloorEntity? floor) {
    if (floor == null) return;
    final bloc = context.read<TablesBloc>();
    bloc.add(SelectTableEvent(tableEntity: null, clearSelection: true));
    bloc.add(SelectFloorEvent(floorEntity: floor));
    bloc.add(
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

  void _triggerSearch() {
    final fromDate = _parseDate(_fromDateController.text);
    final toDate = _parseDate(_toDateController.text);

    if (fromDate != null && toDate != null && toDate.isBefore(fromDate)) {
      HelperMethods.showSnackBar(
        context: context,
        message: 'End date cannot be before Start date.',
        isError: true,
      );
      return;
    }

    final selectedTable = context.select(
      (TablesBloc b) => b.state.selectedTable,
    );
    widget.onSearch(
      GetReservationRequest(
        dateFrom: _fromDateController.text,
        dateTo: _toDateController.text,
        customerId: _selectedClient?.id.toString(),
        pageNumber: 1,
        pageSize: 20,
        foodTableId: selectedTable?.id,
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final l10n = S.of(context);

    final selectedFloor = context.select(
      (TablesBloc b) => b.state.selectedFloor,
    );

    // Floors: dedupe by id and use the matching instance from the CURRENT
    // list (or null) so the dropdown never asserts.
    final uniqueFloors = {
      for (final f in widget.floors) f.id: f,
    }.values.toList();
    final floorValue = uniqueFloors
        .where((f) => f.id == selectedFloor?.id)
        .firstOrNull;

    // Clients: same approach.
    final uniqueClients = {
      for (final c in widget.clients) c.id: c,
    }.values.toList();
    final clientValue = uniqueClients
        .where((c) => c.id == _selectedClient?.id)
        .firstOrNull;

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
                  hint: 'yyyy-mm-dd',
                  label: l10n.fromDate,
                  onTap: _pickFromDate,
                ),
              ),
              SizedBox(width: spacing.sm),

              // To Date
              Expanded(
                child: _buildDateField(
                  context,
                  controller: _toDateController,
                  hint: 'yyyy-mm-dd',
                  label: l10n.toDate,
                  onTap: _pickToDate,
                ),
              ),
              SizedBox(width: spacing.sm),

              // Client Selector Dropdown
              Expanded(
                child: SizedBox(
                  height: 44,
                  child: DropdownButtonFormField<PosClientModel?>(
                    key: ValueKey(
                      'client-${uniqueClients.length}-${clientValue?.id}',
                    ),
                    initialValue: clientValue,
                    isExpanded: true,
                    items: [
                      DropdownMenuItem<PosClientModel?>(
                        value: null,
                        child: Text(l10n.all),
                      ),
                      ...uniqueClients.map(
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
                    decoration: _decoration(
                      spacing,
                      labelText: l10n.customerName,
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
                    key: ValueKey(
                      'floor-${uniqueFloors.length}-${floorValue?.id}',
                    ),
                    initialValue: floorValue,
                    isExpanded: true,
                    items: [
                      DropdownMenuItem<FloorEntity?>(
                        value: null,
                        child: Text(l10n.selectFloor),
                      ),
                      ...uniqueFloors.map(
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
                    decoration: _decoration(spacing, labelText: l10n.floor),
                  ),
                ),
              ),
              SizedBox(width: spacing.sm),

              // Table Selector Dropdown (id based, same as mobile)
              BlocBuilder<TablesBloc, TablesState>(
                builder: (context, state) {
                  final uniqueTables = <String, TableEntity>{};
                  for (final table in state.tables) {
                    final id = table.id;
                    if (id != null && id.isNotEmpty) {
                      uniqueTables[id] = table;
                    }
                  }
                  final dropdownTables = uniqueTables.values.toList();

                  final selectedTableId = state.selectedTable?.id;
                  final validSelectedTableId =
                      selectedTableId != null &&
                          uniqueTables.containsKey(selectedTableId)
                      ? selectedTableId
                      : null;

                  return Expanded(
                    child: SizedBox(
                      height: 44,
                      child: DropdownButtonFormField<String?>(
                        key: ValueKey(
                          'table_${state.selectedFloor?.id}_${dropdownTables.map((e) => e.id).join("_")}',
                        ),
                        initialValue: validSelectedTableId,
                        isExpanded: true,
                        items: [
                          DropdownMenuItem<String?>(
                            value: null,
                            child: Text(l10n.selectTable),
                          ),
                          ...dropdownTables.map(
                            (table) => DropdownMenuItem<String?>(
                              value: table.id,
                              child: Text(
                                table.arabicName ?? '',
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                        onChanged: state.status == TablesStatus.loading
                            ? null
                            : (tableId) {
                                final selected = tableId == null
                                    ? null
                                    : uniqueTables[tableId];
                                context.read<TablesBloc>().add(
                                  SelectTableEvent(
                                    tableEntity: selected,
                                    clearSelection: selected == null,
                                  ),
                                );
                              },
                        decoration: _decoration(spacing, labelText: l10n.table),
                      ),
                    ),
                  );
                },
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

  InputDecoration _decoration(dynamic spacing, {required String labelText}) {
    return InputDecoration(
      labelText: labelText,
      contentPadding: EdgeInsets.symmetric(horizontal: spacing.sm),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(spacing.radiusMd),
      ),
    );
  }

  Widget _buildDateField(
    BuildContext context, {
    required TextEditingController controller,
    required String hint,
    required String label,
    required VoidCallback onTap,
  }) {
    final spacing = context.spacing;
    return SizedBox(
      height: 44,
      child: TextField(
        controller: controller,
        readOnly: true,
        onTap: onTap,
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

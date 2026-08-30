import '../../../../core/helpers/extensions.dart';
import '../../../../core/helpers/helper_methods.dart';
import '../../../../core/shared/widgets/date_text_field.dart';
import '../../../cart/data/models/pos_client_model.dart';
import '../../data/models/get_reservations_request.dart';
import '../../data/models/get_table_request.dart';
import '../../domain/entities/floor_entity.dart';
import '../../domain/entities/table_entity.dart';
import '../../../../generated/l10n.dart';
import '../bloc/tables_bloc.dart';
import '../bloc/tables_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReservationSearchFilterCard extends StatefulWidget {
  const ReservationSearchFilterCard({
    super.key,
    required this.floors,
    required this.onSearch,
    this.clients = const [],
  });

  final List<FloorEntity> floors;
  final List<PosClientModel> clients;

  final Function(GetReservationRequest request) onSearch;

  @override
  State<ReservationSearchFilterCard> createState() =>
      _ReservationSearchFilterCardState();
}

class _ReservationSearchFilterCardState
    extends State<ReservationSearchFilterCard> {
  final _fromDateController = TextEditingController();
  final _toDateController = TextEditingController();

  PosClientModel? _selectedClient;

  @override
  void dispose() {
    _fromDateController.dispose();
    _toDateController.dispose();
    super.dispose();
  }

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
        // If the "from" date was pushed later than an already-picked "to"
        // date, clear the now-invalid "to" date so the range stays sane.
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

  // Selecting a floor resets the table choice and re-fetches the tables
  // that belong to that floor -- the table dropdown below is populated from
  // TablesBloc.state.tables, so this is what drives the cascade.
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

  void _onSearchPressed() {
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

    final selectedTable = context.read<TablesBloc>().state.selectedTable;

    widget.onSearch(
      GetReservationRequest(
        pageNumber: 1,
        pageSize: 20,
        dateFrom: _fromDateController.text,
        dateTo: _toDateController.text,
        customerName: _selectedClient?.arabicName,
        foodTableName: selectedTable?.arabicName,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final iconSizes = context.iconSizes;
    final l10n = S.of(context);

    // Narrow, independent selectors: this widget only rebuilds when one of
    // these specific fields changes, instead of on every TablesBloc
    // emission.
    final selectedFloor = context.select(
      (TablesBloc b) => b.state.selectedFloor,
    );
    final tables = context.select((TablesBloc b) => b.state.tables);
    final selectedTable = context.select(
      (TablesBloc b) => b.state.selectedTable,
    );

    return Container(
      padding: EdgeInsets.all(spacing.xxs),
      decoration: BoxDecoration(
        color: theme.colorScheme.onSurface,
        borderRadius: BorderRadius.circular(spacing.radiusLg),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Floor Selector Dropdown
              Expanded(
                child: DropdownButtonFormField<FloorEntity?>(
                  initialValue: selectedFloor,
                  decoration: InputDecoration(
                    labelText: l10n.floor,
                    fillColor: theme.colorScheme.surface,
                  ),
                  items: [
                    DropdownMenuItem<FloorEntity?>(
                      value: null,
                      child: Text(l10n.selectFloor),
                    ),
                    ...widget.floors.map(
                      (f) => DropdownMenuItem<FloorEntity?>(
                        value: f,
                        child: Text(f.arabicName),
                      ),
                    ),
                  ],
                  onChanged: _onFloorSelected,
                ),
              ),
              SizedBox(width: spacing.xxs),

              Expanded(
                child: DropdownButtonFormField<TableEntity?>(
                  initialValue: selectedTable,
                  decoration: InputDecoration(
                    labelText: l10n.table,
                    fillColor: theme.colorScheme.surface,
                  ),
                  items: [
                    DropdownMenuItem<TableEntity?>(
                      value: null,
                      child: Text(l10n.selectTable),
                    ),
                    ...tables.map(
                      (t) => DropdownMenuItem<TableEntity?>(
                        value: t,
                        child: Text(
                          t.arabicName ?? "",
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                  onChanged: _onTableSelected,
                ),
              ),
            ],
          ),
          SizedBox(height: spacing.xxs),
          DropdownButtonFormField<PosClientModel?>(
            initialValue: _selectedClient,
            alignment: AlignmentDirectional.topCenter,
            isExpanded: true,
            decoration: InputDecoration(
              labelText: l10n.customerName,
              fillColor: theme.colorScheme.surface,
            ),
            items: [
              DropdownMenuItem<PosClientModel?>(
                value: null,
                child: Text(l10n.all),
              ),
              ...widget.clients.map(
                (c) => DropdownMenuItem<PosClientModel?>(
                  value: c,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      c.arabicName ?? "",
                      overflow: TextOverflow.ellipsis,
                      textDirection: TextDirection.rtl,
                    ),
                  ),
                ),
              ),
            ],
            onChanged: (val) {
              setState(() => _selectedClient = val);
            },
          ),
          SizedBox(height: spacing.xxs),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: DateTextField(
                  label: l10n.fromDate,
                  controller: _fromDateController,
                  onTap: _pickFromDate,
                ),
              ),
              SizedBox(width: spacing.xxs),
              Expanded(
                child: DateTextField(
                  label: l10n.toDate,
                  controller: _toDateController,
                  onTap: _pickToDate,
                ),
              ),
            ],
          ),
          SizedBox(height: spacing.md),
          ElevatedButton.icon(
            onPressed: _onSearchPressed,
            icon: Icon(
              Icons.search,
              color: theme.colorScheme.onPrimary,
              size: iconSizes.sm,
            ),
            label: Text(
              l10n.search,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 46),
              backgroundColor: theme.colorScheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(spacing.radiusLg),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

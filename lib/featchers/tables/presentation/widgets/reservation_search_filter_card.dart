import 'package:apex_restaurant/core/helpers/extensions.dart';
import 'package:apex_restaurant/core/shared/widgets/date_text_field.dart';
import 'package:apex_restaurant/featchers/cart/data/models/pos_client_model.dart';
import 'package:apex_restaurant/featchers/tables/data/models/get_reservations_request.dart';
import 'package:apex_restaurant/featchers/tables/domain/entities/table_entity.dart';
import 'package:apex_restaurant/generated/l10n.dart';
import 'package:flutter/material.dart';

class ReservationSearchFilterCard extends StatefulWidget {
  const ReservationSearchFilterCard({
    super.key,
    required this.tables,
    required this.onSearch,
    this.clients = const [],
  });

  final List<TableEntity>? tables;
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
  TableEntity? _selectedTable;

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

  void _onSearchPressed() {
    final fromDate = _parseDate(_fromDateController.text);
    final toDate = _parseDate(_toDateController.text);

    if (fromDate != null && toDate != null && toDate.isBefore(fromDate)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('"To date" cannot be before "From date".'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    widget.onSearch(
      GetReservationRequest(
        pageNumber: 1,
        pageSize: 50,
        dateFrom: _fromDateController.text,
        dateTo: _toDateController.text,
        customerName: _selectedClient?.arabicName,
        foodTableName: _selectedTable?.arabicName,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final iconSizes = context.iconSizes;
    final l10n = S.of(context);

    return Container(
      padding: EdgeInsets.all(spacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(spacing.radiusLg),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<TableEntity?>(
                  initialValue: _selectedTable,
                  decoration: InputDecoration(
                    labelText: l10n.floor,
                    fillColor: theme.colorScheme.surfaceContainerHighest,
                  ),
                  items: [
                    DropdownMenuItem<TableEntity?>(
                      value: null,
                      child: Text(S.of(context).all),
                    ),
                    ...?(widget.tables
                        ?.map(
                          (t) => DropdownMenuItem<TableEntity?>(
                            value: t,
                            child: Text(t.arabicName),
                          ),
                        )
                        .toList()),
                  ],
                  onChanged: (val) {
                    setState(() => _selectedTable = val);
                  },
                ),
              ),
              SizedBox(width: spacing.sm),
              Expanded(
                child: DropdownButtonFormField<PosClientModel>(
                  initialValue: _selectedClient,
                  alignment: AlignmentDirectional.topCenter,
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: l10n.customerName,
                    fillColor: theme.colorScheme.surfaceContainerHighest,
                  ),
                  items: [
                    DropdownMenuItem<PosClientModel>(
                      value: null,
                      child: Text(S.of(context).all),
                    ),
                    ...widget.clients.map((f) {
                      return DropdownMenuItem<PosClientModel>(
                        value: f,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            f.arabicName,
                            overflow: TextOverflow
                                .ellipsis, // Prevents text overflow issues
                            textDirection: TextDirection
                                .rtl, // Forces proper Arabic layout
                          ),
                        ),
                      );
                    }),
                  ],
                  onChanged: (val) {
                    setState(() {
                      _selectedClient = val;
                    });
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: spacing.sm),
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
              SizedBox(width: spacing.sm),
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
              style: theme.textTheme.titleMedium?.copyWith(
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

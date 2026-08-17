import 'package:flutter/material.dart';
import '../../../../core/helpers/extensions.dart';
import '../../../../generated/l10n.dart';
import '../../../cart/data/models/pos_client_model.dart';
import '../../data/models/get_reservations_request.dart';
import '../../domain/entities/table_entity.dart';

class TabletReservationSearchFilterCard extends StatefulWidget {
  const TabletReservationSearchFilterCard({
    super.key,
    required this.tables,
    required this.clients,
    required this.onSearch,
  });

  final List<TableEntity> tables;
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
  final TextEditingController _clientController = TextEditingController();

  int? _selectedFloorId;

  @override
  void dispose() {
    _fromDateController.dispose();
    _toDateController.dispose();
    _clientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final l10n = S.of(context);

    return Container(
      padding: EdgeInsets.all(spacing.sm),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(spacing.radiusLg),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          // Search Button
          SizedBox(
            height: 44,
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

          // Client Search / Input
          Expanded(
            child: SizedBox(
              height: 44,
              child: TextField(
                controller: _clientController,
                decoration: InputDecoration(
                  labelText: l10n.customerName,
                  hintText: l10n.customerName,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: spacing.sm,
                    vertical: 0,
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
              child: DropdownButtonFormField<int>(
                value: _selectedFloorId,
                items: [
                  DropdownMenuItem(value: null, child: Text(l10n.selectTable)),
                ],
                onChanged: (val) => setState(() => _selectedFloorId = val),
                decoration: InputDecoration(
                  labelText: l10n.floor,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: spacing.sm,
                    vertical: 0,
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
            controller.text =
                "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
          }
        },
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          contentPadding: EdgeInsets.symmetric(
            horizontal: spacing.sm,
            vertical: 0,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(spacing.radiusMd),
          ),
        ),
      ),
    );
  }

  void _triggerSearch() {
    widget.onSearch(
      GetReservationRequest(
        dateFrom: _fromDateController.text,
        dateTo: _toDateController.text,
        customerName: _clientController.text,
        pageNumber: 1,
        pageSize: 20,
        //  foodTableName: _selectedFloorId,
      ),
    );
  }
}

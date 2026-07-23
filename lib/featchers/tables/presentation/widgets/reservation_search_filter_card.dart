import 'package:apex_restaurant/core/helpers/extensions.dart';
import 'package:apex_restaurant/core/shared/widgets/date_text_field.dart';
import 'package:apex_restaurant/featchers/tables/domain/entities/floor_entity.dart';
import 'package:apex_restaurant/generated/l10n.dart';
import 'package:flutter/material.dart';

class ReservationSearchFilterCard extends StatefulWidget {
  const ReservationSearchFilterCard({
    super.key,
    required this.floors,
    required this.onSearch,
  });

  final List<FloorEntity>? floors;
  final VoidCallback onSearch;

  @override
  State<ReservationSearchFilterCard> createState() =>
      _ReservationSearchFilterCardState();
}

class _ReservationSearchFilterCardState
    extends State<ReservationSearchFilterCard> {
  final _fromDateController = TextEditingController();
  final _toDateController = TextEditingController();

  @override
  void dispose() {
    _fromDateController.dispose();
    _toDateController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  Future<void> _pickDate(TextEditingController controller) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => controller.text = _formatDate(picked));
    }
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
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: l10n.floor,
                    fillColor: theme.colorScheme.surfaceContainerHighest,
                  ),
                  items: (widget.floors ?? [])
                      .map(
                        (f) => DropdownMenuItem(
                          value: f.id,
                          child: Text(f.arabicName),
                        ),
                      )
                      .toList(),
                  onChanged: (val) {},
                ),
              ),
              SizedBox(width: spacing.sm),
              Expanded(
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: l10n.customerName,
                    fillColor: theme.colorScheme.surfaceContainerHighest,
                  ),
                  items: const [],
                  onChanged: (val) {},
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
                  onTap: () => _pickDate(_fromDateController),
                ),
              ),
              SizedBox(width: spacing.sm),
              Expanded(
                child: DateTextField(
                  label: l10n.toDate,
                  controller: _toDateController,
                  onTap: () => _pickDate(_toDateController),
                ),
              ),
            ],
          ),
          SizedBox(height: spacing.md),
          ElevatedButton.icon(
            onPressed: widget.onSearch,
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

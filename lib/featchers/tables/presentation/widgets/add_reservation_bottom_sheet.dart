import 'package:apex_restaurant/core/helpers/extensions.dart';
import 'package:apex_restaurant/core/shared/widgets/date_text_field.dart';
import 'package:apex_restaurant/featchers/tables/domain/entities/reservation_entity.dart';
import 'package:apex_restaurant/featchers/tables/presentation/bloc/tables_bloc.dart';
import 'package:apex_restaurant/featchers/tables/presentation/bloc/tables_event.dart';
import 'package:apex_restaurant/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddReservationBottomSheet extends StatefulWidget {
  const AddReservationBottomSheet({super.key});

  static Future<void> show(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(spacing.radiusLg),
        ),
      ),
      builder: (sheetContext) => BlocProvider.value(
        value: context.read<TablesBloc>(),
        child: const AddReservationBottomSheet(),
      ),
    );
  }

  @override
  State<AddReservationBottomSheet> createState() =>
      _AddReservationBottomSheetState();
}

class _AddReservationBottomSheetState extends State<AddReservationBottomSheet> {
  final _customerNameController = TextEditingController();
  final _seatsController = TextEditingController();
  final _notesController = TextEditingController();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();

  @override
  void dispose() {
    _customerNameController.dispose();
    _seatsController.dispose();
    _notesController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _dateController.text =
            '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
      });
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() => _timeController.text = picked.format(context));
    }
  }

  void _submit(S l10n) {
    final newReservation = ReservationEntity(
      id: '',
      tableNumber: '202607161249176731',
      customerName: _customerNameController.text.isEmpty
          ? l10n.cashCustomer
          : _customerNameController.text,
      dateTime: DateTime.now(),
      seatsCount: int.tryParse(_seatsController.text) ?? 1,
      durationHours: 1,
      status: ReservationStatus.pending,
      notes: _notesController.text,
    );

    context.read<TablesBloc>().add(AddReservationEvent(newReservation));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final iconSizes = context.iconSizes;
    final l10n = S.of(context);

    return Padding(
      padding: EdgeInsets.only(
        left: spacing.md,
        right: spacing.md,
        top: spacing.md,
        bottom: MediaQuery.of(context).viewInsets.bottom + spacing.md,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              l10n.addNewReservation,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: spacing.md),
          Text(l10n.customerName, style: theme.textTheme.bodySmall),
          SizedBox(height: spacing.xxs),
          TextField(
            controller: _customerNameController,
            decoration: InputDecoration(
              hintText: l10n.enterCustomerNameHint,
              fillColor: theme.colorScheme.surfaceContainerHighest,
            ),
          ),
          SizedBox(height: spacing.sm),
          Text(l10n.table, style: theme.textTheme.bodySmall),
          SizedBox(height: spacing.xxs),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              hintText: l10n.selectTableHint,
              fillColor: theme.colorScheme.surfaceContainerHighest,
            ),
            items: const [],
            onChanged: (val) {},
          ),
          SizedBox(height: spacing.sm),
          DateTextField(
            label: l10n.date,
            controller: _dateController,
            onTap: _pickDate,
          ),
          SizedBox(height: spacing.sm),
          DateTextField(
            label: l10n.time,
            controller: _timeController,
            onTap: _pickTime,
            isDate: false,
          ),
          SizedBox(height: spacing.sm),
          Text(l10n.guestsCount, style: theme.textTheme.bodySmall),
          SizedBox(height: spacing.xxs),
          TextField(
            controller: _seatsController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: l10n.guestsCountHint,
              fillColor: theme.colorScheme.surfaceContainerHighest,
            ),
          ),
          SizedBox(height: spacing.sm),
          Text(l10n.additionalNotes, style: theme.textTheme.bodySmall),
          SizedBox(height: spacing.xxs),
          TextField(
            controller: _notesController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: l10n.additionalNotesHint,
              fillColor: theme.colorScheme.surfaceContainerHighest,
            ),
          ),
          SizedBox(height: spacing.lg),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(spacing.radiusLg),
                    ),
                  ),
                  child: Text(l10n.cancel),
                ),
              ),
              SizedBox(width: spacing.sm),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _submit(l10n),
                  icon: Icon(
                    Icons.check_circle_outline,
                    color: theme.colorScheme.onPrimary,
                    size: iconSizes.sm,
                  ),
                  label: Text(
                    l10n.confirmReservation,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                    backgroundColor: theme.colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(spacing.radiusLg),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

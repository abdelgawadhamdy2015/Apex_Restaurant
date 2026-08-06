import 'package:apex_restaurant/core/helpers/extensions.dart';
import 'package:apex_restaurant/core/helpers/helper_methods.dart';
import 'package:apex_restaurant/core/shared/widgets/custom_app_bar.dart';
import 'package:apex_restaurant/core/shared/widgets/date_text_field.dart';
import 'package:apex_restaurant/featchers/cart/data/models/pos_client_model.dart';
import 'package:apex_restaurant/featchers/tables/data/models/reservation_requests.dart';
import 'package:apex_restaurant/featchers/tables/domain/entities/table_entity.dart';
import 'package:apex_restaurant/featchers/tables/presentation/bloc/tables_bloc.dart';
import 'package:apex_restaurant/featchers/tables/presentation/bloc/tables_event.dart';
import 'package:apex_restaurant/featchers/tables/presentation/bloc/tables_state.dart';
import 'package:apex_restaurant/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddReservationBottomSheet extends StatefulWidget {
  const AddReservationBottomSheet({
    super.key,
    required this.tables,
    required this.personList,
  });

  final List<TableEntity> tables;
  final List<PosClientModel> personList;

  static Future<void> show(
    BuildContext context,
    List<TableEntity> tables,
    List<PosClientModel> personList,
  ) {
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
        child: AddReservationBottomSheet(
          tables: tables,
          personList: personList,
        ),
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
  final _periodController = TextEditingController();
  final _notesController = TextEditingController();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();

  TableEntity? _selectedTable;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  PosClientModel? _selectedPerson;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.tables.isNotEmpty) {
        setState(() => _selectedTable = widget.tables.first);
      }
    });
  }

  @override
  void dispose() {
    _customerNameController.dispose();
    _seatsController.dispose();
    _periodController.dispose();
    _notesController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked == null) return;

    setState(() {
      _selectedDate = picked;
      _dateController.text =
          '${picked.year}-${picked.month.toString().padLeft(2, '0')}-'
          '${picked.day.toString().padLeft(2, '0')}';
    });
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (picked == null) return;

    setState(() {
      _selectedTime = picked;
      _timeController.text = picked.format(context);
    });
  }

  void _submit(S lang) {
    if (_selectedDate == null || _selectedTime == null) {
      HelperMethods.showSnackBar(
        context: context,
        message: lang.selectDateAndTimeError,
        isError: false,
      );
      return;
    }

    final reservationDateTime = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );

    final newReservation = ReserveFoodTableRequest(
      foodTablesId: _selectedTable?.id,
      customerId: _selectedPerson?.id,
      reservationDate: reservationDateTime.toIso8601String(),
      seatsCount: int.tryParse(_seatsController.text) ?? 1,
      reservationPeriod: int.tryParse(_periodController.text) ?? 60,
    );

    context.read<TablesBloc>().add(AddReservationEvent(newReservation));
  }

  InputDecoration _decoration(ThemeData theme, String hint) {
    return InputDecoration(
      hintText: hint,
      fillColor: theme.colorScheme.surfaceContainerHighest,
    );
  }

  Widget _labeledField({
    required ThemeData theme,
    required dynamic spacing,
    required String label,
    required Widget field,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: theme.textTheme.bodySmall),
        SizedBox(height: spacing.xxs),
        field,
      ],
    );
  }

  Widget _buildCustomerField(ThemeData theme, dynamic spacing, S lang) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Autocomplete<PosClientModel>(
          displayStringForOption: (person) => person.arabicName,
          optionsBuilder: (textEditingValue) {
            final query = textEditingValue.text.toLowerCase();
            if (query.isEmpty) return widget.personList;
            return widget.personList.where(
              (person) => (person.arabicName).toLowerCase().contains(query),
            );
          },
          onSelected: (selection) {
            _selectedPerson = selection;
            _customerNameController.text = selection.arabicName;
          },
          fieldViewBuilder: (context, textController, focusNode, _) {
            textController.addListener(() {
              _customerNameController.text = textController.text;
            });
            return TextField(
              controller: textController,
              focusNode: focusNode,
              decoration: _decoration(
                theme,
                lang.enterCustomerNameHint,
              ).copyWith(suffixIcon: const Icon(Icons.arrow_drop_down)),
            );
          },
          optionsViewBuilder: (context, onSelected, options) {
            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: context.appExtraTheme.cancelPorder),
                  borderRadius: BorderRadius.circular(spacing.radiusMd),
                ),
                child: SizedBox(
                  width: constraints.maxWidth,
                  height: 200,
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: options.length,
                    itemBuilder: (context, index) {
                      final option = options.elementAt(index);
                      return Card(
                        color: theme.colorScheme.onSurface,
                        child: ListTile(
                          leading: const Icon(Icons.person_outline),
                          title: Text(
                            option.arabicName,
                            style: theme.textTheme.bodyMedium,
                          ),
                          subtitle: option.phone != null
                              ? Text(option.phone!)
                              : null,
                          onTap: () => onSelected(option),
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildTableDropdown(ThemeData theme, S lang) {
    return DropdownButtonFormField<TableEntity>(
      initialValue: _selectedTable,
      decoration: _decoration(theme, lang.selectTableHint),
      items: widget.tables
          .map(
            (t) => DropdownMenuItem(
              value: t,
              child: Text(t.arabicName, style: theme.textTheme.bodyMedium),
            ),
          )
          .toList(),
      onChanged: (val) => setState(() => _selectedTable = val),
    );
  }

  Widget _buildActionButtons(
    ThemeData theme,
    dynamic spacing,
    dynamic iconSizes,
    S lang,
  ) {
    return Row(
      children: [
        Expanded(
          child: BlocBuilder<TablesBloc, TablesState>(
            builder: (context, state) {
              final isLoading = state.status == TablesStatus.loading;
              return ElevatedButton.icon(
                onPressed: isLoading ? null : () => _submit(lang),
                icon: isLoading
                    ? SizedBox(
                        width: iconSizes.sm,
                        height: iconSizes.sm,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Icon(
                        Icons.check_circle_outline,
                        color: theme.colorScheme.onPrimary,
                        size: iconSizes.sm,
                      ),
                label: Text(
                  lang.confirmReservation,
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
              );
            },
          ),
        ),
        SizedBox(width: spacing.sm),

        Expanded(
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                side: BorderSide(color: context.appExtraTheme.cancelPorder),
                borderRadius: BorderRadius.circular(spacing.radiusLg),
              ),
            ),
            child: Text(lang.cancel),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final iconSizes = context.iconSizes;
    final lang = S.of(context);

    return BlocListener<TablesBloc, TablesState>(
      listenWhen: (previous, current) =>
          previous.status != current.status ||
          previous.errorMessage != current.errorMessage,
      listener: (context, state) {
        if (state.status == TablesStatus.success) {
          Navigator.pop(context);
          HelperMethods.showSnackBar(
            context: context,
            message: lang.reservationSuccess,
            isError: false,
          );
        } else if (state.status == TablesStatus.failure) {
          HelperMethods.showSnackBar(
            context: context,
            message: state.errorMessage ?? lang.unexpectedError,
            isError: true,
          );
        }
      },
      child: SingleChildScrollView(
        child: Padding(
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
              CustomAppBar(title: lang.addNewReservation),
              SizedBox(height: spacing.md),
              _labeledField(
                theme: theme,
                spacing: spacing,
                label: lang.customerName,
                field: _buildCustomerField(theme, spacing, lang),
              ),
              SizedBox(height: spacing.sm),
              _labeledField(
                theme: theme,
                spacing: spacing,
                label: lang.table,
                field: _buildTableDropdown(theme, lang),
              ),
              SizedBox(height: spacing.sm),
              DateTextField(
                type: DateTextFieldType.date,
                label: lang.date,
                controller: _dateController,
                onTap: _pickDate,
              ),
              SizedBox(height: spacing.sm),
              DateTextField(
                label: lang.time,
                controller: _timeController,
                onTap: _pickTime,
                type: DateTextFieldType.time,
              ),
              SizedBox(height: spacing.sm),
              _labeledField(
                theme: theme,
                spacing: spacing,
                label: lang.reservationPeriod,
                field: TextField(
                  controller: _periodController,
                  keyboardType: TextInputType.number,
                  decoration: _decoration(theme, lang.selectReservationPeriod),
                ),
              ),
              SizedBox(height: spacing.sm),
              _labeledField(
                theme: theme,
                spacing: spacing,
                label: lang.guestsCount,
                field: TextField(
                  controller: _seatsController,
                  keyboardType: TextInputType.number,
                  decoration: _decoration(theme, lang.guestsCountHint),
                ),
              ),
              SizedBox(height: spacing.sm),
              _labeledField(
                theme: theme,
                spacing: spacing,
                label: lang.additionalNotes,
                field: TextField(
                  controller: _notesController,
                  maxLines: 3,
                  decoration: _decoration(theme, lang.additionalNotesHint),
                ),
              ),
              SizedBox(height: spacing.lg),
              _buildActionButtons(theme, spacing, iconSizes, lang),
            ],
          ),
        ),
      ),
    );
  }
}

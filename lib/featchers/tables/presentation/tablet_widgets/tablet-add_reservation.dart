import '../../../../core/helpers/extensions.dart';
import '../../../../core/helpers/helper_methods.dart';
import '../../../../core/shared/widgets/date_text_field.dart';
import '../../../cart/data/models/pos_client_model.dart';
import '../../data/models/reservation_requests.dart';
import '../../domain/entities/table_entity.dart';
import '../bloc/tables_bloc.dart';
import '../bloc/tables_event.dart';
import '../bloc/tables_state.dart';
import '../../../../generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TabletAddReservationDialog extends StatefulWidget {
  const TabletAddReservationDialog({
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
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<TablesBloc>(),
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          clipBehavior: Clip.antiAlias,
          child: SizedBox(
            width: 600,
            child: TabletAddReservationDialog(
              tables: tables,
              personList: personList,
            ),
          ),
        ),
      ),
    );
  }

  @override
  State<TabletAddReservationDialog> createState() =>
      _TabletAddReservationDialogState();
}

class _TabletAddReservationDialogState
    extends State<TabletAddReservationDialog> {
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
      filled: true,
      fillColor: theme.colorScheme.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: theme.dividerColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: theme.dividerColor.withOpacity(0.3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: theme.colorScheme.primary),
      ),
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
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: spacing.xxs ?? 6),
        field,
      ],
    );
  }

  Widget _buildHeader(S lang) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          Text(
            lang.addNewReservation,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 24), // Balance cross button layout
        ],
      ),
    );
  }

  Widget _buildCustomerField(ThemeData theme, dynamic spacing, S lang) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Autocomplete<PosClientModel>(
          displayStringForOption: (person) => person.arabicName ?? "",
          optionsBuilder: (textEditingValue) {
            final query = textEditingValue.text.toLowerCase();
            if (query.isEmpty) return widget.personList;
            return widget.personList.where(
              (person) =>
                  (person.arabicName ?? "").toLowerCase().contains(query),
            );
          },
          onSelected: (selection) {
            _selectedPerson = selection;
            _customerNameController.text = selection.arabicName ?? "";
          },
          fieldViewBuilder: (context, textController, focusNode, _) {
            textController.addListener(() {
              _customerNameController.text = textController.text;
            });
            return TextField(
              controller: textController,
              focusNode: focusNode,
              decoration: _decoration(theme, lang.enterCustomerNameHint),
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
                      return ListTile(
                        leading: const Icon(Icons.person_outline),
                        title: Text(
                          option.arabicName ?? "",
                          style: theme.textTheme.bodyMedium,
                        ),
                        subtitle: option.phone != null
                            ? Text(option.phone!)
                            : null,
                        onTap: () => onSelected(option),
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
      value: _selectedTable,
      decoration: _decoration(theme, lang.selectTableHint),
      icon: const Icon(Icons.keyboard_arrow_down),
      items: widget.tables
          .map(
            (t) => DropdownMenuItem(
              value: t,
              child: Text(
                t.arabicName ?? "",
                style: theme.textTheme.bodyMedium,
              ),
            ),
          )
          .toList(),
      onChanged: (val) => setState(() => _selectedTable = val),
    );
  }

  Widget _buildFooterButtons(
    ThemeData theme,
    dynamic spacing,
    dynamic iconSizes,
    S lang,
  ) {
    return Container(
      color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.4),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          BlocBuilder<TablesBloc, TablesState>(
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  backgroundColor: theme.colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            },
          ),
          SizedBox(width: spacing.sm),
          OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              side: BorderSide(color: theme.dividerColor),
            ),
            child: Text(lang.cancel, style: theme.textTheme.titleMedium),
          ),
        ],
      ),
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(lang),
          const Divider(height: 1),
          Padding(
            padding: EdgeInsets.all(spacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _labeledField(
                  theme: theme,
                  spacing: spacing,
                  label: lang.customerName,
                  field: _buildCustomerField(theme, spacing, lang),
                ),
                SizedBox(height: spacing.sm),
                Row(
                  children: [
                    Expanded(
                      child: _labeledField(
                        theme: theme,
                        spacing: spacing,
                        label: lang.guestsCount,
                        field: TextField(
                          controller: _seatsController,
                          keyboardType: TextInputType.number,
                          decoration: _decoration(theme, lang.guestsCountHint),
                        ),
                      ),
                    ),
                    SizedBox(width: spacing.sm),
                    Expanded(
                      child: _labeledField(
                        theme: theme,
                        spacing: spacing,
                        label: lang.table,
                        field: _buildTableDropdown(theme, lang),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: spacing.sm),
                Row(
                  children: [
                    Expanded(
                      child: DateTextField(
                        label: lang.time,
                        controller: _timeController,
                        onTap: _pickTime,
                        type: DateTextFieldType.time,
                      ),
                    ),
                    SizedBox(width: spacing.sm),
                    Expanded(
                      child: DateTextField(
                        type: DateTextFieldType.date,
                        label: lang.date,
                        controller: _dateController,
                        onTap: _pickDate,
                      ),
                    ),
                  ],
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
              ],
            ),
          ),
          _buildFooterButtons(theme, spacing, iconSizes, lang),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/helpers/extensions.dart';
import '../../../../core/helpers/helper_methods.dart';
import '../../../../generated/l10n.dart';
import '../../../cart/data/models/pos_client_model.dart';
import '../../data/models/reservation_requests.dart';
import '../../domain/entities/table_entity.dart';
import '../bloc/tables_bloc.dart';
import '../bloc/tables_event.dart';
import '../bloc/tables_state.dart';

class TabletAddReservationBottomSheet extends StatefulWidget {
  const TabletAddReservationBottomSheet({
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
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(24),
          child: TabletAddReservationBottomSheet(
            tables: tables,
            personList: personList,
          ),
        ),
      ),
    );
  }

  @override
  State<TabletAddReservationBottomSheet> createState() =>
      _TabletAddReservationBottomSheetState();
}

class _TabletAddReservationBottomSheetState
    extends State<TabletAddReservationBottomSheet> {
  final _customerNameController = TextEditingController();
  final _seatsController = TextEditingController();
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
    if (widget.tables.isNotEmpty) {
      _selectedTable = widget.tables.first;
    }
  }

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
        isError: true,
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
      reservationPeriod: 60,
    );

    context.read<TablesBloc>().add(AddReservationEvent(newReservation));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
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
      child: Container(
        width: 580,
        decoration: BoxDecoration(
          color: theme.colorScheme.onSurface,
          borderRadius: BorderRadius.circular(spacing.radiusLg),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top Header Bar
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: spacing.lg,
                vertical: spacing.md,
              ),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withOpacity(
                  0.3,
                ),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(spacing.radiusLg),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, size: 20),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  Text(
                    lang.addNewReservation,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            // Dialog Form Body
            Padding(
              padding: EdgeInsets.all(spacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Customer Field
                  _labeledField(
                    theme: theme,
                    spacing: spacing,
                    label: lang.customerName,
                    field: _buildCustomerAutocomplete(theme, spacing, lang),
                  ),
                  SizedBox(height: spacing.md),

                  // Seats Count & Table Dropdown Row
                  Row(
                    children: [
                      Expanded(
                        child: _labeledField(
                          theme: theme,
                          spacing: spacing,
                          label: lang.guestsCount,
                          field: _buildTextField(
                            controller: _seatsController,
                            hint: 'مثال : 3',
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ),
                      SizedBox(width: spacing.md),
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
                  SizedBox(height: spacing.md),

                  // Time & Date Pickers Row
                  Row(
                    children: [
                      Expanded(
                        child: _labeledField(
                          theme: theme,
                          spacing: spacing,
                          label: lang.time,
                          field: _buildDateField(
                            controller: _timeController,
                            hint: '-- : --',
                            icon: Icons.access_time_rounded,
                            onTap: _pickTime,
                          ),
                        ),
                      ),
                      SizedBox(width: spacing.md),
                      Expanded(
                        child: _labeledField(
                          theme: theme,
                          spacing: spacing,
                          label: lang.date,
                          field: _buildDateField(
                            controller: _dateController,
                            hint: 'mm/dd/yyyy',
                            icon: Icons.calendar_today_outlined,
                            onTap: _pickDate,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: spacing.md),

                  // Notes Textarea
                  _labeledField(
                    theme: theme,
                    spacing: spacing,
                    label: lang.additionalNotes,
                    field: _buildTextField(
                      controller: _notesController,
                      hint: 'اكتب تفاصيل العملية هنا ....',
                      maxLines: 3,
                    ),
                  ),
                ],
              ),
            ),

            // Footer Actions Bar
            Container(
              padding: EdgeInsets.all(spacing.md),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(spacing.radiusLg),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Spacer(),
                  SizedBox(
                    height: 44,
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: theme.colorScheme.onPrimary,
                        backgroundColor: theme.colorScheme.surface,
                        side: BorderSide(
                          color: theme.colorScheme.outlineVariant,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(spacing.radiusMd),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: spacing.lg),
                      ),
                      child: Text(lang.cancel),
                    ),
                  ),
                  SizedBox(width: spacing.sm),

                  BlocBuilder<TablesBloc, TablesState>(
                    builder: (context, state) {
                      final isLoading = state.status == TablesStatus.loading;

                      return SizedBox(
                        height: 44,
                        child: ElevatedButton.icon(
                          onPressed: isLoading ? null : () => _submit(lang),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0265DC),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                spacing.radiusMd,
                              ),
                            ),
                            elevation: 0,
                            padding: EdgeInsets.symmetric(
                              horizontal: spacing.lg,
                            ),
                          ),
                          icon: isLoading
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(
                                  Icons.check_circle_outline,
                                  size: 20,
                                ),
                          label: Text(
                            lang.confirmReservation,
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
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
        SizedBox(height: spacing.xs),
        field,
      ],
    );
  }

  Widget _buildCustomerAutocomplete(ThemeData theme, dynamic spacing, S lang) {
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
            return _buildTextField(
              controller: textController,
              focusNode: focusNode,
              hint: 'اكتب اسم العميل',
            );
          },
        );
      },
    );
  }

  Widget _buildTableDropdown(ThemeData theme, S lang) {
    return SizedBox(
      height: 48,
      child: DropdownButtonFormField<TableEntity>(
        value: _selectedTable,
        decoration: _inputDecoration(theme, 'اختر الطاولة'),
        items: widget.tables
            .map(
              (t) =>
                  DropdownMenuItem(value: t, child: Text(t.arabicName ?? "")),
            )
            .toList(),
        onChanged: (val) => setState(() => _selectedTable = val),
      ),
    );
  }

  Widget _buildDateField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return SizedBox(
      height: 48,
      child: TextField(
        controller: controller,
        readOnly: true,
        onTap: onTap,
        decoration: _inputDecoration(theme, hint).copyWith(
          suffixIcon: Icon(icon, size: 20, color: theme.colorScheme.outline),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    FocusNode? focusNode,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    final theme = Theme.of(context);
    return TextField(
      controller: controller,
      focusNode: focusNode,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: _inputDecoration(theme, hint),
    );
  }

  InputDecoration _inputDecoration(ThemeData theme, String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: theme.textTheme.bodyMedium?.copyWith(
        color: theme.colorScheme.outline,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      filled: true,
      fillColor: theme.colorScheme.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
    );
  }
}

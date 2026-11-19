import 'package:apex_restaurant/core/themes/app_colors.dart';
import 'package:apex_restaurant/featchers/cart/data/models/get_client_request.dart';
import 'package:apex_restaurant/featchers/cart/presentation/bloc/cart_bloc.dart';
import 'package:apex_restaurant/featchers/cart/presentation/bloc/cart_event.dart';
import 'package:apex_restaurant/featchers/cart/presentation/bloc/cart_state.dart';
import 'package:apex_restaurant/featchers/tables/data/models/get_reservations_request.dart';
import 'package:apex_restaurant/featchers/tables/data/models/get_table_request.dart';
import 'package:flutter/services.dart';

import '../../../../core/helpers/extensions.dart';
import '../../../../core/helpers/helper_methods.dart';
import '../../../../core/shared/widgets/custom_app_bar.dart';
import '../../../../core/shared/widgets/date_text_field.dart';
import '../../../cart/data/models/pos_client_model.dart';
import '../../data/models/reservation_requests.dart';
import '../../domain/entities/reservation_entity.dart';
import '../../domain/entities/table_entity.dart';
import '../bloc/tables_bloc.dart';
import '../bloc/tables_event.dart';
import '../bloc/tables_state.dart';
import '../../../../generated/l10n.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddReservationBottomSheet extends StatefulWidget {
  const AddReservationBottomSheet({
    super.key,
    this.reservation,
    this.selectedTable,
    this.allowPastDateTime = false,
  });

  final ReservationEntity? reservation;
  final bool allowPastDateTime;
  final TableEntity? selectedTable;

  bool get isEdit => reservation != null;

  static Future<void> show(
    BuildContext context, {
    ReservationEntity? reservation,
    TableEntity? selectedTable,
    bool allowPastDateTime = false,
  }) {
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
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: context.read<TablesBloc>()),
          BlocProvider.value(value: context.read<CartBloc>()),
        ],
        child: AddReservationBottomSheet(
          reservation: reservation,
          selectedTable: selectedTable,
          allowPastDateTime: allowPastDateTime,
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
  final _formKey = GlobalKey<FormState>();

  /// Autocomplete reads its initial value once.
  Key _customerKey = const ValueKey('customer');

  @override
  void initState() {
    super.initState();

    final tablesBloc = context.read<TablesBloc>();
    final cartBloc = context.read<CartBloc>();

    // Load tables if they are not already available.

    tablesBloc.add(
      FetchTablesEvent(GetTablesRequest(pageNumber: 1, pageSize: 1000)),
    );

    // Load customers if they are not already available.
    if (cartBloc.state.persons.isEmpty || widget.isEdit) {
      cartBloc.add(
        LoadPersonsData(request: GetClientsRequest(isSupplier: false)),
      );
    }

    // Edit mode: prefill existing reservation fields.
    final reservation = widget.reservation;

    if (reservation != null) {
      final dateTime = reservation.dateTime;

      _selectedDate = dateTime;
      _selectedTime = TimeOfDay.fromDateTime(dateTime);

      _dateController.text = _formatDate(dateTime);
      _seatsController.text = reservation.seatsCount.toString();
      _periodController.text = reservation.durationMinutes.toString();
      _notesController.text = reservation.notes ?? '';

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;

        setState(() {
          _timeController.text = _selectedTime!.format(context);
        });
      });
    }

    // Synchronize initial data after the first frame.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      _syncTable(tablesBloc.state.tables);
      _syncPerson(cartBloc.state.persons);
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

  // ---------------------------------------------------------------------------
  // Sync selections once data is loaded
  // ---------------------------------------------------------------------------

  void _syncTable(List<TableEntity> tables) {
    if (tables.isEmpty) return;

    // Edit mode has priority over the externally selected table.
    final targetTableId =
        widget.reservation?.tableId ?? widget.selectedTable?.id;

    TableEntity? match;

    if (targetTableId != null) {
      for (final table in tables) {
        if (table.id == targetTableId) {
          match = table;
          break;
        }
      }
    }

    // Fallback when no matching table is found.
    match ??= tables.first;

    if (_selectedTable?.id == match.id) return;

    setState(() {
      _selectedTable = match;
    });
  }

  void _syncPerson(List<PosClientModel> persons) {
    final reservation = widget.reservation;

    if (reservation == null || _selectedPerson != null || persons.isEmpty) {
      return;
    }

    for (final person in persons) {
      if (person.id.toString() == reservation.customerId.toString()) {
        setState(() {
          _selectedPerson = person;
          _customerNameController.text = person.arabicName ?? '';
          _customerKey = ValueKey('customer-${person.id}');
        });

        return;
      }
    }
  }

  // ---------------------------------------------------------------------------
  // Pickers
  // ---------------------------------------------------------------------------

  String _formatDate(DateTime date) {
    return '${date.year}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final picked = await showDatePicker(
      context: context,
      initialDate:
          _selectedDate != null &&
              _selectedDate!.isBefore(
                widget.allowPastDateTime ? DateTime(2000) : today,
              )
          ? today
          : _selectedDate ?? now,
      firstDate: widget.allowPastDateTime ? DateTime(2000) : today,
      lastDate: DateTime(2100),
    );

    if (picked == null) return;

    setState(() {
      _selectedDate = picked;
      _dateController.text = _formatDate(picked);
    });
  }

  Future<void> _pickTime() async {
    final now = DateTime.now();

    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );

    if (picked == null) return;

    final selectedDate = _selectedDate ?? now;

    final selectedDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      picked.hour,
      picked.minute,
    );

    if (!widget.allowPastDateTime &&
        !selectedDateTime.isAfter(DateTime.now())) {
      HelperMethods.showSnackBar(
        context: context,
        message: S.of(context).reservationDateTimeMustBeFuture,
        isError: true,
      );
      return;
    }

    setState(() {
      _selectedTime = picked;
      _timeController.text = picked.format(context);
    });
  }

  // ---------------------------------------------------------------------------
  // Submit
  // ---------------------------------------------------------------------------

  void _submit(S lang) {
    if (_selectedPerson == null) {
      HelperMethods.showSnackBar(
        context: context,
        message: lang.pleaseSelectValidCustomer,
        isError: true,
      );

      return;
    }
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
    if (!widget.allowPastDateTime &&
        !reservationDateTime.isAfter(DateTime.now())) {
      HelperMethods.showSnackBar(
        context: context,
        message: lang.reservationDateTimeMustBeFuture,
        isError: true,
      );
      return;
    }
    if (_formKey.currentState!.validate()) {
      final request = ReserveFoodTableRequest(
        reservationId: widget.reservation?.id,
        foodTablesId: _selectedTable?.id,
        customerId: _selectedPerson?.id,
        reservationDate: reservationDateTime.toIso8601String(),
        seatsCount: int.tryParse(_seatsController.text) ?? 1,
        reservationPeriod: int.tryParse(_periodController.text) ?? 60,
      );

      final bloc = context.read<TablesBloc>();
      final state = bloc.state;
      if (widget.isEdit) {
        bloc.add(EditReservationEvent(request));
      } else {
        bloc.add(AddReservationEvent(request));
      }
      bloc.add(
        FetchReservationsEvent(
          GetReservationRequest(
            pageNumber: 1,
            pageSize: 20,
            dateFrom: state.fromDateController.text,
            dateTo: state.toDateController.text,
            foodTableId: state.selectedTable?.id,
          ),
        ),
      );
    }
  }

  // ---------------------------------------------------------------------------
  // UI helpers
  // ---------------------------------------------------------------------------

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

  // ---------------------------------------------------------------------------
  // Customer autocomplete
  // ---------------------------------------------------------------------------

  Widget _buildCustomerField(
    ThemeData theme,
    dynamic spacing,
    S lang,
    List<PosClientModel> persons,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Autocomplete<PosClientModel>(
          key: _customerKey,
          initialValue: TextEditingValue(text: _customerNameController.text),
          displayStringForOption: (person) => person.arabicName ?? "",
          optionsBuilder: (textEditingValue) {
            final query = textEditingValue.text.toLowerCase();

            if (query.isEmpty) return persons;

            return persons.where(
              (person) =>
                  (person.arabicName ?? "").toLowerCase().contains(query),
            );
          },
          onSelected: (selection) {
            setState(() {
              _selectedPerson = selection;
              _customerNameController.text = selection.arabicName ?? "";
            });
            FocusManager.instance.primaryFocus?.unfocus();
          },
          fieldViewBuilder: (context, textController, focusNode, _) {
            return TextFormField(
              controller: textController,
              focusNode: focusNode,
              validator: (value) {
                if (value == null || value.isEmpty || _selectedPerson == null) {
                  return lang.pleaseSelectValidCustomer;
                }
                return null;
              },
              onChanged: (text) {
                _customerNameController.text = text;

                // Unlink the selected customer if the text changes.
                if (_selectedPerson != null &&
                    _selectedPerson!.arabicName != text) {
                  _selectedPerson = null;
                }
              },

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
                elevation: 4,
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
                            option.arabicName ?? "",
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

  // ---------------------------------------------------------------------------
  // Table dropdown
  // ---------------------------------------------------------------------------

  Widget _buildTableDropdown(
    ThemeData theme,
    S lang,
    List<TableEntity> tables,
  ) {
    return DropdownButtonFormField<TableEntity>(
      key: ValueKey('table-${tables.length}-${_selectedTable?.id}'),
      initialValue: _selectedTable,
      decoration: _decoration(theme, lang.selectTableHint),
      // Close the customer autocomplete overlay.
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },

      items: tables
          .map(
            (table) => DropdownMenuItem(
              value: table,
              child: Text(
                table.arabicName ?? "",
                style: theme.textTheme.bodyMedium,
              ),
            ),
          )
          .toList(),

      onChanged: !widget.isEdit
          ? (value) {
              FocusManager.instance.primaryFocus?.unfocus();

              setState(() {
                _selectedTable = value;
              });
            }
          : null,
    );
  }

  // ---------------------------------------------------------------------------
  // Action buttons
  // ---------------------------------------------------------------------------

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
                        color: AppColors.white,
                        size: iconSizes.sm,
                      ),
                label: Text(
                  widget.isEdit ? lang.saveChanges : lang.confirmReservation,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: AppColors.white,
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
            child: Text(lang.cancel, style: theme.textTheme.titleMedium),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final iconSizes = context.iconSizes;
    final lang = S.of(context);

    final tables = context.select((TablesBloc bloc) => bloc.state.tables);

    final persons = context.select((CartBloc bloc) => bloc.state.persons);

    return MultiBlocListener(
      listeners: [
        // Tables loaded -> select the correct table.
        BlocListener<TablesBloc, TablesState>(
          listenWhen: (previous, current) => previous.tables != current.tables,
          listener: (_, state) {
            _syncTable(state.tables);
          },
        ),

        // Customers loaded -> prefill customer in edit mode.
        BlocListener<CartBloc, CartState>(
          listenWhen: (previous, current) =>
              previous.persons != current.persons,
          listener: (_, state) {
            _syncPerson(state.persons);
          },
        ),

        // Reservation result.
        BlocListener<TablesBloc, TablesState>(
          listenWhen: (previous, current) =>
              previous.status != current.status ||
              previous.errorMessage != current.errorMessage,
          listener: (context, state) {
            if (state.status == TablesStatus.reservationSuccess) {
              Navigator.pop(context);

              HelperMethods.showSnackBar(
                context: context,
                message: widget.isEdit
                    ? lang.reservationUpdateSuccess
                    : lang.reservationSuccess,
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
        ),
      ],
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            left: spacing.md,
            right: spacing.md,
            top: spacing.md,
            bottom: MediaQuery.of(context).viewInsets.bottom + spacing.md,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomAppBar(
                  title: widget.isEdit
                      ? lang.editReservation
                      : lang.addNewReservation,
                ),

                SizedBox(height: spacing.md),

                _labeledField(
                  theme: theme,
                  spacing: spacing,
                  label: lang.customerName,
                  field: _buildCustomerField(theme, spacing, lang, persons),
                ),

                SizedBox(height: spacing.sm),

                _labeledField(
                  theme: theme,
                  spacing: spacing,
                  label: lang.table,
                  field: _buildTableDropdown(theme, lang, tables),
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
                  field: TextFormField(
                    controller: _periodController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      final period = int.tryParse(value ?? '');

                      if (period == null || period <= 0) {
                        return lang.reservationPeriodError;
                      }

                      return null;
                    },
                    decoration: _decoration(
                      theme,
                      lang.selectReservationPeriod,
                    ),
                  ),
                ),

                SizedBox(height: spacing.sm),

                _labeledField(
                  theme: theme,
                  spacing: spacing,
                  label: lang.guestsCount,
                  field: TextFormField(
                    controller: _seatsController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      final seatsCount = int.tryParse(value ?? '');

                      if (seatsCount == null || seatsCount <= 0) {
                        return lang.guestsCountError;
                      }

                      return null;
                    },
                    decoration: _decoration(theme, lang.guestsCountHint),
                  ),
                ),

                SizedBox(height: spacing.sm),

                _labeledField(
                  theme: theme,
                  spacing: spacing,
                  label: lang.additionalNotes,
                  field: TextFormField(
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
      ),
    );
  }
}

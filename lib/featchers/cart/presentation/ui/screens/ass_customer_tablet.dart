import 'package:apex_restaurant/core/helpers/extensions.dart';
import 'package:apex_restaurant/core/helpers/helper_methods.dart';
import 'package:apex_restaurant/core/themes/app_colors.dart';
import 'package:apex_restaurant/featchers/cart/data/models/client_request_model.dart';
import 'package:apex_restaurant/featchers/cart/data/models/get_client_request.dart';
import 'package:apex_restaurant/featchers/cart/data/models/pos_client_model.dart';
import 'package:apex_restaurant/featchers/cart/presentation/bloc/cart_bloc.dart';
import 'package:apex_restaurant/featchers/cart/presentation/bloc/cart_event.dart';
import 'package:apex_restaurant/featchers/cart/presentation/bloc/cart_state.dart';
import 'package:apex_restaurant/featchers/cart/presentation/ui/widgets/dashed_add_address_button.dart';
import 'package:apex_restaurant/featchers/home/presentation/bloc/home_bloc.dart';
import 'package:apex_restaurant/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Tablet "Add / Edit Customer" modal dialog.
///
/// This is the dialog counterpart of the full-page `AddCustomerScreen`
/// used on mobile. It carries the same request shape and dispatches the
/// same `CartBloc` events, but is presented with `showDialog` so it sits
/// as a centered card instead of pushing a route — matching the tablet
/// design where secondary flows (daily close, payment, etc.) use dialogs.
class AddCustomerDialog extends StatefulWidget {
  const AddCustomerDialog({super.key, this.selectedPerson});

  final PosClientModel? selectedPerson;

  /// Shows the dialog and returns `true` if the customer was saved.
  static Future<bool?> show(
    BuildContext context, {
    PosClientModel? selectedPerson,
  }) {
    final cartBloc = context.read<CartBloc>();
    final homeBloc = context.read<HomeBloc>();

    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: cartBloc),
          BlocProvider.value(value: homeBloc),
        ],
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: AddCustomerDialog(selectedPerson: selectedPerson),
        ),
      ),
    );
  }

  @override
  State<AddCustomerDialog> createState() => _AddCustomerDialogState();
}

class _AddCustomerDialogState extends State<AddCustomerDialog> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _altPhoneController = TextEditingController();

  final List<_AddressData> _addresses = [];

  bool get _isEditMode => widget.selectedPerson != null;

  @override
  void initState() {
    super.initState();
    _populateForEditMode();
  }

  void _populateForEditMode() {
    final person = widget.selectedPerson;
    if (person == null) {
      _addresses.add(_AddressData());
      return;
    }

    _nameController.text = person.arabicName ?? '';

    if (person.personPhones?.isNotEmpty == true) {
      _phoneController.text = person.personPhones!.first.phoneNumber ?? '';
      if (person.personPhones!.length > 1) {
        _altPhoneController.text = person.personPhones![1].phoneNumber ?? '';
      }
    }

    if (person.personAddress?.isNotEmpty == true) {
      for (final addr in person.personAddress!) {
        _addresses.add(_AddressData.fromModel(addr));
      }
    } else {
      _addresses.add(_AddressData());
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _altPhoneController.dispose();
    for (final address in _addresses) {
      address.dispose();
    }
    super.dispose();
  }

  void _addAddress() => setState(() => _addresses.add(_AddressData()));

  void _removeAddress(int index) {
    if (_addresses.length <= 1) return;
    setState(() => _addresses.removeAt(index).dispose());
  }

  void _save() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final List<ClientRequestPhoneModel> phones = [];
    if (_phoneController.text.trim().isNotEmpty) {
      phones.add(
        ClientRequestPhoneModel(
          id:
              (_isEditMode &&
                  widget.selectedPerson!.personPhones?.isNotEmpty == true)
              ? widget.selectedPerson!.personPhones!.first.id
              : null,
          phoneNumber: _phoneController.text.trim(),
          isDefault: true,
          personsId: widget.selectedPerson?.id,
        ),
      );
    }
    if (_altPhoneController.text.trim().isNotEmpty) {
      phones.add(
        ClientRequestPhoneModel(
          id: (_isEditMode && widget.selectedPerson!.personPhones?.length == 2)
              ? widget.selectedPerson!.personPhones![1].id
              : null,
          phoneNumber: _altPhoneController.text.trim(),
          isDefault: false,
          personsId: widget.selectedPerson?.id,
        ),
      );
    }

    final List<ClientRequestAddressModel> addresses = _addresses.map((a) {
      return ClientRequestAddressModel(
        id: a.id,
        city: a.cityController.text.trim(),
        district: a.districtController.text.trim(),
        street: a.streetController.text.trim(),
        buildingNo: a.buildingController.text.trim(),
        floor: a.floorController.text.trim(),
        apartmentNo: a.apartmentController.text.trim(),
        isDefault: a.isDefault,
        landmark: '',
      );
    }).toList();

    // Tablet dialog keeps the current employee's branch by default instead
    // of exposing a branch picker in the UI.
    final currentBranchId = context
        .read<HomeBloc>()
        .state
        .selectedEmployeeBranch
        ?.branchId;

    final request = ClientRequestModel(
      id: widget.selectedPerson?.id,
      name: _nameController.text.trim(),
      phones: phones,
      addresses: addresses,
      branches: currentBranchId != null ? [currentBranchId] : const [],
    );

    if (_isEditMode) {
      context.read<CartBloc>().add(UpdatePosClientEvent(request: request));
    } else {
      context.read<CartBloc>().add(AddPosClientEvent(request: request));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final lang = S.of(context);

    return BlocListener<CartBloc, CartState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == CartStatus.success) {
          HelperMethods.showSnackBar(
            context: context,
            message: state.successMessage ?? 'Saved successfully',
            isError: false,
          );
          context.read<CartBloc>().add(
            LoadPersonsData(request: GetClientsRequest(isSupplier: false)),
          );
          Navigator.of(context).pop(true);
        } else if (state.status == CartStatus.failure) {
          HelperMethods.showSnackBar(
            context: context,
            message: state.errorMessage ?? 'An error occurred',
            isError: true,
          );
        }
      },
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(
          horizontal: spacing.lg,
          vertical: spacing.xl,
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520, maxHeight: 760),
          child: Material(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(spacing.radiusLg),
            clipBehavior: Clip.antiAlias,
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _Header(
                    title: _isEditMode
                        ? lang.editCustomer
                        : lang.addNewCustomer,
                    onClose: () => Navigator.of(context).pop(),
                  ),
                  Flexible(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(spacing.lg),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _FieldLabel(label: lang.fullName, isRequired: true),
                          SizedBox(height: spacing.xxs),
                          _DialogTextField(
                            controller: _nameController,
                            hintText: lang.fullName,
                            validator: (value) =>
                                (value == null || value.trim().isEmpty)
                                ? 'Please enter customer name'
                                : null,
                          ),
                          SizedBox(height: spacing.md),

                          // Phone / alternate phone row.
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    _FieldLabel(
                                      label: lang.phone,
                                      isRequired: true,
                                    ),
                                    SizedBox(height: spacing.xxs),
                                    _DialogTextField(
                                      controller: _phoneController,
                                      hintText: '05xxxxxxxx',
                                      keyboardType: TextInputType.phone,
                                      validator: (value) =>
                                          (value == null ||
                                              value.trim().isEmpty)
                                          ? 'Please enter phone number'
                                          : null,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: spacing.sm),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    _FieldLabel(
                                      label: lang.alternatePhoneOptional,
                                    ),
                                    SizedBox(height: spacing.xxs),
                                    _DialogTextField(
                                      controller: _altPhoneController,
                                      hintText: '05xxxxxxxx',
                                      keyboardType: TextInputType.phone,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: spacing.lg),

                          Row(
                            children: [
                              Text(
                                lang.customerAddresses,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: spacing.xxs),
                              Text(
                                lang.addMoreAddressesHint,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.secondary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: spacing.sm),

                          Container(
                            padding: EdgeInsets.all(spacing.md),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceContainerHighest
                                  .withOpacity(0.35),
                              borderRadius: BorderRadius.circular(
                                spacing.radiusLg,
                              ),
                              border: Border.all(
                                color: theme.colorScheme.outlineVariant,
                              ),
                            ),
                            child: Column(
                              children: [
                                for (var i = 0; i < _addresses.length; i++) ...[
                                  if (i > 0) ...[
                                    SizedBox(height: spacing.md),
                                    Divider(
                                      color: theme.colorScheme.outlineVariant,
                                    ),
                                    SizedBox(height: spacing.md),
                                  ],
                                  _AddressSection(
                                    data: _addresses[i],
                                    onRemove: _addresses.length > 1
                                        ? () => _removeAddress(i)
                                        : null,
                                  ),
                                ],
                                SizedBox(height: spacing.sm),
                                DashedAddButton(
                                  label: lang.addAnotherAddress,
                                  onTap: _addAddress,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  _Footer(
                    isEditMode: _isEditMode,
                    onCancel: () => Navigator.of(context).pop(),
                    onSave: _save,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Header
// -----------------------------------------------------------------------------
class _Header extends StatelessWidget {
  const _Header({required this.title, required this.onClose});

  final String title;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: spacing.lg,
        vertical: spacing.md,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.25),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onPrimary,
            ),
          ),
          InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: onClose,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Icon(Icons.close, color: theme.colorScheme.onSecondary),
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Footer (Save / Cancel)
// -----------------------------------------------------------------------------
class _Footer extends StatelessWidget {
  const _Footer({
    required this.isEditMode,
    required this.onCancel,
    required this.onSave,
  });

  final bool isEditMode;
  final VoidCallback onCancel;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final lang = S.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(spacing.lg),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: theme.colorScheme.outlineVariant),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          OutlinedButton(
            onPressed: onCancel,
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(
                horizontal: spacing.lg,
                vertical: spacing.sm + spacing.xxs,
              ),
              side: BorderSide(color: theme.colorScheme.outlineVariant),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(spacing.radiusMd),
              ),
            ),
            child: Text(
              lang.cancel,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onPrimary,
              ),
            ),
          ),
          SizedBox(width: spacing.sm),
          ElevatedButton(
            onPressed: onSave,
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
              padding: EdgeInsets.symmetric(
                horizontal: spacing.xl,
                vertical: spacing.sm + spacing.xxs,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(spacing.radiusMd),
              ),
            ),
            child: Text(
              lang.save,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// One address block (city / district / street / building / floor / apt / notes)
// -----------------------------------------------------------------------------
class _AddressSection extends StatelessWidget {
  const _AddressSection({required this.data, this.onRemove});

  final _AddressData data;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final lang = S.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (onRemove != null)
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: Icon(Icons.close, size: 18, color: theme.colorScheme.error),
              onPressed: onRemove,
            ),
          ),

        // Row: المدينة (right) / الحي (left)
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _FieldLabel(label: lang.city),
                  SizedBox(height: spacing.xxs),
                  _CityDropdown(controller: data.cityController),
                ],
              ),
            ),
            SizedBox(width: spacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _FieldLabel(label: lang.district),
                  SizedBox(height: spacing.xxs),
                  _DialogTextField(
                    controller: data.districtController,
                    hintText: lang.district,
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: spacing.sm),

        // Row: اسم الشارع (right) / رقم البناية (left)
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _FieldLabel(label: lang.streetName),
                  SizedBox(height: spacing.xxs),
                  _DialogTextField(
                    controller: data.streetController,
                    hintText: lang.streetName,
                  ),
                ],
              ),
            ),
            SizedBox(width: spacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _FieldLabel(label: lang.buildingNumber),
                  SizedBox(height: spacing.xxs),
                  _DialogTextField(
                    controller: data.buildingController,
                    hintText: 'مثال: 1234',
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: spacing.sm),

        // Row: الدور (right) / رقم الشقة (left)
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _FieldLabel(label: lang.floor),
                  SizedBox(height: spacing.xxs),
                  _DialogTextField(
                    controller: data.floorController,
                    hintText: 'مثال: الثالث',
                  ),
                ],
              ),
            ),
            SizedBox(width: spacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _FieldLabel(label: lang.apartmentNumber),
                  SizedBox(height: spacing.xxs),
                  _DialogTextField(
                    controller: data.apartmentController,
                    hintText: 'مثال: 12',
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: spacing.sm),

        _FieldLabel(label: 'ملاحظات العنوان'),
        SizedBox(height: spacing.xxs),
        _DialogTextField(
          controller: data.notesController,
          hintText: 'أي ملاحظات إضافية...',
          maxLines: 3,
        ),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// City dropdown — replace `_kCities` with a real API-backed list when
// available; kept static here to match the design shown.
// -----------------------------------------------------------------------------
const List<String> _kCities = [
  'الرياض',
  'جدة',
  'مكة المكرمة',
  'المدينة المنورة',
  'الدمام',
  'الخبر',
];

class _CityDropdown extends StatelessWidget {
  const _CityDropdown({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;

    return DropdownButtonFormField<String>(
      initialValue: controller.text.isEmpty ? null : controller.text,
      icon: Icon(
        Icons.keyboard_arrow_down,
        color: theme.colorScheme.onSecondary,
      ),
      decoration: InputDecoration(
        hintText: 'اختر المدينة',
        filled: true,
        fillColor: theme.colorScheme.onSurface,
        contentPadding: EdgeInsets.symmetric(
          horizontal: spacing.sm,
          vertical: spacing.sm,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(spacing.radiusMd),
          borderSide: BorderSide(color: theme.colorScheme.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(spacing.radiusMd),
          borderSide: BorderSide(color: theme.colorScheme.outlineVariant),
        ),
      ),
      items: _kCities
          .map((city) => DropdownMenuItem(value: city, child: Text(city)))
          .toList(),
      onChanged: (value) => controller.text = value ?? '',
    );
  }
}

// -----------------------------------------------------------------------------
// Shared field styling
// -----------------------------------------------------------------------------
class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.label, this.isRequired = false});

  final String label;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return RichText(
      text: TextSpan(
        text: label,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onPrimary,
        ),
        children: [
          if (isRequired)
            TextSpan(
              text: ' *',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.errorContainer,
              ),
            ),
        ],
      ),
    );
  }
}

class _DialogTextField extends StatelessWidget {
  const _DialogTextField({
    required this.controller,
    this.hintText,
    this.keyboardType,
    this.validator,
    this.maxLines = 1,
  });

  final TextEditingController controller;
  final String? hintText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;

    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: theme.colorScheme.onSurface,
        contentPadding: EdgeInsets.symmetric(
          horizontal: spacing.sm,
          vertical: spacing.sm,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(spacing.radiusMd),
          borderSide: BorderSide(color: theme.colorScheme.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(spacing.radiusMd),
          borderSide: BorderSide(color: theme.colorScheme.outlineVariant),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Per-address form data
// -----------------------------------------------------------------------------
class _AddressData {
  final int? id;
  final TextEditingController cityController;
  final TextEditingController districtController;
  final TextEditingController streetController;
  final TextEditingController buildingController;
  final TextEditingController floorController;
  final TextEditingController apartmentController;
  final TextEditingController notesController;
  bool isDefault;

  _AddressData({
    this.id,
    String? city,
    String? district,
    String? street,
    String? building,
    String? floor,
    String? apartment,
    String? notes,
    this.isDefault = false,
  }) : cityController = TextEditingController(text: city),
       districtController = TextEditingController(text: district),
       streetController = TextEditingController(text: street),
       buildingController = TextEditingController(text: building),
       floorController = TextEditingController(text: floor),
       apartmentController = TextEditingController(text: apartment),
       notesController = TextEditingController(text: notes);

  factory _AddressData.fromModel(ClientAddressModel address) {
    return _AddressData(
      id: address.id,
      city: address.city,
      district: address.district,
      street: address.street,
      building: address.buildingNo,
      floor: address.floor,
      apartment: address.apartmentNo,
      isDefault: address.isDefault ?? false,
    );
  }

  void dispose() {
    cityController.dispose();
    districtController.dispose();
    streetController.dispose();
    buildingController.dispose();
    floorController.dispose();
    apartmentController.dispose();
    notesController.dispose();
  }
}

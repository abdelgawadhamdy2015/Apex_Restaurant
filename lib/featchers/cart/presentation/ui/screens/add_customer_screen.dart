import 'package:apex_restaurant/core/helpers/extensions.dart';
import 'package:apex_restaurant/core/helpers/helper_methods.dart';
import 'package:apex_restaurant/core/shared/widgets/custom_app_bar.dart';
import 'package:apex_restaurant/core/themes/app_colors.dart';
import 'package:apex_restaurant/featchers/cart/data/models/client_request_model.dart';
import 'package:apex_restaurant/featchers/cart/data/models/get_client_request.dart';
import 'package:apex_restaurant/featchers/cart/presentation/bloc/cart_bloc.dart';
import 'package:apex_restaurant/featchers/cart/presentation/bloc/cart_event.dart';
import 'package:apex_restaurant/featchers/cart/presentation/bloc/cart_state.dart';
import 'package:apex_restaurant/featchers/cart/presentation/ui/widgets/dashed_add_address_button.dart';
import 'package:apex_restaurant/featchers/home/data/models/employee_branch.dart';
import 'package:apex_restaurant/featchers/home/presentation/bloc/home_bloc.dart';
import 'package:apex_restaurant/featchers/home/presentation/bloc/home_state.dart';
import 'package:apex_restaurant/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/pos_client_model.dart';

class AddCustomerScreen extends StatefulWidget {
  const AddCustomerScreen({super.key, this.selectedPerson});
  final PosClientModel? selectedPerson;

  @override
  State<AddCustomerScreen> createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends State<AddCustomerScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _altPhoneController = TextEditingController();

  final List<_AddressFormData> _addresses = [];
  List<int> _selectedBranchIds = [];

  bool get _isEditMode => widget.selectedPerson != null;

  @override
  void initState() {
    super.initState();
    _populateDataForEditMode();
  }

  void _populateDataForEditMode() {
    if (_isEditMode) {
      final person = widget.selectedPerson!;
      _nameController.text = person.arabicName;
      if (person.branches.isNotEmpty) {
        _selectedBranchIds = person.branches;
      }
      // Safe phone number population
      if (person.personPhones?.isNotEmpty == true) {
        _phoneController.text = person.personPhones!.first.phoneNumber ?? '';
        if (person.personPhones!.length > 1) {
          _altPhoneController.text = person.personPhones![1].phoneNumber ?? '';
        }
      }

      // Safe address population
      if (person.personAddress?.isNotEmpty == true) {
        for (var addr in person.personAddress!) {
          _addresses.add(_AddressFormData.fromModel(addr));
        }
      } else {
        _addresses.add(_AddressFormData());
      }
    } else {
      _addresses.add(_AddressFormData());
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

  void _addAddress() {
    setState(() => _addresses.add(_AddressFormData()));
  }

  void _removeAddress(int index) {
    if (_addresses.length <= 1) return;
    setState(() => _addresses.removeAt(index).dispose());
  }

  void _save() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    // 1. Build Phones
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

    // 2. Build Addresses
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

    // 3. Construct Request Model
    final request = ClientRequestModel(
      id: widget.selectedPerson?.id,
      name: _nameController.text.trim(),
      phones: phones,
      addresses: addresses,
      branches: _selectedBranchIds,
    );

    // 4. Dispatch Event
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
          Navigator.pop(context, true);
        } else if (state.status == CartStatus.failure) {
          HelperMethods.showSnackBar(
            context: context,
            message: state.errorMessage ?? 'An error occurred',
            isError: true,
          );
        }
      },
      child: Scaffold(
        backgroundColor: theme.colorScheme.surface,
        appBar: CustomAppBar(
          title: _isEditMode ? lang.editCustomer : lang.addNewCustomer,
          showBackButton: true,
          onBackPressed: () => Navigator.pop(context),
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(spacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _FieldLabel(label: lang.fullName, isResuired: true),
                SizedBox(height: spacing.xxs),
                _FormTextField(
                  controller: _nameController,
                  fillcolor: theme.colorScheme.onSurface,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter customer name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: spacing.md),
                // Branch Multi-Select Field
                BlocBuilder<HomeBloc, HomeState>(
                  builder: (context, state) {
                    return BranchMultiSelectDropdown(
                      branches: state.branches,
                      selectedBranchIds: _selectedBranchIds,
                      onChanged: (selected) {
                        setState(() => _selectedBranchIds = selected);
                      },
                    );
                  },
                ),
                SizedBox(height: spacing.md),
                _FieldLabel(label: lang.phone, isResuired: true),
                SizedBox(height: spacing.xxs),
                _FormTextField(
                  controller: _phoneController,
                  fillcolor: theme.colorScheme.onSurface,

                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter phone number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: spacing.md),

                _FieldLabel(label: lang.alternatePhoneOptional),
                SizedBox(height: spacing.xxs),
                _FormTextField(
                  controller: _altPhoneController,
                  fillcolor: theme.colorScheme.onSurface,

                  keyboardType: TextInputType.phone,
                ),
                SizedBox(height: spacing.lg),

                Text(
                  lang.customerAddresses,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: spacing.xxs),
                Text(
                  lang.addMoreAddressesHint,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.secondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: spacing.sm),

                Container(
                  padding: EdgeInsets.all(spacing.md),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onSurface,
                    borderRadius: BorderRadius.circular(spacing.radiusLg),
                    border: Border.all(color: theme.colorScheme.outlineVariant),
                  ),
                  child: Column(
                    children: [
                      for (var i = 0; i < _addresses.length; i++) ...[
                        if (i > 0) ...[
                          SizedBox(height: spacing.md),
                          Divider(color: theme.colorScheme.outlineVariant),
                          SizedBox(height: spacing.md),
                        ],
                        _AddressFormSection(
                          data: _addresses[i],
                          onRemove: _addresses.length > 1
                              ? () => _removeAddress(i)
                              : null,
                        ),
                      ],
                    ],
                  ),
                ),
                SizedBox(height: spacing.sm),

                DashedAddButton(
                  label: lang.addAnotherAddress,
                  onTap: _addAddress,
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            return _BottomBar(
              isEditMode: _isEditMode,
              isLoading: state.isLoading,
              onCancel: () => Navigator.pop(context),
              onSave: _save,
            );
          },
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Form Data Wrapper Class
// -----------------------------------------------------------------------------

class _AddressFormData {
  final int? id;
  final TextEditingController cityController;
  final TextEditingController districtController;
  final TextEditingController streetController;
  final TextEditingController buildingController;
  final TextEditingController floorController;
  final TextEditingController apartmentController;
  bool isDefault;

  _AddressFormData({
    this.id,
    String? city,
    String? district,
    String? street,
    String? building,
    String? floor,
    String? apartment,
    this.isDefault = false,
  }) : cityController = TextEditingController(text: city),
       districtController = TextEditingController(text: district),
       streetController = TextEditingController(text: street),
       buildingController = TextEditingController(text: building),
       floorController = TextEditingController(text: floor),
       apartmentController = TextEditingController(text: apartment);

  factory _AddressFormData.fromModel(ClientAddressModel address) {
    return _AddressFormData(
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
  }
}

// -----------------------------------------------------------------------------
// Helper Sub-Widgets
// -----------------------------------------------------------------------------

class _FormTextField extends StatelessWidget {
  const _FormTextField({
    required this.controller,
    this.keyboardType,
    this.validator,
    this.fillcolor,
  });

  final TextEditingController controller;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final Color? fillcolor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        fillColor: fillcolor ?? theme.colorScheme.surface,
      ),
    );
  }
}

class BranchMultiSelectDropdown extends StatefulWidget {
  const BranchMultiSelectDropdown({
    super.key,
    required this.branches,
    required this.selectedBranchIds,
    required this.onChanged,
  });

  final List<EmployeeBranch> branches;
  final List<int> selectedBranchIds;
  final ValueChanged<List<int>> onChanged;

  @override
  State<BranchMultiSelectDropdown> createState() =>
      _BranchMultiSelectDropdownState();
}

class _BranchMultiSelectDropdownState extends State<BranchMultiSelectDropdown> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;

  late List<int> _localSelected;

  @override
  void initState() {
    super.initState();
    _localSelected = List<int>.from(widget.selectedBranchIds);
  }

  @override
  void didUpdateWidget(covariant BranchMultiSelectDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!_listEquals(oldWidget.selectedBranchIds, widget.selectedBranchIds) &&
        !_listEquals(_localSelected, widget.selectedBranchIds)) {
      _localSelected = List<int>.from(widget.selectedBranchIds);
    }
  }

  bool _listEquals(List<int> a, List<int> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  void _toggleBranch(int branchId) {
    setState(() {
      if (_localSelected.contains(branchId)) {
        _localSelected.remove(branchId);
      } else {
        _localSelected.add(branchId);
      }
    });
    widget.onChanged(List<int>.from(_localSelected));
    _overlayEntry?.markNeedsBuild();
  }

  void _toggleOverlay() {
    if (_isOpen) {
      _closeMenu();
    } else {
      _openMenu();
    }
  }

  void _openMenu() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    setState(() => _isOpen = true);
  }

  void _closeMenu() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (mounted) setState(() => _isOpen = false);
  }

  OverlayEntry _createOverlayEntry() {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final theme = Theme.of(context);
    return OverlayEntry(
      builder: (context) => Stack(
        children: [
          GestureDetector(
            onTap: _closeMenu,
            behavior: HitTestBehavior.translucent,
            child: const SizedBox.expand(),
          ),
          Positioned(
            width: size.width,
            child: CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: Offset(0, size.height + 4),
              child: Material(
                elevation: 6,
                borderRadius: BorderRadius.circular(8),
                color: Theme.of(context).colorScheme.surface,
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Theme.of(context).colorScheme.surface,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: widget.branches.map((branch) {
                      final isSelected = _localSelected.contains(
                        branch.branchId,
                      );
                      return InkWell(
                        onTap: () => _toggleBranch(branch.branchId),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: Checkbox(
                                  activeColor: theme.colorScheme.primary,
                                  value: isSelected,
                                  onChanged: (_) =>
                                      _toggleBranch(branch.branchId),
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  branch.arabicName,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lang = S.of(context);

    final selectedNames = widget.branches
        .where((b) => _localSelected.contains(b.branchId))
        .map((b) => b.arabicName)
        .join(', ');

    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: _toggleOverlay,
        child: InputDecorator(
          decoration: InputDecoration(
            label: RichText(
              text: TextSpan(
                text: lang.branches,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onPrimary,
                ),
                children: const [
                  TextSpan(
                    text: ' *',
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              ),
            ),
            suffixIcon: Icon(
              _isOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              color: theme.colorScheme.onSecondary,
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: context.spacing.sm,
              vertical: context.spacing.sm,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(context.spacing.radiusSm),
              borderSide: BorderSide(color: theme.colorScheme.primary),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: _isOpen
                    ? theme.colorScheme.primary
                    : theme.colorScheme.outlineVariant,
              ),
            ),
          ),
          child: Text(
            selectedNames.isEmpty ? '' : selectedNames,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyMedium,
          ),
        ),
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({
    required this.isEditMode,
    required this.isLoading,
    required this.onCancel,
    required this.onSave,
  });

  final bool isEditMode;
  final bool isLoading;
  final VoidCallback onCancel;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final icons = context.iconSizes;
    final lang = S.of(context);

    return Container(
      padding: EdgeInsets.all(spacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          top: BorderSide(color: theme.colorScheme.outlineVariant),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                  padding: EdgeInsets.symmetric(
                    vertical: spacing.sm + spacing.xxs / 2,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(spacing.radiusMd),
                  ),
                ),
                onPressed: isLoading ? null : onSave,
                icon: isLoading
                    ? SizedBox(
                        width: icons.sm,
                        height: icons.sm,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Icon(
                        isEditMode
                            ? Icons.save_outlined
                            : Icons.check_circle_outline,
                        size: icons.sm,
                      ),
                label: Text(
                  isEditMode ? lang.save : lang.save,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(width: spacing.sm),

            Expanded(
              child: OutlinedButton(
                onPressed: isLoading ? null : onCancel,
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    vertical: spacing.sm + spacing.xxs / 2,
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
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.label, this.isResuired = false});

  final String label;
  final bool isResuired;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return RichText(
      text: TextSpan(
        text: label,
        style: theme.textTheme.bodyMedium?.copyWith(),
        children: [
          if (isResuired)
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

class _AddressFormSection extends StatefulWidget {
  const _AddressFormSection({required this.data, this.onRemove});

  final _AddressFormData data;
  final VoidCallback? onRemove;

  @override
  State<_AddressFormSection> createState() => _AddressFormSectionState();
}

class _AddressFormSectionState extends State<_AddressFormSection> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final icons = context.iconSizes;
    final lang = S.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Checkbox(
              value: widget.data.isDefault,
              onChanged: (val) {
                setState(() {
                  widget.data.isDefault = val ?? false;
                });
              },
            ),
            Text(lang.isDefaultAddress, style: theme.textTheme.bodyMedium),
            const Spacer(),
            if (widget.onRemove != null)
              IconButton(
                icon: Icon(
                  Icons.close,
                  size: icons.sm,
                  color: theme.colorScheme.error,
                ),
                onPressed: widget.onRemove,
              ),
          ],
        ),

        _FieldLabel(label: lang.city, isResuired: true),
        SizedBox(height: spacing.xxs),
        _FormTextField(controller: widget.data.cityController),
        SizedBox(height: spacing.sm),

        _FieldLabel(label: lang.district, isResuired: true),
        SizedBox(height: spacing.xxs),
        _FormTextField(controller: widget.data.districtController),
        SizedBox(height: spacing.sm),

        _FieldLabel(label: lang.streetName),
        SizedBox(height: spacing.xxs),
        _FormTextField(controller: widget.data.streetController),
        SizedBox(height: spacing.sm),

        _FieldLabel(label: lang.buildingNumber),
        SizedBox(height: spacing.xxs),
        _FormTextField(
          controller: widget.data.buildingController,
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: spacing.sm),

        _FieldLabel(label: lang.floor),
        SizedBox(height: spacing.xxs),
        _FormTextField(
          controller: widget.data.floorController,
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: spacing.sm),

        _FieldLabel(label: lang.apartmentNumber),
        SizedBox(height: spacing.xxs),
        _FormTextField(
          controller: widget.data.apartmentController,
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }
}

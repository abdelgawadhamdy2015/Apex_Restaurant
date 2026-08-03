import 'package:apex_restaurant/core/helpers/extensions.dart';
import 'package:apex_restaurant/core/router/routes.dart';
import 'package:apex_restaurant/featchers/cart/data/models/pos_client_model.dart';
import 'package:apex_restaurant/featchers/cart/presentation/bloc/cart_bloc.dart';
import 'package:apex_restaurant/featchers/cart/presentation/bloc/cart_event.dart';
import 'package:apex_restaurant/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Bottom sheet listing the customer's saved addresses, with an option
/// to add a new one or edit the customer to add an address.
class AddressPickerSheet extends StatelessWidget {
  const AddressPickerSheet({
    super.key,
    required this.addresses,
    required this.selectedAddress,
  });

  final List<ClientAddressModel> addresses;
  final ClientAddressModel? selectedAddress;

  /// Opens this sheet as a modal bottom sheet, forwarding the given
  /// [cartBloc] so address selection events reach the cart screen.
  static void show(
    BuildContext context, {
    required CartBloc cartBloc,
    required List<ClientAddressModel> addresses,
    required ClientAddressModel? selectedAddress,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => Directionality(
        textDirection: TextDirection.rtl,
        child: BlocProvider.value(
          value: cartBloc,
          child: AddressPickerSheet(
            addresses: addresses,
            selectedAddress: selectedAddress,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final lang = S.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(spacing.radiusPill),
        ),
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.all(spacing.md),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                lang.changeAddress,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: spacing.md),
              _AddNewAddressButton(),
              SizedBox(height: spacing.md),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: addresses.length,
                  separatorBuilder: (_, __) => SizedBox(height: spacing.sm),
                  itemBuilder: (context, index) => _AddressOption(
                    address: addresses[index],
                    selectedAddressId: selectedAddress?.id,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddNewAddressButton extends StatelessWidget {
  const _AddNewAddressButton();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final lang = S.of(context);

    return InkWell(
      onTap: () {
        Navigator.pop(context);
        context.pushNamed(
          Routes.addCustomerScreen,
          extra: context.read<CartBloc>().state.selectedPerson,
        );
      },
      borderRadius: BorderRadius.circular(spacing.radiusMd),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          vertical: spacing.sm + spacing.xxs,
          horizontal: spacing.md,
        ),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withOpacity(0.05),
          borderRadius: BorderRadius.circular(spacing.radiusMd),
          border: Border.all(color: theme.colorScheme.primary.withOpacity(0.5)),
        ),
        child: Text(
          '+ ${lang.addNewAddress}',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class _AddressOption extends StatelessWidget {
  const _AddressOption({
    required this.address,
    required this.selectedAddressId,
  });

  final ClientAddressModel address;
  final int? selectedAddressId;

  void _select(BuildContext context) {
    context.read<CartBloc>().add(ChangeAddressEvent(address));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final isSelected = address.id == selectedAddressId;

    return InkWell(
      onTap: () => _select(context),
      borderRadius: BorderRadius.circular(spacing.radiusMd),
      child: Container(
        padding: EdgeInsets.all(spacing.sm),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary.withOpacity(0.05)
              : null,
          borderRadius: BorderRadius.circular(spacing.radiusMd),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.outlineVariant,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    address.city ?? '',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: spacing.xxs),
                  Text(
                    address.fullAddress,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Radio<int>(
              value: address.id,
              groupValue: selectedAddressId,
              activeColor: theme.colorScheme.primary,
              onChanged: (_) => _select(context),
            ),
          ],
        ),
      ),
    );
  }
}

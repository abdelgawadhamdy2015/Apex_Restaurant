import '../../../../../core/helpers/extensions.dart';
import '../../../data/models/pos_client_model.dart';
import '../../bloc/cart_bloc.dart';
import 'address_picker_sheet.dart';
import '../../../../../generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Shows the selected delivery address and lets the user change it
/// via [AddressPickerSheet].
class AddressCard extends StatelessWidget {
  const AddressCard({
    super.key,
    required this.selectedAddress,
    required this.addresses,
  });

  final ClientAddressModel? selectedAddress;
  final List<ClientAddressModel> addresses;

  void _openAddressPicker(BuildContext context) {
    AddressPickerSheet.show(
      context,
      cartBloc: context.read<CartBloc>(),
      addresses: addresses,
      selectedAddress: selectedAddress,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final icons = context.iconSizes;
    final lang = S.of(context);
    final cartState = context.read<CartBloc>().state;
    return Container(
      padding: EdgeInsets.all(spacing.sm),
      decoration: BoxDecoration(
        color: theme.colorScheme.onSurface,
        borderRadius: BorderRadius.circular(spacing.radiusLg),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: icons.sm,
                    color: theme.colorScheme.primary,
                  ),
                  SizedBox(width: spacing.xxs),

                  Text(
                    '${lang.address}: ${selectedAddress?.id.toString() ?? ''}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: cartState.canEdit
                    ? () => _openAddressPicker(context)
                    : null,
                borderRadius: BorderRadius.circular(spacing.radiusMd),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: spacing.xxs,
                    vertical: spacing.xxs,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        lang.changeAddress,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                          decorationColor: theme.colorScheme.primary,
                        ),
                      ),
                      SizedBox(width: spacing.xxs),

                      Icon(
                        Icons.chevron_right,
                        size: icons.sm,
                        color: theme.colorScheme.primary,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (selectedAddress != null) ...[
            SizedBox(height: spacing.xxs),
            Text(
              selectedAddress!.fullAddress,
              textAlign: TextAlign.right,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

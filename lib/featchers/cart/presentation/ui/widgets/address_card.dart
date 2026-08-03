import 'package:apex_restaurant/core/helpers/extensions.dart';
import 'package:apex_restaurant/featchers/cart/data/models/pos_client_model.dart';
import 'package:apex_restaurant/featchers/cart/presentation/bloc/cart_bloc.dart';
import 'package:apex_restaurant/featchers/cart/presentation/ui/widgets/address_picker_sheet.dart';
import 'package:apex_restaurant/generated/l10n.dart';
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

    return Container(
      padding: EdgeInsets.all(spacing.sm),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
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
                  Text(
                    '${lang.address}: ${selectedAddress?.id.toString() ?? ''}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(width: spacing.xxs),
                  Icon(
                    Icons.location_on_outlined,
                    size: icons.sm,
                    color: theme.colorScheme.primary,
                  ),
                ],
              ),
              InkWell(
                onTap: () => _openAddressPicker(context),
                borderRadius: BorderRadius.circular(spacing.radiusMd),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: spacing.xxs,
                    vertical: spacing.xxs,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.chevron_left,
                        size: icons.sm,
                        color: theme.colorScheme.onSurface,
                      ),
                      SizedBox(width: spacing.xxs),
                      Text(
                        lang.changeAddress,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                        ),
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
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

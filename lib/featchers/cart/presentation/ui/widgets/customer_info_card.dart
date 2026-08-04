import 'package:apex_restaurant/core/helpers/extensions.dart';
import 'package:apex_restaurant/core/helpers/helper_methods.dart';
import 'package:apex_restaurant/core/router/routes.dart';
import 'package:apex_restaurant/featchers/cart/data/models/pos_client_model.dart';
import 'package:apex_restaurant/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Shows the currently selected customer (or a placeholder) with
/// shortcuts to add or edit a customer.
class CustomerInfoCard extends StatelessWidget {
  const CustomerInfoCard({
    super.key,
    required this.persons,
    this.selectedPerson,
  });

  final List<PosClientModel> persons;
  final PosClientModel? selectedPerson;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final icons = context.iconSizes;
    final lang = S.of(context);
    final phones = selectedPerson?.personPhones;

    return Container(
      padding: EdgeInsets.all(spacing.sm),
      decoration: BoxDecoration(
        color: theme.colorScheme.onSurface,
        borderRadius: BorderRadius.circular(spacing.radiusLg),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: theme.colorScheme.primary.withOpacity(.5),
            radius: icons.lg - icons.sm / 2,
            child: Icon(
              Icons.person,
              color: theme.colorScheme.primary,
              size: icons.lg,
            ),
          ),
          SizedBox(width: spacing.sm),
          Expanded(
            child: GestureDetector(
              onTap: () => HelperMethods.openPicker(context, persons),
              behavior: HitTestBehavior.opaque,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    selectedPerson?.arabicName ?? lang.noCustomerSelected,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                  if (phones != null && phones.isNotEmpty)
                    Text(
                      phones.first.phoneNumber.toString(),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSecondary,
                      ),
                    ),
                ],
              ),
            ),
          ),
          IconButton(
            onPressed: () => context.pushNamed(Routes.addCustomerScreen),
            icon: Icon(
              Icons.person_add_outlined,
              size: icons.lg,
              color: theme.colorScheme.primary,
            ),
          ),
          IconButton(
            onPressed: () => context.pushNamed(
              Routes.addCustomerScreen,
              extra: selectedPerson,
            ),
            icon: Icon(
              Icons.edit,
              size: icons.lg,
              color: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}

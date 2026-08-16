import '../../../../../core/helpers/extensions.dart';
import '../../bloc/cart_bloc.dart';
import '../../bloc/cart_event.dart';
import '../../../../pos/data/models/delivery_company.dart';
import '../../../../../generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Dropdown for choosing which delivery company handles the order.
class DeliveryCompanySelector extends StatelessWidget {
  const DeliveryCompanySelector({super.key, required this.deliveryCompanies});

  final List<DeliveryCompanyModel> deliveryCompanies;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final lang = S.of(context);

    return Container(
      padding: EdgeInsets.all(spacing.sm),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
        borderRadius: BorderRadius.circular(spacing.radiusLg),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: DropdownButtonFormField<DeliveryCompanyModel?>(
        decoration: InputDecoration(
          hintText: lang.deliveryCompanyDetails,
          prefixIcon: Icon(
            Icons.storefront,
            color: theme.colorScheme.primary,
            size: context.iconSizes.md,
          ),
        ),
        items: deliveryCompanies
            .map(
              (company) => DropdownMenuItem<DeliveryCompanyModel?>(
                value: company,
                child: Text(company.arabicName ?? ''),
              ),
            )
            .toList(),
        onChanged: (val) {
          if (val == null) return;
          context.read<CartBloc>().add(
            SelectDeliveryCompanyEvent(deliveryCompanyModel: val),
          );
        },
      ),
    );
  }
}

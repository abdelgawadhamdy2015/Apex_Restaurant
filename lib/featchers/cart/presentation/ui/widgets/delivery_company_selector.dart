import 'package:apex_restaurant/core/helpers/extensions.dart';
import 'package:apex_restaurant/featchers/cart/presentation/bloc/cart_bloc.dart';
import 'package:apex_restaurant/featchers/cart/presentation/bloc/cart_event.dart';
import 'package:apex_restaurant/featchers/pos/data/models/delivery_company.dart';
import 'package:apex_restaurant/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeliveryCompanySelector extends StatelessWidget {
  const DeliveryCompanySelector({super.key});

  @override
  Widget build(BuildContext context) {
    final cartState = context.watch<CartBloc>().state;

    final canEdit = cartState.canEdit;
    final companies = cartState.companiesList;
    final selectedCompany = cartState.selectedDeliveryCompany;

    final theme = Theme.of(context);
    final spacing = context.spacing;
    final lang = S.of(context);

    // Get the selected object from the CURRENT companies list.
    final currentSelectedCompany = selectedCompany == null
        ? null
        : companies
              .where((company) => company.id == selectedCompany.id)
              .firstOrNull;

    return Container(
      padding: EdgeInsets.all(spacing.sm),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
        borderRadius: BorderRadius.circular(spacing.radiusLg),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: DropdownButtonFormField<DeliveryCompanyModel>(
        initialValue: currentSelectedCompany,
        decoration: InputDecoration(
          hintText: lang.deliveryCompanyDetails,
          prefixIcon: Icon(
            Icons.storefront,
            color: theme.colorScheme.primary,
            size: context.iconSizes.md,
          ),
        ),
        items: companies
            .map(
              (company) => DropdownMenuItem<DeliveryCompanyModel>(
                value: company,
                child: Text(company.arabicName ?? ''),
              ),
            )
            .toList(),
        onChanged: canEdit
            ? (val) {
                if (val == null) return;

                context.read<CartBloc>().add(
                  SelectDeliveryCompanyEvent(deliveryCompanyModel: val),
                );
              }
            : null,
      ),
    );
  }
}

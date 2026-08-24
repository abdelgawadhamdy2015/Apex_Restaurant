import '../../../../../core/helpers/extensions.dart';
import '../../../data/models/waiter_model.dart';
import '../../bloc/cart_bloc.dart';
import '../../bloc/cart_event.dart';
import '../../../../../generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Dropdown for choosing the delivery agent (rider) for a delivery order.
class DeliveryAgentSelector extends StatelessWidget {
  const DeliveryAgentSelector({super.key, required this.deliveryMens});

  final List<WaiterModel> deliveryMens;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final lang = S.of(context);
    final canEdit = context.select((CartBloc b) => b.state.canEdit);

    return Container(
      padding: EdgeInsets.all(spacing.sm),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
        borderRadius: BorderRadius.circular(spacing.radiusLg),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: DropdownButtonFormField<WaiterModel?>(
        decoration: InputDecoration(
          hintText: lang.selectDeliveryAgent,
          prefixIcon: Icon(
            Icons.two_wheeler,
            color: theme.colorScheme.primary,
            size: context.iconSizes.md,
          ),
        ),
        items: deliveryMens
            .map(
              (waiter) => DropdownMenuItem<WaiterModel?>(
                value: waiter,
                child: Text(waiter.arabicName ?? ''),
              ),
            )
            .toList(),
        onChanged: canEdit
            ? (val) => context.read<CartBloc>().add(SelectDeliveryManEvent(val))
            : null,
      ),
    );
  }
}

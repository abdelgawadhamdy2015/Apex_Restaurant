// lib/featchers/pos/presentation/widgets/add_to_cart_bar.dart
import 'package:apex_restaurant/core/helpers/extensions.dart';
import 'package:apex_restaurant/featchers/pos/presentation/widgets/quantity_counter.dart';
import 'package:flutter/material.dart';

/// Fixed bottom panel of the item customization sheet: quantity stepper
/// + confirm button showing the live total price.
class AddToCartBar extends StatelessWidget {
  const AddToCartBar({
    super.key,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
    required this.totalPrice,
    required this.onConfirm,
  });

  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final double totalPrice;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Divider(height: 1),
        Padding(
          padding: EdgeInsets.only(
            left: spacing.md,
            right: spacing.md,
            top: spacing.md,
            bottom: MediaQuery.of(context).viewInsets.bottom + spacing.md,
          ),
          child: Row(
            children: [
              QuantityCounter(
                quantity: quantity,
                onIncrement: onIncrement,
                onDecrement: onDecrement,
              ),
              SizedBox(width: spacing.sm),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    padding: EdgeInsets.symmetric(vertical: spacing.md),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(spacing.radiusLg),
                    ),
                  ),
                  onPressed: onConfirm,
                  child: Text(
                    'أضف للسلة ${totalPrice.toStringAsFixed(2)} ر.س',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

import '../../../../core/helpers/extensions.dart';
import '../../../../core/themes/app_colors.dart';
import 'quantity_counter.dart';
import '../../../../generated/l10n.dart';
import 'package:flutter/material.dart';

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
    final lang = S.of(context);

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
                    lang.addToCartWithPrice(totalPrice.toStringAsFixed(2)),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.normal,
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

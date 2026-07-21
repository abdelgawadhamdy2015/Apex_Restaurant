// lib/featchers/pos/presentation/widgets/quantity_counter.dart
import 'package:apex_restaurant/core/helpers/extensions.dart';
import 'package:flutter/material.dart';

/// Compact +/- quantity stepper used at the bottom of the item
/// customization sheet.
class QuantityCounter extends StatelessWidget {
  const QuantityCounter({
    super.key,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
  });

  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;

    return Container(
      decoration: BoxDecoration(
        // Was a manual `theme.brightness == Brightness.light ? ... : ...`
        // check with two hardcoded hex colors. surfaceContainerHighest is
        // the M3 token for exactly this "slightly raised chip" background,
        // and it already resolves correctly per theme on its own.
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(spacing.radiusLg),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: onIncrement,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: spacing.md),
            child: Text(
              '$quantity',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.remove),
            onPressed: onDecrement,
          ),
        ],
      ),
    );
  }
}

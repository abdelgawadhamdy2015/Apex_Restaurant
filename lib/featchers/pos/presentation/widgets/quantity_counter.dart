import '../../../../core/helpers/extensions.dart';
import 'package:flutter/material.dart';

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
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(spacing.radiusLg),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.add),
            color: theme.colorScheme.onSecondary,
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
            color: theme.colorScheme.onSecondary,
            onPressed: onDecrement,
          ),
        ],
      ),
    );
  }
}

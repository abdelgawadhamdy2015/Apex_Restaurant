import 'package:apex_restaurant/core/helpers/extensions.dart';
import 'package:apex_restaurant/generated/l10n.dart';
import 'package:flutter/material.dart';

class DiscountTypeToggle extends StatelessWidget {
  const DiscountTypeToggle({
    super.key,
    required this.isPercentage,
    required this.onChanged,
  });

  final bool isPercentage;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    final lang = S.of(context);

    return Row(
      children: [
        Expanded(
          child: _Option(
            label: lang.percentageDiscount,
            isSelected: isPercentage,
            onTap: () => onChanged(true),
          ),
        ),
        SizedBox(width: spacing.sm),
        Expanded(
          child: _Option(
            label: lang.fixedAmountDiscount,
            isSelected: !isPercentage,
            onTap: () => onChanged(false),
          ),
        ),
      ],
    );
  }
}

class _Option extends StatelessWidget {
  const _Option({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final iconSizes = context.iconSizes;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: spacing.sm),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary.withOpacity(0.04)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(spacing.radiusLg),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.outlineVariant,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurfaceVariant,
              size: iconSizes.md,
            ),
            SizedBox(width: spacing.xs),
            Text(label, style: theme.textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}

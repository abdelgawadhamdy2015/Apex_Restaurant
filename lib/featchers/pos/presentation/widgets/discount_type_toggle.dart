import 'package:apex_restaurant/core/helpers/extensions.dart';
import 'package:apex_restaurant/generated/l10n.dart';
import 'package:flutter/material.dart';

class DiscountTypeToggle extends StatelessWidget {
  const DiscountTypeToggle({
    super.key,
    required this.isPercentage,
    required this.onChanged,
    required this.enabled,
  });

  final bool isPercentage;
  final ValueChanged<bool> onChanged;
  final bool enabled;

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
            onTap: enabled ? () => onChanged(true) : null,
          ),
        ),
        SizedBox(width: spacing.sm),
        Expanded(
          child: _Option(
            label: lang.fixedAmountDiscount,
            isSelected: !isPercentage,
            onTap: enabled ? () => onChanged(false) : null,
          ),
        ),
      ],
    );
  }
}

class _Option extends StatelessWidget {
  const _Option({required this.label, required this.isSelected, this.onTap});

  final String label;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final iconSizes = context.iconSizes;
    final isEnabled = onTap != null;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: spacing.sm),
        decoration: BoxDecoration(
          color: isSelected && isEnabled
              ? theme.colorScheme.primary.withOpacity(0.04)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(spacing.radiusLg),
          border: Border.all(
            // Check both isSelected and isEnabled!
            color: isSelected && isEnabled
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
              color: isSelected && isEnabled
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurfaceVariant.withOpacity(
                      isEnabled ? 1.0 : 0.5,
                    ),
              size: iconSizes.md,
            ),
            SizedBox(width: spacing.xs),
            Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isEnabled
                    ? null
                    : theme.colorScheme.onSurface.withOpacity(0.38),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

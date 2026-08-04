import 'package:apex_restaurant/core/helpers/extensions.dart';
import 'package:apex_restaurant/generated/l10n.dart';
import 'package:flutter/material.dart';

/// Displays the order number, invoice number and current date in a
/// single info bar at the top of the cart screen.
class HeaderInfoCard extends StatelessWidget {
  const HeaderInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final lang = S.of(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: spacing.md,
        vertical: spacing.sm,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.onSurface,
        borderRadius: BorderRadius.circular(spacing.radiusLg),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            HeaderInfoItem(title: lang.orderNumber, value: '#12345'),
            VerticalDivider(
              color: theme.colorScheme.outlineVariant,
              width: 2,
              thickness: 1,
            ),
            HeaderInfoItem(
              title: lang.invoiceNumber,
              value: 'INV-9876',
              isValueBlue: true,
            ),
            VerticalDivider(
              color: theme.colorScheme.outlineVariant,
              width: 2,
              thickness: 1,
            ),
            HeaderInfoItem(
              title: lang.date,
              value: DateTime.now().toString().split(' ').first,
            ),
          ],
        ),
      ),
    );
  }
}

/// A single labeled value inside [HeaderInfoCard].
class HeaderInfoItem extends StatelessWidget {
  const HeaderInfoItem({
    super.key,
    required this.title,
    required this.value,
    this.isValueBlue = false,
  });

  final String title;
  final String value;
  final bool isValueBlue;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(
          title,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onPrimary,
          ),
        ),
        SizedBox(height: context.spacing.xxs),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: isValueBlue
                ? theme.colorScheme.primary
                : theme.colorScheme.onPrimary,
          ),
        ),
      ],
    );
  }
}

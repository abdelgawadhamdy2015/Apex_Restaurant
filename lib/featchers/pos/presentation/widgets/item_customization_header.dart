import 'package:apex_restaurant/core/helpers/extensions.dart';
import 'package:apex_restaurant/generated/l10n.dart';
import 'package:flutter/material.dart';

class ItemCustomizationHeader extends StatelessWidget {
  const ItemCustomizationHeader({
    super.key,
    required this.itemNameAr,
    required this.imagePath,
  });

  final String itemNameAr;
  final String? imagePath;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final spacing = context.spacing;
    final iconSizes = context.iconSizes;
    final lang = S.of(context);

    return Padding(
      padding: EdgeInsets.all(spacing.md),
      child: Row(
        children: [
          if (imagePath != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(spacing.radiusLg),
              child: Image.network(
                imagePath!,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            )
          else
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(spacing.radiusLg),
              ),
              child: Icon(Icons.restaurant, color: theme.colorScheme.primary),
            ),
          SizedBox(width: spacing.md),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                itemNameAr,
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: spacing.xxs),
              Text(
                lang.customizationSubtitle,
                style: textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSecondary,
                ),
              ),
            ],
          ),
          const Spacer(),
          IconButton(
            icon: Icon(
              Icons.close,
              size: iconSizes.lg,
              color: theme.colorScheme.onSecondary,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}

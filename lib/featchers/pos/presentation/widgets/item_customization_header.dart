// lib/featchers/pos/presentation/widgets/item_customization_header.dart
import 'package:apex_restaurant/core/helpers/extensions.dart';
import 'package:flutter/material.dart';

/// Header row of the item customization sheet: close button, item name +
/// subtitle, and a thumbnail (or placeholder icon) on the trailing side.
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
                'اختر الحجم المناسب والإضافات المرغوبة',
                style: textTheme.bodySmall?.copyWith(
                  // Was theme.hintColor — onSurfaceVariant matches the
                  // "muted text" token used everywhere else in the app.
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),

          const Spacer(),

          IconButton(
            icon: Icon(Icons.close, size: iconSizes.lg),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}

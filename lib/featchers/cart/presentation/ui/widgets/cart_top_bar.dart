// lib/featchers/cart/presentation/ui/widgets/cart_top_bar.dart
import 'package:apex_restaurant/core/helpers/extensions.dart';
import 'package:apex_restaurant/core/themes/app_colors.dart';
import 'package:apex_restaurant/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CartTopBar extends StatelessWidget implements PreferredSizeWidget {
  const CartTopBar({super.key, this.onBack, this.onClearAll});

  final VoidCallback? onBack;
  final VoidCallback? onClearAll;

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final spacing = context.spacing;
    final iconSizes = context.iconSizes;
    final lang = S.of(context);

    return SafeArea(
      child: Container(
        height: preferredSize.height,
        padding: EdgeInsets.symmetric(horizontal: spacing.md),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          border: Border(
            bottom: BorderSide(color: theme.colorScheme.outlineVariant),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: onBack ?? () => context.pop(),
              icon: Icon(Icons.arrow_back, color: theme.colorScheme.onSurface),
            ),
            Text(
              lang.shoppingCart,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            TextButton.icon(
              onPressed: onClearAll,
              style: TextButton.styleFrom(
                foregroundColor: theme.colorScheme.error,
              ),
              icon: Icon(Icons.delete_outline, size: iconSizes.sm),
              label: Text(
                lang.clearAll,
                style: textTheme.bodySmall?.copyWith(color: AppColors.error),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

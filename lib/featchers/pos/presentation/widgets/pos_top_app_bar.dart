// lib/featchers/pos/presentation/widgets/pos_top_app_bar.dart
import 'package:apex_restaurant/core/helpers/extensions.dart';
import 'package:flutter/material.dart';

/// Top bar for the POS menu screen: manager avatar + name on the start
/// side (tap to open the drawer), search action on the end side.
class PosTopAppBar extends StatelessWidget implements PreferredSizeWidget {
  const PosTopAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final iconSizes = context.iconSizes;

    return SafeArea(
      child: Container(
        height: preferredSize.height,
        padding: EdgeInsets.symmetric(horizontal: spacing.md),
        // Was AppColors.surface.
        color: theme.colorScheme.surface,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () => Scaffold.of(context).openDrawer(),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    // Was AppColors.primaryLightTranslucent — deriving it
                    // from the live theme color keeps it in sync with the
                    // user's chosen accent instead of always being blue.
                    backgroundColor: theme.colorScheme.primary.withOpacity(
                      0.12,
                    ),
                    child: Icon(
                      Icons.person,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  SizedBox(width: spacing.xs),
                  Text(
                    'مدير المطعم',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      // Was AppColors.textPrimary.
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.search,
                size: iconSizes.xl,
                // Was AppColors.textPrimary.
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

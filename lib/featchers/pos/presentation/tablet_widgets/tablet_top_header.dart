import 'package:flutter/material.dart';

import '../../../../core/helpers/extensions.dart';
import '../../../../generated/l10n.dart';

class TabletPosTopHeader extends StatelessWidget
    implements PreferredSizeWidget {
  final String userRole;
  final String branchName;
  final TextEditingController? searchController;
  final ValueChanged<String>? onSearchChanged;
  final VoidCallback? onSettingsPressed;
  final VoidCallback? onNotificationsPressed;
  final bool hasNotificationDot;

  const TabletPosTopHeader({
    super.key,
    required this.userRole,
    required this.branchName,
    this.searchController,
    this.onSearchChanged,
    this.onSettingsPressed,
    this.onNotificationsPressed,
    this.hasNotificationDot = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(64.0);

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final spacing = context.spacing;

    return Container(
      height: preferredSize.height,
      padding: EdgeInsets.symmetric(
        horizontal: spacing.lg,
        vertical: spacing.xs,
      ),
      decoration: BoxDecoration(
        color: colorScheme.onSurface,
        border: Border(
          bottom: BorderSide(color: colorScheme.outlineVariant, width: 1.0),
        ),
      ),
      child: Row(
        children: [
          // Logo Placeholder
          Image.asset(
            'assets/images/logo.png',
            height: 32,
            errorBuilder: (context, error, stackTrace) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'APEX',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                      letterSpacing: 1.2,
                    ),
                  ),
                  Text(
                    ' ERP',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.tertiary,
                    ),
                  ),
                ],
              );
            },
          ),
          const Spacer(),

          // Centered Search Bar
          Expanded(
            flex: 4,
            child: SizedBox(
              height: 40,
              child: TextField(
                controller: searchController,
                onChanged: onSearchChanged,
                decoration: InputDecoration(
                  hintText: lang.search,
                  hintStyle: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.outline,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: colorScheme.onSurfaceVariant,
                    size: context.iconSizes.sm,
                  ),
                  filled: true,
                  fillColor: colorScheme.surface,
                  contentPadding: EdgeInsets.zero,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(spacing.radiusMd),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(spacing.radiusMd),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(spacing.radiusMd),
                    borderSide: BorderSide(
                      color: colorScheme.primary.withOpacity(0.5),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const Spacer(),

          SizedBox(width: spacing.md),
          Container(height: 28, width: 1, color: colorScheme.outlineVariant),
          SizedBox(width: spacing.md),

          // Action Buttons: Settings & Notifications
          IconButton(
            onPressed: onSettingsPressed,
            icon: Icon(
              Icons.settings_outlined,
              color: colorScheme.onPrimary,
              size: context.iconSizes.md,
            ),
            splashRadius: spacing.radiusLg,
          ),
          SizedBox(width: spacing.xs),
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                onPressed: onNotificationsPressed,
                icon: Icon(
                  Icons.notifications_none_outlined,
                  color: colorScheme.onPrimary,
                  size: context.iconSizes.md,
                ),
                splashRadius: spacing.radiusLg,
              ),
              if (hasNotificationDot)
                Positioned(
                  top: spacing.xs,
                  right: spacing.xs,
                  child: Container(
                    width: spacing.xs,
                    height: spacing.xs,
                    decoration: BoxDecoration(
                      color: colorScheme.error,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(width: spacing.md),

          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(width: spacing.sm),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userRole,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: spacing.xxs),
                  Text(
                    branchName,
                    style: theme.textTheme.bodySmall?.copyWith(),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(width: spacing.md),

          CircleAvatar(
            radius: spacing.radiusLg,
            backgroundColor: colorScheme.primary.withOpacity(.2),
            child: Icon(
              Icons.person,
              color: colorScheme.primary,
              size: context.iconSizes.md,
            ),
          ),
        ],
      ),
    );
  }
}

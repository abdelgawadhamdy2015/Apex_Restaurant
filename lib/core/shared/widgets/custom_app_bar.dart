import 'package:apex_restaurant/core/helpers/extensions.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final List<Widget>? actions;
  final bool? centerTitle;
  const CustomAppBar({
    super.key,
    required this.title,
    this.showBackButton = true,
    this.onBackPressed,
    this.actions,
    this.centerTitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iconSizes = context.iconSizes;

    return AppBar(
      backgroundColor: theme.colorScheme.onSurface,
      elevation: 0,
      automaticallyImplyLeading: false,
      foregroundColor: theme.colorScheme.onSurface,
      centerTitle: centerTitle ?? false,
      title: Text(
        title,
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      leading: showBackButton
          ? IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: theme.colorScheme.onSecondary,
                size: iconSizes.lg,
              ),
              onPressed:
                  onBackPressed ?? () => Navigator.of(context).maybePop(),
            )
          : null,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

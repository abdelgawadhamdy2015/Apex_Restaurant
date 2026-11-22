import '../../../../../core/helpers/extensions.dart';
import '../../../../../core/helpers/size_helper.dart';
import '../../../../../core/themes/app_colors.dart';
import '../../bloc/cart_bloc.dart';
import '../../bloc/cart_event.dart';
import '../../../../../generated/l10n.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

    final cartPermissions = context.select(
      (CartBloc bloc) =>
          (canEdit: bloc.state.canEdit, hasItems: bloc.state.items.isNotEmpty),
    );

    return SafeArea(
      child: Container(
        height: preferredSize.height,
        padding: EdgeInsets.symmetric(horizontal: spacing.md),
        decoration: BoxDecoration(
          color: theme.colorScheme.onSurface,
          border: Border(
            bottom: BorderSide(color: theme.colorScheme.outlineVariant),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (SizeHelper.isMobile)
              IconButton(
                onPressed: onBack ?? context.pop,
                icon: Icon(
                  Icons.arrow_back,
                  color: theme.colorScheme.onSecondary,
                ),
              ),
            Text(
              lang.shoppingCart,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onPrimary,
              ),
            ),
            TextButton.icon(
              onPressed: cartPermissions.canEdit && cartPermissions.hasItems
                  ? (onClearAll ??
                        () {
                          context.read<CartBloc>().add(ClearCartEvent());
                        })
                  : null,
              style: TextButton.styleFrom(
                foregroundColor: theme.colorScheme.error,
                disabledForegroundColor: theme.colorScheme.onSurface.withValues(
                  alpha: 0.38,
                ),
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

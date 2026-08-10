import 'package:apex_restaurant/core/helpers/restaurant_constants.dart';
import 'package:apex_restaurant/core/helpers/shared_prf_helper.dart';
import 'package:apex_restaurant/core/router/routes.dart';
import 'package:apex_restaurant/core/service/api_constants.dart';
import 'package:apex_restaurant/core/service/dio_factory.dart';
import 'package:apex_restaurant/featchers/login/presentation/widget/login_mobile_screen.dart';
import 'package:apex_restaurant/generated/l10n.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// ─────────────────────────────────────────────────────────────────────────────
// ENUM + CONFIG
// ─────────────────────────────────────────────────────────────────────────────

enum AppDialogType { error, warning, success, info }

class _DialogConfig {
  final Color stripeColor;
  final Color badgeColor;
  final Color iconBg;
  final Color iconColor;
  final IconData badgeIcon;
  final String Function(BuildContext) badgeLabel;
  final IconData icon;
  final IconData confirmIcon;

  const _DialogConfig({
    required this.stripeColor,
    required this.badgeColor,
    required this.iconBg,
    required this.iconColor,
    required this.badgeIcon,
    required this.badgeLabel,
    required this.icon,
    required this.confirmIcon,
  });
}

extension AppDialogTypeConfig on AppDialogType {
  /// Maps each dialog type onto a real `ColorScheme` role instead of a fixed
  /// hex value, so dialogs stay correct across light/dark and any seed color
  /// change. `error`/`info` map cleanly onto `error`/`primary`. Material's
  /// default `ColorScheme` has no dedicated "warning" or "success" role, so
  /// those use `tertiary` and a plain `Colors.green` respectively — flagged
  /// below with a TODO in case a themed role gets added later.
  _DialogConfig config(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    switch (this) {
      case AppDialogType.error:
        return _DialogConfig(
          stripeColor: scheme.error,
          badgeColor: scheme.errorContainer,
          iconBg: scheme.errorContainer,
          iconColor: scheme.error,
          badgeIcon: Icons.shield_outlined,
          badgeLabel: (_) => S.of(context).sessionExpired,
          icon: Icons.lock_open_outlined,
          confirmIcon: Icons.login_outlined,
        );
      case AppDialogType.warning:
        return _DialogConfig(
          stripeColor: scheme.error,
          badgeColor: scheme.errorContainer,
          iconBg: scheme.errorContainer,
          iconColor: scheme.error,
          badgeIcon: Icons.info_outline,
          badgeLabel: (_) => S.of(context).confirm,
          icon: Icons.logout_outlined,
          confirmIcon: Icons.logout_outlined,
        );
      case AppDialogType.success:
        return const _DialogConfig(
          stripeColor: Colors.green,
          badgeColor: Color(0xFFE1F5E5),
          iconBg: Color(0xFFE1F5E5),
          iconColor: Colors.green,
          badgeIcon: Icons.check_circle_outline,
          badgeLabel: _successLabel,
          icon: Icons.fingerprint,
          confirmIcon: Icons.home_outlined,
        );
      case AppDialogType.info:
        return _DialogConfig(
          stripeColor: scheme.primary,
          badgeColor: scheme.primary.withValues(alpha: .1),
          iconBg: scheme.primary.withValues(alpha: .1),
          iconColor: scheme.primary,
          badgeIcon: Icons.send_outlined,
          badgeLabel: (_) => S.of(context).confirm,
          icon: Icons.send_outlined,
          confirmIcon: Icons.check_outlined,
        );
    }
  }
}

String _successLabel(BuildContext context) => S.of(context).verified;

// ─────────────────────────────────────────────────────────────────────────────
// CORE DIALOG WIDGET
// ─────────────────────────────────────────────────────────────────────────────

class AppDialog extends StatelessWidget {
  final String title;
  final String message;
  final AppDialogType type;
  final String confirmLabel;
  final String? cancelLabel;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;

  /// Optional: show a retry button (used in fingerprint dialog)
  final String? retryLabel;
  final VoidCallback? onRetry;

  const AppDialog({
    super.key,
    required this.title,
    required this.message,
    required this.type,
    required this.confirmLabel,
    this.cancelLabel,
    this.onConfirm,
    this.onCancel,
    this.retryLabel,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final config = type.config(context);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      backgroundColor: theme.colorScheme.onSurface,
      child: SizedBox(
        width: MediaQuery.sizeOf(context).width * 0.6,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Top colour stripe ──────────────────────────────────────────
            Container(height: 4, color: config.stripeColor),

            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ── Badge ────────────────────────────────────────────────
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: config.badgeColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          config.badgeIcon,
                          size: 16,
                          color: theme.colorScheme.onPrimary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          config.badgeLabel(context),
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ── Icon circle ──────────────────────────────────────────
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: config.iconBg,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      config.icon,
                      size: 20,
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ── Title ────────────────────────────────────────────────
                  Text(
                    title,
                    style: theme.textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 16),

                  // ── Message ──────────────────────────────────────────────
                  Text(
                    message,
                    style: theme.textTheme.titleSmall?.copyWith(height: 1.6),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 20),

                  // ── Actions ──────────────────────────────────────────────
                  _buildActions(context, config),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActions(BuildContext context, _DialogConfig config) {
    // Fingerprint-style: retry + confirm
    if (retryLabel != null) {
      return Row(
        children: [
          Expanded(
            child: _OutlineBtn(
              label: retryLabel!,
              icon: Icons.refresh_outlined,
              onTap: onRetry ?? () => context.pop(),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _FilledBtn(
              label: confirmLabel,
              icon: config.confirmIcon,
              color: config.stripeColor,
              onTap: onConfirm ?? () => context.pop(),
            ),
          ),
        ],
      );
    }

    // Two-button: cancel + confirm
    if (cancelLabel != null) {
      return Row(
        children: [
          Expanded(
            child: _OutlineBtn(
              label: cancelLabel!,
              onTap: onCancel ?? () => context.pop(),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _FilledBtn(
              label: confirmLabel,
              icon: config.confirmIcon,
              color: config.stripeColor,
              onTap: onConfirm ?? () => context.pop(),
            ),
          ),
        ],
      );
    }

    // Single confirm button
    return _FilledBtn(
      label: confirmLabel,
      icon: config.confirmIcon,
      color: config.stripeColor,
      onTap: onConfirm ?? () => context.pop(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// BUTTON HELPERS
// ─────────────────────────────────────────────────────────────────────────────

class _FilledBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _FilledBtn({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: 48,
      child: FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16),
            const SizedBox(width: 20),
            Text(
              label,
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.onPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OutlineBtn extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback onTap;

  const _OutlineBtn({required this.label, required this.onTap, this.icon});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: 48,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: theme.colorScheme.onSurfaceVariant,
          side: BorderSide(color: theme.dividerColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16),
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// HELPER FUNCTION
// ─────────────────────────────────────────────────────────────────────────────

/// Handles the login-redirect case automatically when route == Routes.loginScreen.
void showAppDialog(
  BuildContext context, {
  required AppDialogType type,
  required String title,
  required String message,
  required String confirmLabel,
  String? cancelLabel,
  VoidCallback? onConfirm,
  VoidCallback? onCancel,
  String? retryLabel,
  VoidCallback? onRetry,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => AppDialog(
      type: type,
      title: title,
      message: message,
      confirmLabel: confirmLabel,
      cancelLabel: cancelLabel,
      onConfirm: onConfirm,
      onCancel: onCancel,
      retryLabel: retryLabel,
      onRetry: onRetry,
    ),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// showDialogState
// ─────────────────────────────────────────────────────────────────────────────

void showDialogState(
  BuildContext context,
  dynamic data, {
  Widget? icon,
  String? route,
  String? departureType,
}) {
  final message = data is String ? data : '';
  final isAuthError =
      (ApiConstants.dioExceptionType == DioExceptionType.badResponse) ||
      route == Routes.loginScreen;

  showAppDialog(
    context,
    type: isAuthError ? AppDialogType.error : AppDialogType.info,
    title: isAuthError ? S.of(context).sessionExpired : S.of(context).notice,
    message: message,
    confirmLabel: isAuthError ? S.of(context).signIn : S.of(context).okDialog,
    onConfirm: () async {
      context.pop();
      if (isAuthError) {
        ApiConstants.dioExceptionType = DioExceptionType.unknown;
        await SharedPrefHelper.setData(RestaurantConstants.myToken, "");
        DioFactory.clearToken();
        if (!context.mounted) return;
        context.pushReplacementNamed(Routes.loginScreen);
      } else if (route != null &&
          route != Routes.loginScreen &&
          route != RestaurantConstants.previousRoute) {
        context.pushReplacementNamed(route, extra: departureType);
      } else if (route == null) {
        context.pushNamed(Routes.homeScreen);
      }
    },
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// LogOutDialog
// ─────────────────────────────────────────────────────────────────────────────

void showLogOutDialogState(
  BuildContext context,
  String data,
  List<String> actions,
) {
  showAppDialog(
    context,
    type: AppDialogType.warning,
    title: S.of(context).logout,
    message: data,
    confirmLabel: actions[0],
    cancelLabel: actions.length > 1 ? actions[1] : null,
    onCancel: () => context.pop(),
    onConfirm: () async {
      context.pop();
      await SharedPrefHelper.setData(RestaurantConstants.myToken, "");
      DioFactory.clearToken();
      if (!context.mounted) return;
      context.pushReplacementNamed(Routes.loginScreen);
      mySignalRService.stopConnection();
    },
  );
}

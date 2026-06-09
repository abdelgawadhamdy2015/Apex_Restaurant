import 'package:apex_restaurant/core/helpers/restaurant_constants.dart';
import 'package:apex_restaurant/core/helpers/shared_prf_helper.dart';
import 'package:apex_restaurant/core/router/routes.dart';
import 'package:apex_restaurant/core/service/api_constants.dart';
import 'package:apex_restaurant/core/service/dio_factory.dart';
import 'package:apex_restaurant/core/theme/app_theme.dart';
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
  _DialogConfig config(BuildContext context) {
    switch (this) {
      case AppDialogType.error:
        return _DialogConfig(
          stripeColor: AppColors.error,
          badgeColor: AppColors.errorLight,
          iconBg: AppColors.errorLight,
          iconColor: AppColors.error,
          badgeIcon: Icons.shield_outlined,
          badgeLabel: (_) => S.of(context).sessionExpired,
          icon: Icons.lock_open_outlined,
          confirmIcon: Icons.login_outlined,
        );
      case AppDialogType.warning:
        return _DialogConfig(
          stripeColor: const Color(0xFFBA7517),
          badgeColor: const Color(0xFFFAEEDA),
          iconBg: const Color(0xFFFAEEDA),
          iconColor: const Color(0xFFBA7517),
          badgeIcon: Icons.info_outline,
          badgeLabel: (_) => S.of(context).confirm,
          icon: Icons.logout_outlined,
          confirmIcon: Icons.logout_outlined,
        );
      case AppDialogType.success:
        return _DialogConfig(
          stripeColor: AppColors.success,
          badgeColor: AppColors.successLight,
          iconBg: AppColors.successLight,
          iconColor: AppColors.success,
          badgeIcon: Icons.check_circle_outline,
          badgeLabel: (_) => S.of(context).verified,
          icon: Icons.fingerprint,
          confirmIcon: Icons.home_outlined,
        );
      case AppDialogType.info:
        return _DialogConfig(
          stripeColor: AppColors.primary,
          badgeColor: AppColors.selectedColor,
          iconBg: AppColors.selectedColor,
          iconColor: AppColors.primary,
          badgeIcon: Icons.send_outlined,
          badgeLabel: (_) => S.of(context).confirm,
          icon: Icons.send_outlined,
          confirmIcon: Icons.check_outlined,
        );
    }
  }
}

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
    final config = type.config(context);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      clipBehavior: Clip.antiAlias,
      backgroundColor: AppColors.white,
      child: SizedBox(
        width: AppSizes.wFraction(0.6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Top colour stripe ──────────────────────────────────────────
            Container(height: AppSizes.h4, color: config.stripeColor),

            Padding(
              padding: EdgeInsets.fromLTRB(
                AppPadding.sm,
                AppPadding.sm,
                AppPadding.sm,
                AppPadding.sm,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ── Badge ────────────────────────────────────────────────
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppPadding.sm,
                      vertical: AppPadding.md,
                    ),
                    decoration: BoxDecoration(
                      color: config.badgeColor,
                      borderRadius: BorderRadius.circular(AppRadius.xl),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          config.badgeIcon,
                          size: AppSizes.iconSm,
                          color: config.iconColor,
                        ),
                        SizedBox(width: AppSpacing.sm),
                        Text(
                          config.badgeLabel(context),
                          style: AppFonts.titleMedium.copyWith(
                            color: config.iconColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: AppSpacing.lg),

                  // ── Icon circle ──────────────────────────────────────────
                  Container(
                    width: AppSizes.buttonHeight,
                    height: AppSizes.buttonHeight,
                    decoration: BoxDecoration(
                      color: config.iconBg,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      config.icon,
                      size: AppSizes.iconMd,
                      color: config.iconColor,
                    ),
                  ),

                  SizedBox(height: AppSpacing.lg),

                  // ── Title ────────────────────────────────────────────────
                  Text(
                    title,
                    style: AppFonts.titleMedium,
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: AppSpacing.lg),

                  // ── Message ──────────────────────────────────────────────
                  Text(
                    message,
                    style: AppFonts.titleSmall.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.6,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: AppSpacing.xl),

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
          SizedBox(width: AppSpacing.md),
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
          SizedBox(width: AppSpacing.md),
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
    return SizedBox(
      height: AppSizes.buttonHeight,
      child: FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
        ),
        onPressed: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: AppSizes.iconSm),
            SizedBox(width: AppSpacing.xl),
            Text(
              label,
              style: AppFonts.titleLarge.copyWith(
                color: AppColors.white,
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
    return SizedBox(
      height: AppSizes.buttonHeight,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textSecondary,
          side: BorderSide(color: AppColors.border),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
        ),
        onPressed: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: AppSizes.iconSm),
              SizedBox(width: AppSpacing.sm),
            ],
            Text(
              label,
              style: AppFonts.titleMedium.copyWith(
                color: AppColors.textSecondary,
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
        DioFactory.deletTokenHeaderAfterLogOut();
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
      DioFactory.deletTokenHeaderAfterLogOut();
      if (!context.mounted) return;
      context.pushReplacementNamed(Routes.loginScreen);
      mySignalRService.stopConnection();
    },
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// REPLACEMENT FOR setupResendRequestDialogState()
// ─────────────────────────────────────────────────────────────────────────────

// void setupResendRequestDialogState(
//   BuildContext context,
//   String data,
//   List<String> actions,
//   Function() onOkPressed,
//   Widget icon, {
//   Function()? cancelClick,
// }) {
//   showAppDialog(
//     context,
//     type: AppDialogType.info,
//     title: S.of(context).confirmAction,
//     message: data,
//     confirmLabel: actions[0],
//     cancelLabel: actions.length > 1 ? actions[1] : null,
//     onCancel: cancelClick ?? () => context.pop(),
//     onConfirm: () {
//       context.pop();
//       onOkPressed();
//     },
//   );
// }

// ─────────────────────────────────────────────────────────────────────────────
// REPLACEMENT FOR showFingerprintDialog()
// ─────────────────────────────────────────────────────────────────────────────

// void showFingerprintDialog(
//   BuildContext context, {
//   bool success = true,
//   required String data,
//   required List<String> actions,
//   Function()? onclick,
// }) {
//   showAppDialog(
//     context,
//     type: success ? AppDialogType.success : AppDialogType.error,
//     title: success
//         ? S.of(context).identityConfirmed
//         : S.of(context).verificationFailed,
//     message: data,
//     confirmLabel: actions[0],
//     retryLabel: !success && actions.length > 1 ? actions[1] : null,
//     onRetry: onclick != null
//         ? () {
//             context.pop();
//             onclick();
//           }
//         : null,
//     onConfirm: () => context.pushReplacementNamed(Routes.homeScreen),
//   );
//}

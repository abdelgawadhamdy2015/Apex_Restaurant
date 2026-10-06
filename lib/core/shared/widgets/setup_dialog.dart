import 'dart:developer';

import 'package:apex_restaurant/core/themes/app_colors.dart';
import 'package:apex_restaurant/core/themes/app_extra_theme.dart';
import 'package:apex_restaurant/featchers/cart/presentation/bloc/cart_bloc.dart';
import 'package:apex_restaurant/featchers/cart/presentation/bloc/cart_event.dart';
import 'package:apex_restaurant/featchers/pos/presentation/bloc/pos_bloc.dart';
import 'package:apex_restaurant/featchers/pos/presentation/bloc/pos_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show ReadContext;

import '../../helpers/restaurant_constants.dart';
import '../../helpers/shared_prf_helper.dart';
import '../../router/routes.dart';
import '../../service/api_constants.dart';
import '../../service/dio_factory.dart';
import '../../../featchers/auth/presentation/pages/login_screen.dart';
import '../../../generated/l10n.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum AppDialogType { error, warning, success, info }

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

  /// Optional retry button (takes the secondary slot)
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

  static const double _tabletBreakpoint = 600;
  static const double _maxWidth = 500;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final extra = theme.extension<AppExtraTheme>()!;
    final isDark = theme.brightness == Brightness.dark;
    final isTablet = MediaQuery.sizeOf(context).width >= _tabletBreakpoint;

    final secondaryLabel = retryLabel ?? cancelLabel;
    final VoidCallback secondaryTap = retryLabel != null
        ? (onRetry ?? () => context.pop())
        : (onCancel ?? () => context.pop());

    return Dialog(
      elevation: isDark ? 0 : 16,
      shadowColor: extra.shadowColor,
      surfaceTintColor: Colors.transparent,
      backgroundColor: scheme.onSurface,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: scheme.outlineVariant),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: _maxWidth),
        child: Padding(
          padding: EdgeInsets.all(isTablet ? 32 : 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: _StatusIcon(
                  type: type,
                  isTablet: isTablet,
                  mainColor: _statusColor(scheme, extra),
                  glyphColor: scheme.onSurface,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: scheme.onPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (message.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: scheme.onSecondary,
                    height: 1.6,
                  ),
                ),
              ],
              SizedBox(height: isTablet ? 32 : 24),
              _Actions(
                confirmLabel: confirmLabel,
                onConfirm: onConfirm ?? () => context.pop(),
                secondaryLabel: secondaryLabel,
                onSecondary: secondaryTap,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _statusColor(ColorScheme scheme, AppExtraTheme extra) {
    switch (type) {
      case AppDialogType.error:
        return scheme.error;
      case AppDialogType.warning:
        return AppColors.warning;
      case AppDialogType.success:
        return extra.greenBackground;
      case AppDialogType.info:
        return AppColors.teal;
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// STATUS ICON
// ─────────────────────────────────────────────────────────────────────────────

class _StatusIcon extends StatelessWidget {
  final AppDialogType type;
  final bool isTablet;
  final Color mainColor;
  final Color glyphColor;

  const _StatusIcon({
    required this.type,
    required this.isTablet,
    required this.mainColor,
    required this.glyphColor,
  });

  @override
  Widget build(BuildContext context) {
    final outer = isTablet ? 80.0 : 72.0;
    final inner = isTablet ? 48.0 : 44.0;

    final Widget glyph;
    switch (type) {
      case AppDialogType.error:
        glyph = _filled(
          inner,
          Icon(Icons.close_rounded, size: inner * .62, color: glyphColor),
        );
      case AppDialogType.success:
        glyph = _filled(
          inner,
          Icon(Icons.check_rounded, size: inner * .68, color: glyphColor),
        );
      case AppDialogType.info:
        glyph = _filled(
          inner,
          Text(
            'i',
            style: TextStyle(
              fontSize: inner * .6,
              height: 1,
              fontWeight: FontWeight.w900,
              fontStyle: FontStyle.italic,
              color: glyphColor,
            ),
          ),
        );
      case AppDialogType.warning:
        glyph = Icon(Icons.warning_rounded, size: inner, color: mainColor);
    }

    return Container(
      width: outer,
      height: outer,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: mainColor.withValues(alpha: .12),
        shape: BoxShape.circle,
      ),
      child: glyph,
    );
  }

  Widget _filled(double size, Widget child) => Container(
    width: size,
    height: size,
    alignment: Alignment.center,
    decoration: BoxDecoration(color: mainColor, shape: BoxShape.circle),
    child: child,
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// ACTIONS
// ─────────────────────────────────────────────────────────────────────────────

class _Actions extends StatelessWidget {
  final String confirmLabel;
  final VoidCallback onConfirm;
  final String? secondaryLabel;
  final VoidCallback onSecondary;

  const _Actions({
    required this.confirmLabel,
    required this.onConfirm,
    required this.secondaryLabel,
    required this.onSecondary,
  });

  @override
  Widget build(BuildContext context) {
    final primary = _PrimaryBtn(label: confirmLabel, onTap: onConfirm);
    if (secondaryLabel == null) return primary;

    final secondary = _SecondaryBtn(label: secondaryLabel!, onTap: onSecondary);

    return LayoutBuilder(
      builder: (context, constraints) {
        // very narrow phones: stack
        if (constraints.maxWidth < 280) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [primary, const SizedBox(height: 12), secondary],
          );
        }
        return Row(
          children: [
            Expanded(child: primary),
            const SizedBox(width: 16),
            Expanded(child: secondary),
          ],
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// BUTTONS
// ─────────────────────────────────────────────────────────────────────────────

class _PrimaryBtn extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _PrimaryBtn({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: 56,
      child: FilledButton(
        onPressed: onTap,
        style: FilledButton.styleFrom(
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: AppColors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.titleMedium?.copyWith(
            color: AppColors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _SecondaryBtn extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _SecondaryBtn({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme.primary;
    return SizedBox(
      height: 56,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          foregroundColor: color,
          side: BorderSide(color: color, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.titleMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// HELPER FUNCTION (unchanged API)
// ─────────────────────────────────────────────────────────────────────────────

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
      context.read<CartBloc>().add(ClearCartEvent());
      context.read<PosBloc>().add(LogOutEvent());
      context.pushReplacementNamed(Routes.loginScreen);
      log(" not catch ");
      mySignalRService.stopConnection();
    },
  );
}
// ─────────────────────────────────────────────────────────────────────────────
// Pause session dialog (shared by tablet + mobile)
// ─────────────────────────────────────────────────────────────────────────────

void showPauseSessionDialogState(BuildContext context) {
  final lang = S.of(context);

  void closeDialog() => Navigator.of(context, rootNavigator: true).pop();

  showAppDialog(
    context,
    type: AppDialogType.warning,
    title: lang.suspendSession,
    message:
        '', // empty message is hidden. Pass a real string here if you have one.
    confirmLabel: lang.resumeSession,
    cancelLabel: lang.closeSession,
    onConfirm: closeDialog,
    onCancel: () {
      closeDialog();
      context.read<PosBloc>().add(
        CurrentRestaurantPosSessionEvent(openCloseDialog: true),
      );
    },
  );
}

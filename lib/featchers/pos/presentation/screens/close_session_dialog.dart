import '../../../../core/helpers/extensions.dart';
import '../../../../core/router/routes.dart';
import '../bloc/pos_bloc.dart';
import '../bloc/pos_event.dart';
import '../bloc/pos_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CloseSessionDialog extends StatelessWidget {
  final int sessionId;

  const CloseSessionDialog({super.key, required this.sessionId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final spacing = context.spacing;

    return BlocConsumer<PosBloc, PosState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        // عند النجاح: إغلاق الـ Dialog والتوجيه للـ Home Screen
        if (state.status == PosStatus.loaded &&
            state.toastMessage == 'تم إغلاق الجلسة بنجاح') {
          Navigator.of(context).pop(); // إغلاق الـ Dialog

          context.go(Routes.homeScreen); // أو context.go(Routes.homeScreen);
        }

        // عند وجود خطأ
        if (state.status == PosStatus.error && state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: colorScheme.error,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state.status == PosStatus.loading;

        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.all(spacing.md),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 420),
            padding: EdgeInsets.all(spacing.xl),
            decoration: BoxDecoration(
              color: colorScheme.onSurface,
              borderRadius: BorderRadius.circular(spacing.radiusLg),
              border: Border.all(
                color: colorScheme.outlineVariant.withOpacity(0.5),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 28,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon Header
                Container(
                  padding: EdgeInsets.all(spacing.sm),
                  decoration: BoxDecoration(
                    color: colorScheme.errorContainer.withOpacity(0.4),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.power_settings_new_rounded,
                    color: colorScheme.error,
                    size: 36,
                  ),
                ),
                SizedBox(height: spacing.md),

                // Title
                Text(
                  'إغلاق الجلسة الحالية',
                  style: textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: spacing.xs),

                // Subtitle
                Text(
                  'هل أنت أأكد من رغبتك في إغلاق الجلسة رقم (#$sessionId)؟',
                  style: textTheme.bodyMedium?.copyWith(height: 1.4),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: spacing.xl),

                // Confirm Close Session Button
                SizedBox(
                  width: double.infinity,
                  height: 50.0,
                  child: ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () {
                            context.read<PosBloc>().add(
                              CloseRestaurantPosSessionEvent(
                                sessionId: sessionId,
                              ),
                            );
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.error,
                      foregroundColor: colorScheme.onError,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(spacing.radiusSm),
                      ),
                    ),
                    child: isLoading
                        ? SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: colorScheme.onError,
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'تأكيد إغلاق الجلسة',
                                style: textTheme.titleMedium?.copyWith(
                                  color: colorScheme.onError,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: spacing.xs),
                              Icon(
                                Icons.check_circle_outline,
                                size: context.iconSizes.sm,
                                color: colorScheme.onError,
                              ),
                            ],
                          ),
                  ),
                ),
                SizedBox(height: spacing.xs),

                // Cancel Button
                if (!isLoading)
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text(
                      'إلغاء والعودة',
                      style: textTheme.titleMedium?.copyWith(),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

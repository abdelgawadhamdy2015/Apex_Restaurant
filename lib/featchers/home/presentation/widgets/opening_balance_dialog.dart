import 'package:apex_restaurant/core/helpers/extensions.dart';
import 'package:apex_restaurant/core/helpers/helper_methods.dart';
import 'package:apex_restaurant/core/router/routes.dart';
import 'package:apex_restaurant/core/themes/app_colors.dart';
import 'package:apex_restaurant/featchers/home/presentation/bloc/home_bloc.dart';
import 'package:apex_restaurant/featchers/home/presentation/bloc/home_event.dart';
import 'package:apex_restaurant/featchers/home/presentation/bloc/home_state.dart';
import 'package:apex_restaurant/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class OpeningBalanceDialog extends StatefulWidget {
  const OpeningBalanceDialog({super.key});

  /// Helper method to show the dialog cleanly
  static Future<double?> show(BuildContext context) {
    return showDialog<double>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const OpeningBalanceDialog(),
    );
  }

  @override
  State<OpeningBalanceDialog> createState() => _OpeningBalanceDialogState();
}

class _OpeningBalanceDialogState extends State<OpeningBalanceDialog> {
  final TextEditingController _amountController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final lang = S.of(context);

    return BlocListener<HomeBloc, HomeState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == HomeStatus.openSessionLoaded) {
          context.goNamed(Routes.posScreen);
        } else if (state.status == HomeStatus.error) {
          if (state.errorMessage != null && state.errorMessage!.isNotEmpty) {
            HelperMethods.showSnackBar(
              context: context,
              message: state.errorMessage ?? 'An error occurred',
              isError: true,
            );
          }
        }
      },
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(spacing.radiusLg),
        ),
        backgroundColor: theme.colorScheme.onSurface,
        insetPadding: EdgeInsets.all(spacing.lg),
        child: Padding(
          padding: EdgeInsets.all(spacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Title
              Center(
                child: Text(
                  lang.openingBalance,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
              ),
              SizedBox(height: spacing.lg),

              // Amount Input Label
              Text(
                lang.amount,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onPrimary,
                ),
              ),
              SizedBox(height: spacing.xs),

              // Amount Input Field
              TextFormField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                textAlign: TextAlign.start,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onPrimary,
                ),
                decoration: InputDecoration(
                  hintText: '0.00',
                  isDense: true,
                  filled: true,
                  fillColor: theme.colorScheme.surface,
                  suffixIcon: Padding(
                    padding: EdgeInsets.all(spacing.xs),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: spacing.sm,
                        vertical: spacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.currencyColor,
                        borderRadius: BorderRadius.circular(spacing.radiusSm),
                      ),
                      child: Text(
                        lang.currencySarShort,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(spacing.radiusMd),
                    borderSide: BorderSide(
                      color: theme.colorScheme.outlineVariant,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(spacing.radiusMd),
                    borderSide: BorderSide(
                      color: theme.colorScheme.outlineVariant,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(spacing.radiusMd),
                    borderSide: BorderSide(
                      color: theme.colorScheme.primary,
                      width: 1.5,
                    ),
                  ),
                ),
              ),
              SizedBox(height: spacing.xl),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        final amount =
                            double.tryParse(_amountController.text) ?? 0.0;
                        context.read<HomeBloc>().add(
                          OpenRestaurantPosSessionEvent(openingBalance: amount),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: theme.colorScheme.onPrimary,
                        padding: EdgeInsets.symmetric(vertical: spacing.md),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(spacing.radiusMd),
                        ),
                      ),
                      icon: const Icon(Icons.check_circle_outline, size: 20),
                      label: Text(
                        lang.save,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: spacing.md),

                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: theme.colorScheme.onSecondary,
                        side: BorderSide(
                          color: context.appExtraTheme.cancelPorder,
                          width: 2,
                        ),
                        padding: EdgeInsets.symmetric(vertical: spacing.md),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(spacing.radiusMd),
                        ),
                      ),
                      child: Text(lang.cancel),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

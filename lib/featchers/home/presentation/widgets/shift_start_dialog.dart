import 'package:apex_restaurant/core/router/routes.dart';
import 'package:apex_restaurant/core/theme/app_theme.dart';
import 'package:apex_restaurant/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ShiftStartDialog extends StatefulWidget {
  const ShiftStartDialog({super.key});

  @override
  State<ShiftStartDialog> createState() => _ShiftStartDialogState();
}

class _ShiftStartDialogState extends State<ShiftStartDialog> {
  String _amount = '0.00';
  final TextEditingController _notesController = TextEditingController();

  void _onKey(String key) {
    setState(() {
      if (key == '.') {
        if (_amount.contains('.')) return;
        _amount = '$_amount.';
      } else {
        String raw = _amount.replaceAll('.', '');
        if (raw == '000') raw = '';
        raw += key;
        if (raw.length <= 10) {
          while (raw.length < 3) raw = '0$raw';
          final intPart = raw.substring(0, raw.length - 2);
          final decPart = raw.substring(raw.length - 2);
          final cleaned = intPart.replaceFirst(RegExp(r'^0+'), '');
          _amount = '${cleaned.isEmpty ? '0' : cleaned}.$decPart';
        }
      }
    });
  }

  void _onBackspace() {
    setState(() {
      String raw = _amount.replaceAll('.', '');
      if (raw.length <= 1) {
        _amount = '0.00';
        return;
      }
      raw = raw.substring(0, raw.length - 1);
      while (raw.length < 3) raw = '0$raw';
      final intPart = raw.substring(0, raw.length - 2);
      final decPart = raw.substring(raw.length - 2);
      final cleaned = intPart.replaceFirst(RegExp(r'^0+'), '');
      _amount = '${cleaned.isEmpty ? '0' : cleaned}.$decPart';
    });
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(
          horizontal: AppPadding.xxxl,
          vertical: AppPadding.xxl,
        ),
        child: Center(
          child: Container(
            width: AppSizes.wFraction(.7),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.18),
                  blurRadius: 32,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: AppPadding.xxl),
                  child: Text(
                    lang.shiftStart,
                    style: AppFonts.displayMedium.colored(
                      AppColors.primaryDark,
                    ),
                  ),
                ),
                const Divider(height: 1, color: AppColors.border),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    AppPadding.xl,
                    AppPadding.lg,
                    AppPadding.xl,
                    AppPadding.xl,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lang.openingCash,
                        style: AppFonts.bodyLarge.colored(
                          AppColors.textSecondary,
                        ),
                      ),
                      AppSizes.gapH8,

                      // Amount display
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: AppPadding.lg,
                          vertical: AppPadding.md,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.border),
                          borderRadius: BorderRadius.circular(AppRadius.md),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                _amount,
                                textDirection: TextDirection.ltr,
                                style: AppFonts.displayMedium
                                    .colored(AppColors.textPrimary)
                                    .copyWith(letterSpacing: 1),
                              ),
                            ),
                            AppSizes.gapW12,
                            Text(
                              lang.sar,
                              style: AppFonts.bodySmall.colored(
                                AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      AppSizes.gapH12,

                      _Numpad(onKey: _onKey, onBackspace: _onBackspace),
                      AppSizes.gapH16,

                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          lang.optionalNotes,
                          style: AppFonts.bodySmall.colored(
                            AppColors.textSecondary,
                          ),
                        ),
                      ),
                      AppSizes.gapH8,

                      TextField(
                        controller: _notesController,
                        maxLines: 3,
                        textDirection: TextDirection.rtl,
                        style: AppFonts.bodyMedium.colored(
                          AppColors.textPrimary,
                        ),
                        decoration: InputDecoration(
                          hintText: lang.addNotesHint,
                          hintStyle: AppFonts.bodyMedium.colored(
                            AppColors.textMuted,
                          ),
                          contentPadding: AppPadding.allMd,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppRadius.md),
                            borderSide: const BorderSide(
                              color: AppColors.border,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppRadius.md),
                            borderSide: const BorderSide(
                              color: AppColors.border,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppRadius.md),
                            borderSide: const BorderSide(
                              color: AppColors.primaryDark,
                            ),
                          ),
                        ),
                      ),
                      AppSizes.gapH16,

                      SizedBox(
                        width: double.infinity,
                        height: AppSizes.buttonHeight,
                        child: ElevatedButton(
                          onPressed: () => context.goNamed(Routes.posScreen),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryDark,
                            foregroundColor: AppColors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppRadius.md),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            lang.saveAndOpenShift,
                            style: AppFonts.titleSmall
                                .colored(AppColors.white)
                                .bold(),
                          ),
                        ),
                      ),
                      AppSizes.gapH8,

                      SizedBox(
                        width: double.infinity,
                        height: AppSizes.buttonHeightSm,
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.error,
                            side: const BorderSide(color: AppColors.border),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppRadius.md),
                            ),
                          ),
                          child: Text(
                            lang.cancel,
                            style: AppFonts.bodyMedium
                                .colored(AppColors.error)
                                .semiBold(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Numpad extends StatelessWidget {
  final void Function(String) onKey;
  final VoidCallback onBackspace;

  const _Numpad({required this.onKey, required this.onBackspace});

  @override
  Widget build(BuildContext context) {
    final rows = [
      ['1', '2', '3'],
      ['4', '5', '6'],
      ['7', '8', '9'],
      ['.', '0', '⌫'],
    ];
    return Column(
      children: rows.map((row) {
        return Padding(
          padding: EdgeInsets.only(bottom: AppPadding.sm),
          child: Row(
            children: row.map((key) {
              final isBackspace = key == '⌫';
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: row.indexOf(key) == 0 ? 0 : AppPadding.sm,
                  ),
                  child: _NumKey(
                    label: key,
                    isBackspace: isBackspace,
                    onTap: isBackspace ? onBackspace : () => onKey(key),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      }).toList(),
    );
  }
}

class _NumKey extends StatelessWidget {
  final String label;
  final bool isBackspace;
  final VoidCallback onTap;

  const _NumKey({
    required this.label,
    required this.isBackspace,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isBackspace ? AppColors.errorLight : AppColors.background,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.md),
        onTap: onTap,
        splashColor: isBackspace
            ? AppColors.error.withOpacity(0.2)
            : AppColors.border,
        child: SizedBox(
          height: AppSizes.h48,
          child: Center(
            child: isBackspace
                ? Icon(
                    Icons.backspace_outlined,
                    color: AppColors.error,
                    size: AppSizes.iconLg,
                  )
                : Text(
                    label,
                    style: AppFonts.displayMedium.colored(
                      AppColors.textPrimary,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

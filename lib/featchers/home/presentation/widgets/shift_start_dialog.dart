import 'package:apex_restaurant/core/helpers/extensions.dart';
import 'package:apex_restaurant/core/helpers/helper_methods.dart';
import 'package:apex_restaurant/core/router/routes.dart';
import 'package:apex_restaurant/featchers/home/presentation/bloc/home_bloc.dart';
import 'package:apex_restaurant/featchers/home/presentation/bloc/home_event.dart';
import 'package:apex_restaurant/featchers/home/presentation/bloc/home_state.dart';
import 'package:apex_restaurant/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final size = MediaQuery.sizeOf(context);
    final isTablet = size.width >= 600;

    return BlocListener<HomeBloc, HomeState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == HomeStatus.openSessionLoaded &&
            state.sessionModel != null &&
            state.sessionModel!.id != 0) {
          Navigator.of(context).pop();
          context.push(Routes.posScreen);
        } else if (state.status == HomeStatus.error) {
          if (state.errorMessage != null && state.errorMessage!.isNotEmpty) {
            HelperMethods.massageForAlert(context, state.errorMessage!, true);
          }
        }
      },
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(
            horizontal: isTablet ? size.width * 0.2 : spacing.md,
            vertical: spacing.lg,
          ),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(spacing.radiusLg),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.12),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.all(spacing.lg),
                    child: Text(
                      lang.shiftStart,
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Divider(height: 1, color: theme.colorScheme.outlineVariant),
                  Padding(
                    padding: EdgeInsets.all(spacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          lang.openingCash,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        SizedBox(height: spacing.xs),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            horizontal: spacing.md,
                            vertical: spacing.sm,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: theme.colorScheme.outlineVariant,
                            ),
                            borderRadius: BorderRadius.circular(
                              spacing.radiusMd,
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  _amount,
                                  textDirection: TextDirection.ltr,
                                  style: theme.textTheme.headlineMedium
                                      ?.copyWith(
                                        color: theme.colorScheme.onSurface,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ),
                              SizedBox(width: spacing.xs),
                              Text(
                                lang.sar,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: spacing.md),
                        _Numpad(onKey: _onKey, onBackspace: _onBackspace),
                        SizedBox(height: spacing.md),
                        Text(
                          lang.optionalNotes,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        SizedBox(height: spacing.xs),
                        TextField(
                          controller: _notesController,
                          maxLines: 2,
                          textDirection: TextDirection.rtl,
                          style: theme.textTheme.bodyMedium,
                          decoration: InputDecoration(
                            hintText: lang.addNotesHint,
                          ),
                        ),
                        SizedBox(height: spacing.lg),
                        BlocBuilder<HomeBloc, HomeState>(
                          builder: (context, state) {
                            if (state.status == HomeStatus.openSessionLoading) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            return SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  context.read<HomeBloc>().add(
                                    OpenRestaurantPosSessionEvent(
                                      openingBalance:
                                          double.tryParse(_amount) ?? 0.0,
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: theme.colorScheme.primary,
                                  foregroundColor: theme.colorScheme.onPrimary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      spacing.radiusMd,
                                    ),
                                  ),
                                  elevation: 0,
                                ),
                                child: Text(
                                  lang.saveAndOpenShift,
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    color: theme.colorScheme.onPrimary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: spacing.xs),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () => Navigator.of(context).pop(),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: theme.colorScheme.error,
                              side: BorderSide(
                                color: theme.colorScheme.outlineVariant,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  spacing.radiusMd,
                                ),
                              ),
                            ),
                            child: Text(
                              lang.cancel,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.error,
                                fontWeight: FontWeight.w600,
                              ),
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
    final spacing = context.spacing;
    final keys = [
      '1',
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9',
      '.',
      '0',
      'back',
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: keys.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 2.2,
        crossAxisSpacing: spacing.xs,
        mainAxisSpacing: spacing.xs,
      ),
      itemBuilder: (context, index) {
        final key = keys[index];
        final isBackspace = key == 'back';
        return _NumKey(
          label: key,
          isBackspace: isBackspace,
          onTap: isBackspace ? onBackspace : () => onKey(key),
        );
      },
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
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final iconSizes = context.iconSizes;

    return Material(
      color: isBackspace
          ? theme.colorScheme.error
          : theme.scaffoldBackgroundColor,
      borderRadius: BorderRadius.circular(spacing.radiusSm),
      child: InkWell(
        borderRadius: BorderRadius.circular(spacing.radiusSm),
        onTap: onTap,
        child: Center(
          child: isBackspace
              ? Icon(
                  Icons.backspace_outlined,
                  color: theme.colorScheme.onError,
                  size: iconSizes.md,
                )
              : Text(
                  label,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }
}

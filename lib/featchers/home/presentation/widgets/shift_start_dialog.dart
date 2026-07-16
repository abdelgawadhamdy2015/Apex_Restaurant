import 'package:apex_restaurant/core/router/routes.dart';
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
    final theme = Theme.of(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Center(
          child: Container(
            width: MediaQuery.sizeOf(context).width * 0.7,
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: .18),
                  blurRadius: 32,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Text(
                    lang.shiftStart,
                    style: theme.textTheme.displayMedium?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
                Divider(height: 1, color: theme.dividerColor),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lang.openingCash,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Amount display
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: theme.dividerColor),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                _amount,
                                textDirection: TextDirection.ltr,
                                style: theme.textTheme.displayMedium?.copyWith(
                                  color: theme.colorScheme.onSurface,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              lang.sar,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      _Numpad(onKey: _onKey, onBackspace: _onBackspace),
                      const SizedBox(height: 16),

                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          lang.optionalNotes,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),

                      TextField(
                        controller: _notesController,
                        maxLines: 3,
                        textDirection: TextDirection.rtl,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface,
                        ),
                        decoration: InputDecoration(
                          hintText: lang.addNotesHint,
                          hintStyle: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          contentPadding: const EdgeInsets.all(12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: theme.dividerColor),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: theme.dividerColor),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () => context.goNamed(Routes.posScreen),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.primary,
                            foregroundColor: theme.colorScheme.onPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
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
                      ),
                      const SizedBox(height: 8),

                      SizedBox(
                        width: double.infinity,
                        height: 40,
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: theme.colorScheme.error,
                            side: BorderSide(color: theme.dividerColor),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
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
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: row.map((key) {
              final isBackspace = key == '⌫';
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: row.indexOf(key) == 0 ? 0 : 8,
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
    final theme = Theme.of(context);

    return Material(
      color: isBackspace
          ? theme.colorScheme.errorContainer
          : theme.colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        splashColor: isBackspace
            ? theme.colorScheme.error.withValues(alpha: .2)
            : theme.dividerColor,
        child: SizedBox(
          height: 48,
          child: Center(
            child: isBackspace
                ? Icon(
                    Icons.backspace_outlined,
                    color: theme.colorScheme.error,
                    size: 24,
                  )
                : Text(
                    label,
                    style: theme.textTheme.displayMedium?.copyWith(
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

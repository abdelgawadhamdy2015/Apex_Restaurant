import 'package:apex_restaurant/core/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// ══════════════════════════════════════════════════════════════
// Usage: show as dialog
//   showDialog(context: context, builder: (_) => const ShiftStartDialog());
// ══════════════════════════════════════════════════════════════

class ShiftStartDialog extends StatefulWidget {
  const ShiftStartDialog({super.key});

  @override
  State<ShiftStartDialog> createState() => _ShiftStartDialogState();
}

class _ShiftStartDialogState extends State<ShiftStartDialog> {
  String _amount = '0.00';
  final TextEditingController _notesController = TextEditingController();

  // ── Numpad logic ────────────────────────────────────────────
  void _onKey(String key) {
    setState(() {
      if (key == '.') {
        if (_amount.contains('.')) return;
        _amount = '$_amount.';
      } else {
        // Remove placeholder "0.00" on first real digit
        String raw = _amount.replaceAll('.', '');
        if (raw == '000') raw = '';
        raw += key;

        // Format: keep up to 2 decimal places
        if (raw.length <= 10) {
          // Pad to at least 3 digits so we always have X.XX
          while (raw.length < 3) {
            raw = '0$raw';
          }
          final intPart = raw.substring(0, raw.length - 2);
          final decPart = raw.substring(raw.length - 2);
          // Remove leading zeros from int part
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
      while (raw.length < 3) {
        raw = '0$raw';
      }
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
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 32),
        child: Center(
          child: Container(
            width: 480,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  // ignore: deprecated_member_use
                  color: Colors.black.withOpacity(0.18),
                  blurRadius: 32,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ── Title ──────────────────────────────────
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 22),
                  child: Text(
                    'بداية الوردية',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1B3A6B),
                      fontFamily: 'Cairo',
                    ),
                  ),
                ),
                const Divider(height: 1, color: Color(0xFFE5E7EB)),

                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // ── Label ────────────────────────────
                      const Text(
                        'العهدة الافتتاحية',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF6B7280),
                          fontFamily: 'Cairo',
                        ),
                      ),
                      const SizedBox(height: 8),

                      // ── Amount display ───────────────────
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFFD1D5DB)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            // Amount (LTR number)
                            Expanded(
                              child: Text(
                                _amount,
                                textDirection: TextDirection.ltr,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF111827),
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                            const Text(
                              'SAR',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF6B7280),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),

                      // ── Numpad ───────────────────────────
                      _Numpad(onKey: _onKey, onBackspace: _onBackspace),
                      const SizedBox(height: 16),

                      // ── Notes label ──────────────────────
                      const Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'ملاحظات (اختياري)',
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF6B7280),
                            fontFamily: 'Cairo',
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),

                      // ── Notes field ──────────────────────
                      TextField(
                        controller: _notesController,
                        maxLines: 3,
                        textDirection: TextDirection.rtl,
                        style: const TextStyle(
                          fontSize: 14,
                          fontFamily: 'Cairo',
                          color: Color(0xFF111827),
                        ),
                        decoration: InputDecoration(
                          hintText: 'أضف ملاحظاتك هنا...',
                          hintStyle: const TextStyle(
                            color: Color(0xFFADB5BD),
                            fontSize: 14,
                            fontFamily: 'Cairo',
                          ),
                          contentPadding: const EdgeInsets.all(14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color(0xFFD1D5DB),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color(0xFFD1D5DB),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color(0xFF1B3A6B),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // ── Save button ──────────────────────
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: () {
                            context.goNamed(Routes.posScreen);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1B3A6B),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'حفظ وفتح الوردية',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // ── Cancel button ────────────────────
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFFE53935),
                            side: const BorderSide(color: Color(0xFFE5E7EB)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'إلغاء',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Cairo',
                              color: Color(0xFFE53935),
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

// ══════════════════════════════════════════════════════════════
// Numpad Widget
// ══════════════════════════════════════════════════════════════
class _Numpad extends StatelessWidget {
  final void Function(String) onKey;
  final VoidCallback onBackspace;

  const _Numpad({required this.onKey, required this.onBackspace});

  @override
  Widget build(BuildContext context) {
    // RTL layout: 1 2 3 / 4 5 6 / 7 8 9 / . 0 ⌫
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
    return Material(
      color: isBackspace ? const Color(0xFFFFE4E4) : const Color(0xFFF3F4F6),
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        splashColor: isBackspace
            ? const Color(0xFFFFCDD2)
            : const Color(0xFFE5E7EB),
        child: SizedBox(
          height: 58,
          child: Center(
            child: isBackspace
                ? const Icon(
                    Icons.backspace_outlined,
                    color: Color(0xFFE53935),
                    size: 22,
                  )
                : Text(
                    label,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF1F2937),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

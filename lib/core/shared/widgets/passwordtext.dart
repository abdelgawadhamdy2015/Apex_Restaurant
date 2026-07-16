import 'package:apex_restaurant/gen/assets.gen.dart';
import 'package:apex_restaurant/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PasswordText extends StatefulWidget {
  final String hint;
  final bool obscure;
  final Color? fillColor;
  final TextStyle? hintStyle;
  final TextStyle? inputTextStyle;
  final TextEditingController controller;

  const PasswordText({
    super.key,
    required this.hint,
    this.obscure = true,
    required this.controller,
    this.fillColor,
    this.hintStyle,
    this.inputTextStyle,
  });

  @override
  State<PasswordText> createState() => _PasswordTextState();
}

class _PasswordTextState extends State<PasswordText> {
  late bool _obscured;

  @override
  void initState() {
    super.initState();
    _obscured = widget.obscure;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return TextFormField(
      controller: widget.controller,
      obscureText: _obscured,
      obscuringCharacter: '*',
      style: widget.inputTextStyle ?? textTheme.bodyMedium,
      textAlignVertical: TextAlignVertical.center,
      decoration: InputDecoration(
        hintText: widget.hint,
        hintStyle: widget.hintStyle ?? textTheme.bodyMedium,
        fillColor: widget.fillColor,
        suffixIcon: IconButton(
          onPressed: () {
            setState(() => _obscured = !_obscured);
          },
          icon: SvgPicture.asset(
            Assets.eye,
            colorFilter: ColorFilter.mode(colorScheme.primary, BlendMode.srcIn),
          ),
        ),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "⚠ ${S.of(context).pleaseFill} ${S.of(context).password}";
        }
        return null;
      },
    );
  }
}

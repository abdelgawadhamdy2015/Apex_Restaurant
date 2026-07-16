import 'package:apex_restaurant/generated/l10n.dart';
import 'package:flutter/material.dart';

class MyTextForm extends StatelessWidget {
  final String? hint;
  final String? excep;
  final InputBorder? focusedBorder;
  final InputBorder? enabledBorder;
  final Widget? suffixIcon;
  final Widget? icon;
  final String? labelText;
  final TextStyle? hintStyle;
  final TextStyle? inputTextStyle;
  final EdgeInsetsGeometry? contentPadding;
  final Color? fillColor;
  final String? initialValue;
  final bool? obsecure;
  final FormFieldValidator<String>? validator;
  final FormFieldSetter<String>? onSaved;
  final ValueChanged<String>? onChanged;

  final TextEditingController? controller;
  final VoidCallback? onTap;
  final VoidCallback? onEditingComplete;

  final bool readOnly;
  final bool enabled;
  final int maxLines;
  final double? height;
  final TextAlign textAlign;

  const MyTextForm({
    super.key,
    this.hint,
    this.excep,
    this.controller,
    this.focusedBorder,
    this.enabledBorder,
    this.suffixIcon,
    this.icon,
    this.labelText,
    this.hintStyle,
    this.inputTextStyle,
    this.contentPadding,
    this.fillColor,
    this.validator,
    this.onChanged,
    this.onSaved,
    this.onTap,
    this.onEditingComplete,
    this.initialValue,
    this.readOnly = false,
    this.enabled = true,
    this.maxLines = 1,
    this.height,
    this.textAlign = TextAlign.start,
    this.obsecure = false,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SizedBox(
      height: height,
      child: TextFormField(
        obscureText: obsecure ?? false,
        controller: controller,
        initialValue: controller == null ? initialValue : null,
        textAlign: textAlign,
        style: inputTextStyle ?? textTheme.bodyMedium,
        maxLines: maxLines,
        enabled: enabled,
        readOnly: readOnly,
        onTap: onTap,
        onSaved: onSaved,
        onChanged: onChanged,
        onEditingComplete: onEditingComplete,
        validator:
            validator ??
            (value) {
              if (value == null || value.trim().isEmpty) {
                return "⚠ ${S.of(context).pleaseFill} ${excep ?? ''}";
              }
              return null;
            },
        decoration: InputDecoration(
          hintText: hint,
          labelText: labelText,
          hintStyle: hintStyle,
          labelStyle: hintStyle,
          prefixIcon: icon,
          suffixIcon: suffixIcon,
          contentPadding: contentPadding,
          fillColor: fillColor,
          focusedBorder: focusedBorder,
          enabledBorder: enabledBorder,
        ),
      ),
    );
  }
}

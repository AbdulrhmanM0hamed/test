import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextInputType? keyboardType;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final Widget? prefix;
  final Widget? suffix;
  final bool readOnly;
  final VoidCallback? onTap;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLines;
  final int? maxLength;
  final TextDirection? textDirection;
  final bool? enabled;
  final TextAlign textAlign;
  final String? initialValue;
  final FocusNode? focusNode;
  final Color? fillColor;
  final String? Function(String?)? onSaved;

  const CustomTextField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.validator,
    this.obscureText = false,
    this.keyboardType,
    this.onChanged,
    this.onSubmitted,
    this.prefix,
    this.suffix,
    this.readOnly = false,
    this.onTap,
    this.inputFormatters,
    this.maxLines = 1,
    this.maxLength,
    this.textDirection,
    this.enabled,
    this.textAlign = TextAlign.start,
    this.initialValue,
    this.focusNode,
    this.fillColor,
    this.onSaved,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onSaved: onSaved,
      controller: controller,
      initialValue: initialValue,
      focusNode: focusNode,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: prefix,
        suffixIcon: suffix,
        filled: true,
        fillColor: fillColor ?? Colors.transparent,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.error),
        ),
      ),
      validator: validator,
      obscureText: obscureText,
      keyboardType: keyboardType,
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
      readOnly: readOnly,
      onTap: onTap,
      inputFormatters: inputFormatters,
      maxLines: maxLines,
      maxLength: maxLength,
      textDirection: textDirection,
      enabled: enabled,
      textAlign: textAlign,
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }
}

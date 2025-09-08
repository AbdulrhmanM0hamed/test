import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class CustomDropdown<T> extends StatelessWidget {
  final String label;
  final T? value;
  final List<T> items;
  final String Function(T) itemToString;
  final void Function(T?)? onChanged;
  final String? Function(T?)? validator;
  final bool isEnabled;
  final double? width;

  const CustomDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.itemToString,
    this.onChanged,
    this.validator,
    this.isEnabled = true,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: DropdownButtonFormField<T>(
        decoration: InputDecoration(
          labelText: label,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
          filled: true,
        ),
        value: value != null && items.contains(value) ? value : null,
        items: items.map((T item) {
          return DropdownMenuItem<T>(
            value: item,
            child: Text(
              itemToString(item),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        }).toList(),
        onChanged: isEnabled ? onChanged : null,
        validator: validator,
        icon: const Icon(Icons.keyboard_arrow_down),
        isExpanded: true,
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }
} 
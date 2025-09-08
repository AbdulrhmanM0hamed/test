import 'package:flutter/material.dart';

class LocationDropdown<T> extends StatelessWidget {
  final String hint;
  final List<T> items;
  final T? selectedItem;
  final String Function(T) getLabel;
  final ValueChanged<T?> onChanged;
  final bool isLoading;

  const LocationDropdown({
    super.key,
    required this.hint,
    required this.items,
    required this.selectedItem,
    required this.getLabel,
    required this.onChanged,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      ),
      child: isLoading
          ? const Center(heightFactor: 1, child: CircularProgressIndicator())
          : DropdownButtonHideUnderline(
              child: DropdownButton<T>(
                isExpanded: true,
                hint: Text(hint),
                value: selectedItem,
                items: items
                    .map(
                      (e) => DropdownMenuItem<T>(
                        value: e,
                        child: Text(getLabel(e)),
                      ),
                    )
                    .toList(),
                onChanged: onChanged,
              ),
            ),
    );
  }
}

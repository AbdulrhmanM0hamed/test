import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class CustomRatingBar extends StatelessWidget {
  final double rating;
  final double size;
  final bool isEditable;
  final ValueChanged<double>? onRatingChanged;
  final Color? activeColor;
  final Color? inactiveColor;

  const CustomRatingBar({
    super.key,
    required this.rating,
    this.size = 24,
    this.isEditable = false,
    this.onRatingChanged,
    this.activeColor,
    this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return GestureDetector(
          onTap: isEditable
              ? () => onRatingChanged?.call((index + 1).toDouble())
              : null,
          child: Icon(
            index < rating ? Icons.star : Icons.star_border,
            size: size,
            color: index < rating
                ? activeColor ?? AppColors.starActive
                : inactiveColor ?? AppColors.starInactive,
          ),
        );
      }),
    );
  }
}

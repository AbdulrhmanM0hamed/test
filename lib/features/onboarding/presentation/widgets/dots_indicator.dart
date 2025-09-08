import 'package:flutter/material.dart';

class CustomDotsIndicator extends StatelessWidget {
  final int dotsCount;
  final int position;

  const CustomDotsIndicator({
    super.key,
    required this.dotsCount,
    required this.position,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        dotsCount,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 8,
          width: position == index ? 24 : 8,
          decoration: BoxDecoration(
            color: position == index
                ? const Color(0xFF0F3C77) // Dark blue for active dot
                : const Color(0xFFD8D8D8), // Light gray for inactive dots
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
} 
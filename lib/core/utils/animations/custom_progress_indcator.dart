import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:test/core/utils/theme/app_colors.dart';

class CustomProgressIndicator extends StatelessWidget {
  final Color color;
  final double size;

  const CustomProgressIndicator({
    super.key,
    this.color = AppColors.primary,
    this.size = 50.0,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        color: const Color.fromARGB(255, 226, 224, 224),
        margin: const EdgeInsets.all(16),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SpinKitWaveSpinner(color: color, size: size),
        ),
      ),
    );
  }
}

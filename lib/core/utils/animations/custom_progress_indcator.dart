import 'package:flutter/material.dart';
import 'package:test/core/utils/constant/app_assets.dart';

class CustomProgressIndicator extends StatelessWidget {
  final double size;

  const CustomProgressIndicator({super.key, this.size = 100.0});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        color: Colors.grey[650],
        margin: const EdgeInsets.all(16),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Image.asset(
            AppAssets.loadingGif,
            width: size,
            height: size,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}

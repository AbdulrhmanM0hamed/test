import 'package:flutter/material.dart';
import 'package:test/features/home/presentation/widgets/offers_slider.dart';

class OffersSection extends StatelessWidget {
  const OffersSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [],
          ),
        ),
        const SizedBox(height: 8),
        const OffersSlider(),
      ],
    );
  }
}

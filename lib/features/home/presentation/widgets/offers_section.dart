import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/features/home/presentation/cubit/slider_cubit.dart';
import 'package:test/features/home/presentation/cubit/slider_state.dart';
import 'package:test/features/home/presentation/widgets/offers_slider.dart';
import 'package:test/features/home/presentation/widgets/offers_slider_shimmer.dart';

class OffersSection extends StatelessWidget {
  const OffersSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SliderCubit, SliderState>(
      builder: (context, state) {
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
            if (state is SliderLoading)
              const OffersSliderShimmer()
            else if (state is SliderLoaded)
              OffersSlider(sliders: state.sliders)
            else if (state is SliderError)
              Container(
                height: 180,
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: Text(
                    'Failed to load sliders',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              )
            else
              const SizedBox.shrink(),
          ],
        );
      },
    );
  }
}

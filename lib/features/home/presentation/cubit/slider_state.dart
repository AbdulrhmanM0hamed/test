import 'package:test/features/home/domain/entities/slider.dart';

abstract class SliderState {}

class SliderInitial extends SliderState {}

class SliderLoading extends SliderState {}

class SliderLoaded extends SliderState {
  final List<Slider> sliders;

  SliderLoaded({required this.sliders});
}

class SliderError extends SliderState {
  final String message;

  SliderError({required this.message});
}

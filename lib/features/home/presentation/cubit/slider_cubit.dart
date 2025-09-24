import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/core/services/data_refresh_service.dart';
import 'package:test/core/utils/error/error_handler.dart';
import 'package:test/features/home/domain/usecases/get_sliders_use_case.dart';
import 'package:test/features/home/presentation/cubit/slider_state.dart';

class SliderCubit extends Cubit<SliderState> {
  final GetSlidersUseCase getSlidersUseCase;
  final DataRefreshService? dataRefreshService;

  SliderCubit({
    required this.getSlidersUseCase,
    this.dataRefreshService,
  }) : super(SliderInitial()) {
    dataRefreshService?.registerRefreshCallback(_refreshData);
  }

  Future<void> getSliders() async {
    try {
      if (isClosed) return;
      emit(SliderLoading());

      final sliders = await getSlidersUseCase();

      if (isClosed) return;
      emit(SliderLoaded(sliders: sliders));
    } catch (e) {
      if (isClosed) return;
      final errorMessage = ErrorHandler.extractErrorMessage(e);
      emit(SliderError(message: errorMessage));
    }
  }

  void _refreshData() {
    getSliders();
  }

  @override
  Future<void> close() {
    dataRefreshService?.unregisterRefreshCallback(_refreshData);
    return super.close();
  }
}

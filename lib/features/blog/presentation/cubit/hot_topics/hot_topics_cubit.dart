import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_hot_topics_usecase.dart';
import 'hot_topics_state.dart';

class HotTopicsCubit extends Cubit<HotTopicsState> {
  final GetHotTopicsUseCase getHotTopicsUseCase;

  HotTopicsCubit({required this.getHotTopicsUseCase}) : super(HotTopicsInitial());

  Future<void> getHotTopics() async {
    emit(HotTopicsLoading());

    try {
      final result = await getHotTopicsUseCase.call();

      result.fold(
        (failure) => emit(HotTopicsError(message: failure.message)),
        (hotTopics) => emit(HotTopicsLoaded(hotTopics: hotTopics)),
      );
    } catch (e) {
      emit(HotTopicsError(message: 'An unexpected error occurred'));
    }
  }

  Future<void> refreshHotTopics() async {
    await getHotTopics();
  }
}

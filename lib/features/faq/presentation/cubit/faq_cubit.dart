import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_faqs_usecase.dart';
import 'faq_state.dart';

class FAQCubit extends Cubit<FAQState> {
  final GetFAQsUseCase getFAQsUseCase;

  FAQCubit({required this.getFAQsUseCase}) : super(FAQInitial());

  Future<void> getFAQs() async {
    emit(FAQLoading());
    
    try {
      final result = await getFAQsUseCase();
      
      result.fold(
        (failure) => emit(FAQError(message: failure.message)),
        (faqs) => emit(FAQLoaded(faqs: faqs)),
      );
    } catch (e) {
      emit(FAQError(message: 'An unexpected error occurred'));
    }
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_about_us_usecase.dart';
import 'about_us_state.dart';

class AboutUsCubit extends Cubit<AboutUsState> {
  final GetAboutUsUseCase getAboutUsUseCase;

  AboutUsCubit({required this.getAboutUsUseCase}) : super(AboutUsInitial());

  Future<void> getAboutUs() async {
    emit(AboutUsLoading());
    
    try {
      final result = await getAboutUsUseCase();
      
      result.fold(
        (failure) => emit(AboutUsError(message: failure.message)),
        (aboutUs) => emit(AboutUsLoaded(aboutUs: aboutUs)),
      );
    } catch (e) {
      emit(AboutUsError(message: 'An unexpected error occurred'));
    }
  }
}

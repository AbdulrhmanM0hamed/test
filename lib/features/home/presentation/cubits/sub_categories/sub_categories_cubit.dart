import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/features/home/domain/usecases/get_sub_categories_usecase.dart';
import 'package:test/features/home/presentation/cubits/sub_categories/sub_categories_state.dart';

class SubCategoriesCubit extends Cubit<SubCategoriesState> {
  final GetSubCategoriesUsecase getSubCategoriesUsecase;

  SubCategoriesCubit({required this.getSubCategoriesUsecase}) 
      : super(SubCategoriesInitial());

  Future<void> getSubCategories() async {
    emit(SubCategoriesLoading());
    
    final result = await getSubCategoriesUsecase();
    
    result.fold(
      (failure) => emit(SubCategoriesError(message: failure.message)),
      (subCategories) => emit(SubCategoriesLoaded(subCategories: subCategories)),
    );
  }
}

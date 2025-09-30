import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/features/categories/domain/usecases/get_sub_categories_usecase.dart';
import 'package:test/features/categories/presentation/cubit/sub_category_state.dart';

class SubCategoryCubit extends Cubit<SubCategoryState> {
  final GetSubCategoriesUseCase getSubCategoriesUseCase;

  SubCategoryCubit({required this.getSubCategoriesUseCase})
      : super(SubCategoryInitial());

  Future<void> getSubCategories() async {
    emit(SubCategoryLoading());
    
    try {
      final response = await getSubCategoriesUseCase();
      
      if (response.success) {
        emit(SubCategoryLoaded(subCategories: response.data!));
      } else {
        emit(SubCategoryError(message: response.message));
      }
    } catch (e) {
      emit(SubCategoryError(message: 'حدث خطأ أثناء جلب الفئات الفرعية: ${e.toString()}'));
    }
  }

  Future<void> refreshSubCategories() async {
    await getSubCategories();
  }
}

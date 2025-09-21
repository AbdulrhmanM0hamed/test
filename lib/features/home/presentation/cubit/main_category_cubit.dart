import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/core/services/data_refresh_service.dart';
import 'package:test/core/utils/error/error_handler.dart';
import 'package:test/features/home/domain/usecases/get_main_categories_usecase.dart';
import 'package:test/features/home/presentation/cubit/main_category_state.dart';

class MainCategoryCubit extends Cubit<MainCategoryState> {
  final GetMainCategoriesUseCase getMainCategoriesUseCase;
  final DataRefreshService? dataRefreshService;

  MainCategoryCubit({
    required this.getMainCategoriesUseCase,
    this.dataRefreshService,
  }) : super(MainCategoryInitial()) {
    dataRefreshService?.registerRefreshCallback(_refreshData);
  }

  Future<void> getMainCategories() async {
    try {
      if (isClosed) return;
      emit(MainCategoryLoading());

      final response = await getMainCategoriesUseCase();

      if (isClosed) return;
      if (response.success) {
        emit(MainCategoryLoaded(categories: response.data ?? []));
      } else {
        String errorMessage =
            response.getFirstErrorMessage() ?? response.message;
        emit(MainCategoryError(message: errorMessage));
      }
    } catch (e) {
      if (isClosed) return;
      final errorMessage = ErrorHandler.extractErrorMessage(e);
      emit(MainCategoryError(message: errorMessage));
    }
  }

  void _refreshData() {
    getMainCategories();
  }

  @override
  Future<void> close() {
    dataRefreshService?.unregisterRefreshCallback(_refreshData);
    return super.close();
  }
}

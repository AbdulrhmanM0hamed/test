import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/core/services/data_refresh_service.dart';
import 'package:test/features/home/domain/usecases/get_sub_categories_usecase.dart';
import 'package:test/features/home/presentation/cubits/sub_categories/sub_categories_state.dart';

class SubCategoriesCubit extends Cubit<SubCategoriesState> {
  final GetSubCategoriesUsecase getSubCategoriesUsecase;
  final DataRefreshService? dataRefreshService;

  SubCategoriesCubit({
    required this.getSubCategoriesUsecase,
    this.dataRefreshService,
  }) : super(SubCategoriesInitial()) {
    dataRefreshService?.registerRefreshCallback(_refreshData);
  }

  Future<void> getSubCategories({bool refresh = false}) async {
    if (isClosed) return;
    
    emit(SubCategoriesLoading());
    
    final result = await getSubCategoriesUsecase();
    
    result.fold(
      (failure) => emit(SubCategoriesError(message: failure.message)),
      (subCategories) => emit(SubCategoriesLoaded(subCategories: subCategories)),
    );
  }

  void _refreshData() {
    getSubCategories(refresh: true);
  }

  @override
  Future<void> close() {
    dataRefreshService?.unregisterRefreshCallback(_refreshData);
    return super.close();
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/core/utils/error/error_handler.dart';
import 'package:test/features/categories/domain/usecases/get_products_by_department_usecase.dart';
import 'package:test/features/categories/presentation/cubit/products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  final GetProductsByDepartmentUseCase getProductsByDepartmentUseCase;

  ProductsCubit({required this.getProductsByDepartmentUseCase}) : super(ProductsInitial());

  Future<void> getProductsByDepartment(String departmentName, {int page = 1}) async {
    try {
      if (isClosed) return;
      emit(ProductsLoading());
      
      final response = await getProductsByDepartmentUseCase(departmentName, page: page);
      
      if (isClosed) return;
      if (response.success) {
        emit(ProductsLoaded(
          products: response.data!.data,
          pagination: response.data!.pagination,
          departmentName: departmentName,
        ));
      } else {
        String errorMessage = response.getFirstErrorMessage() ?? response.message;
        emit(ProductsError(message: errorMessage));
      }
    } catch (e) {
      if (isClosed) return;
      final errorMessage = ErrorHandler.extractErrorMessage(e);
      emit(ProductsError(message: errorMessage));
    }
  }

  void clearProducts() {
    if (!isClosed) {
      emit(ProductsInitial());
    }
  }
}

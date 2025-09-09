import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/core/services/data_refresh_service.dart';
import 'package:test/core/utils/error/error_handler.dart';
import 'package:test/features/categories/domain/usecases/get_departments_usecase.dart';
import 'package:test/features/categories/presentation/cubit/department_state.dart';

class DepartmentCubit extends Cubit<DepartmentState> {
  final GetDepartmentsUseCase getDepartmentsUseCase;
  final DataRefreshService? dataRefreshService;

  DepartmentCubit({
    required this.getDepartmentsUseCase,
    this.dataRefreshService,
  })
    : super(DepartmentInitial()) {
    dataRefreshService?.registerRefreshCallback(_refreshData);
  }

  Future<void> getDepartments() async {
    try {
      if (isClosed) return;
      emit(DepartmentLoading());

      final response = await getDepartmentsUseCase();

      if (isClosed) return;
      if (response.success) {
        emit(DepartmentLoaded(departments: response.data ?? []));
      } else {
        String errorMessage =
            response.getFirstErrorMessage() ?? response.message;
        emit(DepartmentError(message: errorMessage));
      }
    } catch (e) {
      if (isClosed) return;
      final errorMessage = ErrorHandler.extractErrorMessage(e);
      emit(DepartmentError(message: errorMessage));
    }
  }

  void _refreshData() {
    getDepartments();
  }

  @override
  Future<void> close() {
    dataRefreshService?.unregisterRefreshCallback(_refreshData);
    return super.close();
  }
}

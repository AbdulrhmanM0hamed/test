import 'package:test/core/models/api_response.dart';
import 'package:test/features/categories/domain/entities/department.dart';
import 'package:test/features/categories/domain/repositories/department_repository.dart';

class GetDepartmentsUseCase {
  final DepartmentRepository repository;

  const GetDepartmentsUseCase(this.repository);

  Future<ApiResponse<List<Department>>> call() async {
    return await repository.getDepartments();
  }
}

import 'package:test/core/models/api_response.dart';
import 'package:test/features/categories/domain/entities/department.dart';

abstract class DepartmentRepository {
  Future<ApiResponse<List<Department>>> getDepartments();
}

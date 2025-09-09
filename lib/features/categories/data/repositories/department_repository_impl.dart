import 'package:test/core/models/api_response.dart';
import 'package:test/features/categories/data/datasources/department_remote_data_source.dart';
import 'package:test/features/categories/domain/entities/department.dart';
import 'package:test/features/categories/domain/repositories/department_repository.dart';

class DepartmentRepositoryImpl implements DepartmentRepository {
  final DepartmentRemoteDataSource remoteDataSource;

  DepartmentRepositoryImpl({required this.remoteDataSource});

  @override
  Future<ApiResponse<List<Department>>> getDepartments() async {
    return await remoteDataSource.getDepartments();
  }
}

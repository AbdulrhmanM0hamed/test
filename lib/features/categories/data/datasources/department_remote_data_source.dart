import 'package:test/core/models/api_response.dart';
import 'package:test/core/services/network/dio_service.dart';
import 'package:test/core/utils/constant/api_endpoints.dart';
import 'package:test/features/categories/data/models/department_model.dart';

abstract class DepartmentRemoteDataSource {
  Future<ApiResponse<List<DepartmentModel>>> getDepartments();
}

class DepartmentRemoteDataSourceImpl implements DepartmentRemoteDataSource {
  final DioService dioService;

  DepartmentRemoteDataSourceImpl({required this.dioService});

  @override
  Future<ApiResponse<List<DepartmentModel>>> getDepartments() async {
    final response = await dioService.getWithResponse<List<DepartmentModel>>(
      ApiEndpoints.categories,
      dataParser: (data) {
        if (data is List) {
          return data.map((department) => DepartmentModel.fromJson(department)).toList();
        }
        return [];
      },
    );
    return response;
  }
}

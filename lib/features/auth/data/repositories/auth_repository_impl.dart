import 'package:test/core/models/api_response.dart';
import 'package:test/features/auth/domain/entities/user.dart';
import 'package:test/features/auth/domain/entities/login_request.dart';
import 'package:test/features/auth/domain/repositories/auth_repository.dart';
import 'package:test/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:test/features/auth/data/models/login_request_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<ApiResponse<User>> login(LoginRequest loginRequest) async {
    final loginRequestModel = LoginRequestModel.fromEntity(loginRequest);
    return await remoteDataSource.login(loginRequestModel);
  }

  @override
  Future<User> register({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String birthDate,
    required String gender,
    required int countryId,
    required int cityId,
    required int regionId,
  }) async {
    return await remoteDataSource.register(
      name: name,
      email: email,
      password: password,
      phone: phone,
      birthDate: birthDate,
      gender: gender,
      countryId: countryId,
      cityId: cityId,
      regionId: regionId,
    );
  }

  @override
  Future<ApiResponse<void>> logout() async {
    return await remoteDataSource.logout();
  }

  @override
  Future<void> resetPassword(String email) async {
    return await remoteDataSource.resetPassword(email);
  }
}

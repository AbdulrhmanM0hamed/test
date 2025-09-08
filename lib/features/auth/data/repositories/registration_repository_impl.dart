import 'package:test/core/models/api_response.dart';
import 'package:test/features/auth/data/datasources/registration_remote_data_source.dart';
import 'package:test/features/auth/data/models/signup_request_model.dart';
import 'package:test/features/auth/domain/entities/signup_request.dart';
import 'package:test/features/auth/domain/entities/user.dart';
import 'package:test/features/auth/domain/repositories/registration_repository.dart';

class RegistrationRepositoryImpl implements RegistrationRepository {
  final RegistrationRemoteDataSource remoteDataSource;

  RegistrationRepositoryImpl({required this.remoteDataSource});

  @override
  Future<ApiResponse<User>> signup(SignupRequest signupRequest) async {
    final signupRequestModel = SignupRequestModel(
      name: signupRequest.name,
      email: signupRequest.email,
      phone: signupRequest.phone,
      birthDate: signupRequest.birthDate,
      gender: signupRequest.gender,
      signFrom: signupRequest.signFrom,
      password: signupRequest.password,
      confirmPassword: signupRequest.confirmPassword,
      countryId: signupRequest.countryId,
      cityId: signupRequest.cityId,
      regionId: signupRequest.regionId,
    );
    
    final response = await remoteDataSource.signup(signupRequestModel);

    // Convert UserModel to User entity if successful
    if (response.success && response.data != null) {
      final user = User(
        id: response.data!.id,
        name: response.data!.name,
        email: response.data!.email,
        phone: response.data!.phone,
        gender: response.data!.gender ?? 'unknown',
        status: response.data!.status ?? '1',
        createdAt:
            response.data!.createdAt?.toString() ??
            DateTime.now().toIso8601String(),
        updatedAt:
            response.data!.updatedAt?.toString() ??
            DateTime.now().toIso8601String(),
        countryId: response.data!.countryId ?? 0,
        cityId: response.data!.cityId ?? 0,
        regionId: response.data!.regionId ?? 0,
        token: response.data!.token ?? '',
        expiresIn: response.data!.expiresIn ?? 0,
        countryName: response.data!.countryName ?? '',
        cityName: response.data!.cityName ?? '',
        regionName: response.data!.regionName ?? '',
      );

      return ApiResponse.success(
        message: response.message,
        data: user,
        statusCode: response.statusCode,
      );
    } else {
      return ApiResponse.error(
        message: response.message,
        errors: response.errors,
        statusCode: response.statusCode,
      );
    }
  }
}

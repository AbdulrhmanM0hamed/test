import 'package:test/features/auth/data/datasources/registration_remote_data_source.dart';
import 'package:test/features/auth/data/models/signup_request_model.dart';
import 'package:test/features/auth/domain/entities/signup_request.dart';
import 'package:test/features/auth/domain/entities/user.dart';
import 'package:test/features/auth/domain/repositories/registration_repository.dart';

class RegistrationRepositoryImpl implements RegistrationRepository {
  final RegistrationRemoteDataSource remoteDataSource;

  RegistrationRepositoryImpl({required this.remoteDataSource});

  @override
  Future<User> signup(SignupRequest signupRequest) async {
    try {
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
      
      return await remoteDataSource.signup(signupRequestModel);
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }
}

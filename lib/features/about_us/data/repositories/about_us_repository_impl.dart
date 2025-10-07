import 'package:dartz/dartz.dart';
import 'package:test/core/error/failures.dart';
import 'package:test/core/services/network/network_info.dart';
import '../datasources/about_us_remote_data_source.dart';
import '../../domain/entities/about_us.dart';
import '../../domain/repositories/about_us_repository.dart';

class AboutUsRepositoryImpl implements AboutUsRepository {
  final AboutUsRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  AboutUsRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, AboutUs>> getAboutUs() async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.getAboutUs();
        if (response.success) {
          return Right(response.data!.toEntity());
        } else {
          return Left(ServerFailure(message: response.message));
        }
      } catch (e) {
        return Left(ServerFailure(message: 'Failed to fetch About Us information'));
      }
    } else {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }
}

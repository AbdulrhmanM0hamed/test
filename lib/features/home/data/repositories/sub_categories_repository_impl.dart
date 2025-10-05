import 'package:dartz/dartz.dart';
import 'package:test/core/error/failures.dart';
import 'package:test/core/services/network/network_info.dart';
import 'package:test/features/home/data/datasources/sub_categories_remote_data_source.dart';
import 'package:test/features/home/domain/entities/sub_category.dart';
import 'package:test/features/home/domain/repositories/sub_categories_repository.dart';

class SubCategoriesRepositoryImpl implements SubCategoriesRepository {
  final SubCategoriesRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  SubCategoriesRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<SubCategory>>> getSubCategories() async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.getSubCategories();
        
        if (response.success) {
          return Right(response.data ?? []);
        } else {
          return Left(ServerFailure(message: response.message));
        }
      } catch (e) {
        return Left(ServerFailure(message: 'Failed to fetch sub-categories'));
      }
    } else {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }
}

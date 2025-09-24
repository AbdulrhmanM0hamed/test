import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/product_review_repository.dart';
import '../datasources/product_review_remote_data_source.dart';

class ProductReviewRepositoryImpl implements ProductReviewRepository {
  final ProductReviewRemoteDataSource _remoteDataSource;

  ProductReviewRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, String>> submitReview({
    required int productId,
    required String review,
    required int star,
  }) async {
    try {
      final response = await _remoteDataSource.submitReview(
        productId: productId,
        review: review,
        star: star,
      );

      if (response.success) {
        return Right(response.message);
      } else {
        return Left(ServerFailure(message: response.message));
      }
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}

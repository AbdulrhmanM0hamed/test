import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';

abstract class ProductReviewRepository {
  Future<Either<Failure, String>> submitReview({
    required int productId,
    required String review,
    required int star,
  });
}

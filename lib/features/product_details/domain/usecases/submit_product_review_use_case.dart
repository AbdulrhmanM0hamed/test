
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/product_review_repository.dart';

class SubmitProductReviewUseCase {
  final ProductReviewRepository _repository;

  SubmitProductReviewUseCase(this._repository);

  Future<Either<Failure, String>> call({
    required int productId,
    required String review,
    required int star,
  }) async {
    // Validate star rating (1-5)
    if (star < 1 || star > 5) {
      return Left(ValidationFailure(message: 'Star rating must be between 1 and 5'));
    }

    // Validate review text
    if (review.trim().isEmpty) {
      return Left(ValidationFailure(message: 'Review text cannot be empty'));
    }

    if (review.trim().length < 10) {
      return Left(ValidationFailure(message: 'Review must be at least 10 characters long'));
    }

    return await _repository.submitReview(
      productId: productId,
      review: review.trim(),
      star: star,
    );
  }
}

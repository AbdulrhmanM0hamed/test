abstract class ProductReviewState {}

class ProductReviewInitial extends ProductReviewState {}

class ProductReviewLoading extends ProductReviewState {}

class ProductReviewSuccess extends ProductReviewState {
  final String message;

  ProductReviewSuccess(this.message);
}

class ProductReviewError extends ProductReviewState {
  final String message;

  ProductReviewError(this.message);
}

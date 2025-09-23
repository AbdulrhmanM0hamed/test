
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/submit_product_review_use_case.dart';
import 'product_review_state.dart';

class ProductReviewCubit extends Cubit<ProductReviewState> {
  final SubmitProductReviewUseCase _submitProductReviewUseCase;

  ProductReviewCubit(this._submitProductReviewUseCase) : super(ProductReviewInitial());

  Future<void> submitReview({
    required int productId,
    required String review,
    required int star,
  }) async {
    emit(ProductReviewLoading());

    final result = await _submitProductReviewUseCase(
      productId: productId,
      review: review,
      star: star,
    );

    result.fold(
      (failure) => emit(ProductReviewError(failure.message)),
      (message) => emit(ProductReviewSuccess(message)),
    );
  }

  void resetState() {
    emit(ProductReviewInitial());
  }
}

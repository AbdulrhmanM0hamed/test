import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/product_details.dart';
import '../../domain/usecases/get_product_details_usecase.dart';

part 'product_details_state.dart';

class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  final GetProductDetailsUseCase _getProductDetailsUseCase;

  ProductDetailsCubit(this._getProductDetailsUseCase) : super(ProductDetailsInitial());

  Future<void> getProductDetails(int productId) async {
    emit(ProductDetailsLoading());

    try {
      final response = await _getProductDetailsUseCase(productId);

      if (response.success && response.data != null) {
        emit(ProductDetailsLoaded(response.data!));
      } else {
        emit(ProductDetailsError(response.message));
      }
    } catch (e) {
      emit(ProductDetailsError('An unexpected error occurred: ${e.toString()}'));
    }
  }

  void resetState() {
    emit(ProductDetailsInitial());
  }
}

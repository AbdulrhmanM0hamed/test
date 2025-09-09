import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_best_seller_products_use_case.dart';
import 'best_seller_products_state.dart';

class BestSellerProductsCubit extends Cubit<BestSellerProductsState> {
  final GetBestSellerProductsUseCase getBestSellerProductsUseCase;

  BestSellerProductsCubit({required this.getBestSellerProductsUseCase})
      : super(BestSellerProductsInitial());

  Future<void> getBestSellerProducts() async {
    if (isClosed) return;
    
    try {
      emit(BestSellerProductsLoading());
      final products = await getBestSellerProductsUseCase();
      
      if (!isClosed) {
        emit(BestSellerProductsLoaded(products: products));
      }
    } catch (e) {
      if (!isClosed) {
        emit(BestSellerProductsError(message: e.toString()));
      }
    }
  }
}

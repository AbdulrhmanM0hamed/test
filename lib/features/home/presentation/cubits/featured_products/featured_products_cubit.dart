import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_featured_products_use_case.dart';
import 'featured_products_state.dart';

class FeaturedProductsCubit extends Cubit<FeaturedProductsState> {
  final GetFeaturedProductsUseCase getFeaturedProductsUseCase;

  FeaturedProductsCubit({required this.getFeaturedProductsUseCase})
      : super(FeaturedProductsInitial());

  Future<void> getFeaturedProducts() async {
    if (isClosed) return;
    
    try {
      emit(FeaturedProductsLoading());
      final products = await getFeaturedProductsUseCase();
      
      if (!isClosed) {
        emit(FeaturedProductsLoaded(products: products));
      }
    } catch (e) {
      if (!isClosed) {
        emit(FeaturedProductsError(message: e.toString()));
      }
    }
  }
}

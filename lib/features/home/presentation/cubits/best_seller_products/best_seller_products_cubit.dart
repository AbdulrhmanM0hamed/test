import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/core/services/data_refresh_service.dart';
import '../../../domain/usecases/get_best_seller_products_use_case.dart';
import 'best_seller_products_state.dart';

class BestSellerProductsCubit extends Cubit<BestSellerProductsState> {
  final GetBestSellerProductsUseCase getBestSellerProductsUseCase;
  final DataRefreshService? dataRefreshService;

  BestSellerProductsCubit({
    required this.getBestSellerProductsUseCase,
    this.dataRefreshService,
  })
      : super(BestSellerProductsInitial()) {
    dataRefreshService?.registerRefreshCallback(_refreshData);
  }

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

  void _refreshData() {
    getBestSellerProducts();
  }

  @override
  Future<void> close() {
    dataRefreshService?.unregisterRefreshCallback(_refreshData);
    return super.close();
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/core/services/data_refresh_service.dart';
import '../../../domain/usecases/get_featured_products_use_case.dart';
import 'featured_products_state.dart';

class FeaturedProductsCubit extends Cubit<FeaturedProductsState> {
  final GetFeaturedProductsUseCase getFeaturedProductsUseCase;
  final DataRefreshService? dataRefreshService;

  FeaturedProductsCubit({
    required this.getFeaturedProductsUseCase,
    this.dataRefreshService,
  }) : super(FeaturedProductsInitial()) {
    // Register for automatic refresh when language changes
    dataRefreshService?.registerRefreshCallback(_refreshData);
  }

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

  /// Refresh data when language changes
  void _refreshData() {
    getFeaturedProducts();
  }

  @override
  Future<void> close() {
    dataRefreshService?.unregisterRefreshCallback(_refreshData);
    return super.close();
  }
}

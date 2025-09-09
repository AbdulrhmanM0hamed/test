import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/core/services/data_refresh_service.dart';
import '../../../domain/usecases/get_latest_products_use_case.dart';
import 'latest_products_state.dart';

class LatestProductsCubit extends Cubit<LatestProductsState> {
  final GetLatestProductsUseCase getLatestProductsUseCase;
  final DataRefreshService? dataRefreshService;

  LatestProductsCubit({
    required this.getLatestProductsUseCase,
    this.dataRefreshService,
  })
    : super(LatestProductsInitial()) {
    dataRefreshService?.registerRefreshCallback(_refreshData);
  }

  Future<void> getLatestProducts() async {
    if (isClosed) return;
    
    try {
      emit(LatestProductsLoading());
      final products = await getLatestProductsUseCase();
      
      if (!isClosed) {
        emit(LatestProductsLoaded(products: products));
      }
    } catch (e) {
      if (!isClosed) {
        emit(LatestProductsError(message: e.toString()));
      }
    }
  }

  void _refreshData() {
    getLatestProducts();
  }

  @override
  Future<void> close() {
    dataRefreshService?.unregisterRefreshCallback(_refreshData);
    return super.close();
  }
}

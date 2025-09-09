import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/core/services/data_refresh_service.dart';
import '../../../domain/usecases/get_special_offer_products_use_case.dart';
import 'special_offer_products_state.dart';

class SpecialOfferProductsCubit extends Cubit<SpecialOfferProductsState> {
  final GetSpecialOfferProductsUseCase getSpecialOfferProductsUseCase;
  final DataRefreshService? dataRefreshService;

  SpecialOfferProductsCubit({
    required this.getSpecialOfferProductsUseCase,
    this.dataRefreshService,
  })
      : super(SpecialOfferProductsInitial()) {
    dataRefreshService?.registerRefreshCallback(_refreshData);
  }

  Future<void> getSpecialOfferProducts() async {
    if (isClosed) return;
    
    try {
      print('SpecialOfferProductsCubit: Loading special offer products...');
      emit(SpecialOfferProductsLoading());
      final products = await getSpecialOfferProductsUseCase();
      
      if (!isClosed) {
        print('SpecialOfferProductsCubit: Loaded ${products.length} products');
        emit(SpecialOfferProductsLoaded(products: products));
      }
    } catch (e) {
      if (!isClosed) {
        print('SpecialOfferProductsCubit: Error loading products: $e');
        emit(SpecialOfferProductsError(message: e.toString()));
      }
    }
  }

  void _refreshData() {
    getSpecialOfferProducts();
  }

  @override
  Future<void> close() {
    dataRefreshService?.unregisterRefreshCallback(_refreshData);
    return super.close();
  }
}

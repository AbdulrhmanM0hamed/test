import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/core/services/data_refresh_service.dart';
import '../../../domain/entities/home_product.dart';
import '../../../domain/entities/pagination_info.dart';
import '../../../domain/usecases/get_best_seller_products_use_case.dart';
import 'best_seller_products_state.dart';

class BestSellerProductsCubit extends Cubit<BestSellerProductsState> {
  final GetBestSellerProductsUseCase getBestSellerProductsUseCase;
  final DataRefreshService? dataRefreshService;
  
  List<HomeProduct> _allProducts = [];
  PaginationInfo? _paginationInfo;
  int _currentPage = 1;
  bool _isLoading = false;

  BestSellerProductsCubit({
    required this.getBestSellerProductsUseCase,
    this.dataRefreshService,
  }) : super(BestSellerProductsInitial()) {
    dataRefreshService?.registerRefreshCallback(_refreshData);
  }

  Future<void> getBestSellerProducts({bool refresh = false}) async {
    if (isClosed || _isLoading) return;
    
    if (refresh) {
      _currentPage = 1;
      _allProducts.clear();
    }
    
    _isLoading = true;
    
    try {
      if (_currentPage == 1) {
        emit(BestSellerProductsLoading());
      } else {
        emit(BestSellerProductsLoadingMore(products: _allProducts));
      }
      
      final response = await getBestSellerProductsUseCase(page: _currentPage);
      _paginationInfo = response.pagination;
      
      if (_currentPage == 1) {
        _allProducts = response.products;
      } else {
        _allProducts.addAll(response.products);
      }
      
      _isLoading = false;
      
      if (!isClosed) {
        emit(BestSellerProductsLoaded(
          products: _allProducts,
          hasMore: _paginationInfo?.hasMore ?? false,
        ));
      }
    } catch (e) {
      _isLoading = false;
      if (!isClosed) {
        emit(BestSellerProductsError(message: e.toString()));
      }
    }
  }

  Future<void> loadMore() async {
    if (_isLoading || (_paginationInfo?.hasMore != true)) return;
    _currentPage++;
    await getBestSellerProducts(refresh: false);
  }

  void _refreshData() {
    getBestSellerProducts(refresh: true);
  }

  @override
  Future<void> close() {
    dataRefreshService?.unregisterRefreshCallback(_refreshData);
    return super.close();
  }
}

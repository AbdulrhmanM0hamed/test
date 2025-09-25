import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/core/services/data_refresh_service.dart';
import '../../../domain/entities/home_product.dart';
import '../../../domain/entities/pagination_info.dart';
import '../../../domain/usecases/get_featured_products_use_case.dart';
import 'featured_products_state.dart';

class FeaturedProductsCubit extends Cubit<FeaturedProductsState> {
  final GetFeaturedProductsUseCase getFeaturedProductsUseCase;
  final DataRefreshService? dataRefreshService;

  List<HomeProduct> _allProducts = [];
  PaginationInfo? _paginationInfo;
  int _currentPage = 1;
  bool _isLoading = false;

  FeaturedProductsCubit({
    required this.getFeaturedProductsUseCase,
    this.dataRefreshService,
  }) : super(FeaturedProductsInitial()) {
    dataRefreshService?.registerRefreshCallback(_refreshData);
  }

  Future<void> getFeaturedProducts({bool refresh = false}) async {
    if (isClosed || _isLoading) return;

    if (refresh) {
      _currentPage = 1;
      _allProducts.clear();
    }

    _isLoading = true;

    try {
      if (_currentPage == 1) {
        emit(FeaturedProductsLoading());
      } else {
        emit(FeaturedProductsLoadingMore(products: _allProducts));
      }

      final response = await getFeaturedProductsUseCase(page: _currentPage);
      _paginationInfo = response.pagination;

      if (_currentPage == 1) {
        _allProducts = response.products;
      } else {
        _allProducts.addAll(response.products);
      }

      _isLoading = false;

      if (!isClosed) {
        emit(FeaturedProductsLoaded(
          products: _allProducts,
          hasMore: _paginationInfo?.hasMore ?? false,
        ));
      }
    } catch (e) {
      _isLoading = false;
      if (!isClosed) {
        emit(FeaturedProductsError(message: e.toString()));
      }
    }
  }

  Future<void> loadMore() async {
    if (_isLoading || (_paginationInfo?.hasMore != true)) return;

    _currentPage++;
    await getFeaturedProducts(refresh: false);
  }

  void _refreshData() {
    getFeaturedProducts(refresh: true);
  }

  @override
  Future<void> close() {
    dataRefreshService?.unregisterRefreshCallback(_refreshData);
    return super.close();
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/core/services/data_refresh_service.dart';
import '../../../domain/entities/home_product.dart';
import '../../../domain/entities/pagination_info.dart';
import '../../../domain/usecases/get_latest_products_use_case.dart';
import 'latest_products_state.dart';

class LatestProductsCubit extends Cubit<LatestProductsState> {
  final GetLatestProductsUseCase getLatestProductsUseCase;
  final DataRefreshService? dataRefreshService;

  List<HomeProduct> _allProducts = [];
  PaginationInfo? _paginationInfo;
  int _currentPage = 1;
  bool _isLoading = false;

  LatestProductsCubit({
    required this.getLatestProductsUseCase,
    this.dataRefreshService,
  }) : super(LatestProductsInitial()) {
    dataRefreshService?.registerRefreshCallback(_refreshData);
  }

  Future<void> getLatestProducts({bool refresh = false}) async {
    if (isClosed || _isLoading) return;

    if (refresh) {
      _currentPage = 1;
      _allProducts.clear();
    }

    _isLoading = true;

    try {
      if (_currentPage == 1) {
        emit(LatestProductsLoading());
      } else {
        emit(LatestProductsLoadingMore(products: _allProducts));
      }

      final response = await getLatestProductsUseCase(page: _currentPage);
      _paginationInfo = response.pagination;

      if (_currentPage == 1) {
        _allProducts = response.products;
      } else {
        _allProducts.addAll(response.products);
      }

      _isLoading = false;

      if (!isClosed) {
        emit(
          LatestProductsLoaded(
            products: _allProducts,
            hasMore: _paginationInfo?.hasMore ?? false,
          ),
        );
      }
    } catch (e) {
      _isLoading = false;
      if (!isClosed) {
        emit(LatestProductsError(message: e.toString()));
      }
    }
  }

  Future<void> loadMore() async {
    if (_isLoading || (_paginationInfo?.hasMore != true)) return;
    _currentPage++;
    await getLatestProducts(refresh: false);
  }

  void _refreshData() {
    getLatestProducts(refresh: true);
  }

  @override
  Future<void> close() {
    dataRefreshService?.unregisterRefreshCallback(_refreshData);
    return super.close();
  }
}

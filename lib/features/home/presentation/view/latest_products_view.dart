import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/core/di/dependency_injection.dart';
import 'package:test/core/utils/animations/custom_progress_indcator.dart';
import 'package:test/core/utils/common/custom_app_bar.dart';
import 'package:test/features/home/domain/entities/home_product.dart';
import 'package:test/features/home/presentation/cubits/latest_products/latest_products_cubit.dart';
import 'package:test/features/home/presentation/cubits/latest_products/latest_products_state.dart';
import 'package:test/features/home/presentation/widgets/home_product_card.dart';
import 'package:test/features/home/presentation/widgets/home_product_card_shimmer.dart';
import 'package:test/features/wishlist/presentation/cubit/wishlist_cubit.dart';
import 'package:test/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:test/core/services/app_state_service.dart';
import 'package:test/l10n/app_localizations.dart';

class LatestProductsView extends StatefulWidget {
  const LatestProductsView({super.key});

  static const String routeName = '/latest-products';

  @override
  State<LatestProductsView> createState() => _LatestProductsViewState();
}

class _LatestProductsViewState extends State<LatestProductsView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    
    // Load data after widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LatestProductsCubit>().getLatestProducts();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final pixels = _scrollController.position.pixels;
    final maxExtent = _scrollController.position.maxScrollExtent;
    
    if (pixels >= maxExtent - 200) {
      print('🎯 LatestProducts: Scroll threshold reached, calling loadMore');
      context.read<LatestProductsCubit>().loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final appStateService = DependencyInjection.getIt<AppStateService>();
    final isLoggedIn =
        appStateService.isLoggedIn() && !appStateService.hasLoggedOut();

    // Try to get existing cubits from parent context (bottom nav bar)
    WishlistCubit? existingWishlistCubit;
    CartCubit? existingCartCubit;

    if (isLoggedIn) {
      try {
        existingWishlistCubit = context.read<WishlistCubit>();
        existingCartCubit = context.read<CartCubit>();
        //  debugPrint('🔗 LatestProductsView: Using existing cubits from parent context');
      } catch (e) {
        //    debugPrint('⚠️ LatestProductsView: No existing cubits found, creating new ones');
      }
    }

    return MultiBlocProvider(
      providers: [
        if (isLoggedIn) ...[
          if (existingWishlistCubit != null)
            BlocProvider.value(value: existingWishlistCubit)
          else
            BlocProvider(
              create: (context) => DependencyInjection.getIt<WishlistCubit>(),
            ),
          if (existingCartCubit != null)
            BlocProvider.value(value: existingCartCubit)
          else
            BlocProvider(
              create: (context) => DependencyInjection.getIt<CartCubit>(),
            ),
        ],
      ],
      child: Scaffold(
        appBar: CustomAppBar(
          title: AppLocalizations.of(context)!.latestProducts,
        ),
        body: BlocBuilder<LatestProductsCubit, LatestProductsState>(
          builder: (context, state) {
            if (state is LatestProductsLoading) {
              return const CustomProgressIndicator();
            }

            if (state is LatestProductsError) {
              return _buildErrorState(context, state.message);
            }

            if (state is LatestProductsLoaded || state is LatestProductsLoadingMore) {
              final products = state is LatestProductsLoaded 
                  ? state.products 
                  : (state as LatestProductsLoadingMore).products;
              final hasMore = state is LatestProductsLoaded ? state.hasMore : true;
              final isLoadingMore = state is LatestProductsLoadingMore;

              if (products.isEmpty && !isLoadingMore) {
                return _buildEmptyState(context);
              }

              return RefreshIndicator(
                onRefresh: () async {
                  context.read<LatestProductsCubit>().getLatestProducts(refresh: true);
                },
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: GridView.builder(
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.65,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                    itemCount: products.length + (isLoadingMore && hasMore ? 2 : 0),
                    itemBuilder: (context, index) {
                      if (index < products.length) {
                        final product = products[index];
                        return HomeProductCard(
                          product: product,
                          onTap: () =>
                              _navigateToProductDetails(context, product),
                        );
                      } else {
                        return const HomeProductCardShimmer();
                      }
                    },
                  ),
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(color: Colors.grey[600], fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.read<LatestProductsCubit>().getLatestProducts();
            },
            child: Text(AppLocalizations.of(context)!.retry),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.new_releases_outlined, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.noLatestAvailable,
            style: TextStyle(color: Colors.grey[600], fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _navigateToProductDetails(BuildContext context, HomeProduct product) {
    Navigator.pushNamed(context, '/product-details', arguments: product.id);
  }
}

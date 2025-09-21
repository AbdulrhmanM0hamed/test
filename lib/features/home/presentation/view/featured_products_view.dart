import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/core/di/dependency_injection.dart';
import 'package:test/core/utils/animations/custom_progress_indcator.dart';
import 'package:test/core/utils/common/custom_app_bar.dart';
import 'package:test/features/home/domain/entities/home_product.dart';
import 'package:test/features/home/presentation/cubits/featured_products/featured_products_cubit.dart';
import 'package:test/features/home/presentation/cubits/featured_products/featured_products_state.dart';
import 'package:test/features/home/presentation/widgets/home_product_card.dart';
import 'package:test/features/wishlist/presentation/cubit/wishlist_cubit.dart';
import 'package:test/l10n/app_localizations.dart';

class FeaturedProductsView extends StatelessWidget {
  const FeaturedProductsView({super.key});

  static const String routeName = '/featured-products';

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              DependencyInjection.getIt<FeaturedProductsCubit>()..getFeaturedProducts(),
        ),
        BlocProvider(
          create: (context) => DependencyInjection.getIt<WishlistCubit>(),
        ),
      ],
      child: Scaffold(
        appBar: CustomAppBar(
          title: AppLocalizations.of(context)!.featuredProducts,
        ),
        body: BlocBuilder<FeaturedProductsCubit, FeaturedProductsState>(
          builder: (context, state) {
            if (state is FeaturedProductsLoading) {
              return const CustomProgressIndicator();
            }

            if (state is FeaturedProductsError) {
              return _buildErrorState(context, state.message);
            }

            if (state is FeaturedProductsLoaded) {
              final products = state.products;

              if (products.isEmpty) {
                return _buildEmptyState(context);
              }

              return RefreshIndicator(
                onRefresh: () async {
                  context.read<FeaturedProductsCubit>().getFeaturedProducts();
                },
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: GridView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.65,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return HomeProductCard(
                        product: product,
                        onTap: () => _navigateToProductDetails(context, product),
                      );
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
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.read<FeaturedProductsCubit>().getFeaturedProducts();
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
          Icon(
            Icons.star_outline,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.noFeaturedAvailable,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _navigateToProductDetails(BuildContext context, HomeProduct product) {
    Navigator.pushNamed(
      context,
      '/product-details',
      arguments: product.id,
    );
  }
}

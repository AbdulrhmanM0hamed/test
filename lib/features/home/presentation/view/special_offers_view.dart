import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/core/di/dependency_injection.dart';
import 'package:test/core/utils/animations/custom_progress_indcator.dart';
import 'package:test/core/utils/common/custom_app_bar.dart';
import 'package:test/features/home/domain/entities/home_product.dart';
import 'package:test/features/home/presentation/cubits/special_offer_products/special_offer_products_cubit.dart';
import 'package:test/features/home/presentation/cubits/special_offer_products/special_offer_products_state.dart';
import 'package:test/features/home/presentation/widgets/home_product_card.dart';
import 'package:test/features/wishlist/presentation/cubit/wishlist_cubit.dart';
import 'package:test/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:test/core/services/app_state_service.dart';
import 'package:test/l10n/app_localizations.dart';

class SpecialOffersView extends StatelessWidget {
  const SpecialOffersView({super.key});

  static const String routeName = '/special-offers';

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
        //debugprint('🔗 SpecialOffersView: Using existing cubits from parent context');
      } catch (e) {
        //debugprint('⚠️ SpecialOffersView: No existing cubits found, creating new ones');
      }
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              DependencyInjection.getIt<SpecialOfferProductsCubit>()
                ..getSpecialOfferProducts(),
        ),
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
          title: AppLocalizations.of(context)!.specialOffers,
        ),
        body: BlocBuilder<SpecialOfferProductsCubit, SpecialOfferProductsState>(
          builder: (context, state) {
            if (state is SpecialOfferProductsLoading) {
              return const CustomProgressIndicator();
            }

            if (state is SpecialOfferProductsError) {
              return _buildErrorState(context, state.message);
            }

            if (state is SpecialOfferProductsLoaded) {
              final products = state.products;

              if (products.isEmpty) {
                return _buildEmptyState(context);
              }

              return RefreshIndicator(
                onRefresh: () async {
                  context
                      .read<SpecialOfferProductsCubit>()
                      .getSpecialOfferProducts();
                },
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: GridView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
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
                        onTap: () =>
                            _navigateToProductDetails(context, product),
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
              context
                  .read<SpecialOfferProductsCubit>()
                  .getSpecialOfferProducts();
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
          Icon(Icons.local_offer_outlined, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.noSpecialOffersAvailable,
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

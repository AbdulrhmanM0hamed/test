import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/features/home/presentation/widgets/section_header.dart';
import '../../../../../core/utils/constant/font_manger.dart';
import '../../../../../core/utils/constant/styles_manger.dart';
import 'package:test/l10n/app_localizations.dart';
import '../../../../../core/utils/animations/custom_progress_indcator.dart';
import '../../../domain/entities/home_product.dart';
import '../../cubits/best_seller_products/best_seller_products_cubit.dart';
import '../../cubits/best_seller_products/best_seller_products_state.dart';
import '../home_product_card.dart';

class BestSellerProductsSection extends StatelessWidget {
  final Function(HomeProduct)? onProductTap;
  final Function(HomeProduct)? onFavoritePressed;
  final VoidCallback? onSeeAll;

  const BestSellerProductsSection({
    super.key,
    this.onProductTap,
    this.onFavoritePressed,
    this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // best_seller_products_section.dart
        SectionHeader(
          onSeeAll: onSeeAll,
          title: AppLocalizations.of(context)!.bestSellers,
          icon: Icons.trending_up,
          iconColor: Colors.green,
          backgroundColor: Colors.green.withValues(alpha: 0.1),
        ),
        const SizedBox(height: 16),
        _buildProductsGrid(),
      ],
    );
  }

  Widget _buildProductsGrid() {
    return BlocBuilder<BestSellerProductsCubit, BestSellerProductsState>(
      builder: (context, state) {
        if (state is BestSellerProductsLoading) {
          return _buildLoadingGrid();
        }

        if (state is BestSellerProductsError) {
          return _buildErrorState(context, state.message);
        }

        if (state is BestSellerProductsLoaded) {
          final products = state.products;

          if (products.isEmpty) {
            return _buildEmptyState(context);
          }

          // Check if any product has a special offer to determine height
          final hasSpecialOffer = products.any(
            (product) => product.isSpecialOffer,
          );

          return SizedBox(
            height: hasSpecialOffer ? 290 : 270,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: products.length > 4 ? 4 : products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Container(
                  width: 170,
                  margin: EdgeInsetsDirectional.only(
                    end:
                        index == (products.length > 4 ? 3 : products.length - 1)
                        ? 0
                        : 12,
                  ),
                  child: HomeProductCard(
                    product: product,
                    onTap: () => onProductTap?.call(product),
                  ),
                );
              },
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildLoadingGrid() {
    return SizedBox(
      height: 270,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: 4,
        itemBuilder: (context, index) {
          return Container(
            width: 170,
            margin: EdgeInsets.only(left: index == 3 ? 0 : 12),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(child: CustomProgressIndicator()),
          );
        },
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Container(
      height: 200,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.red[400]),
            const SizedBox(height: 12),
            Text(
              AppLocalizations.of(context)!.errorLoadingBestSellers,
              style: getMediumStyle(
                fontSize: FontSize.size14,
                fontFamily: FontConstant.cairo,
                color: Colors.red[700],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      height: 200,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.trending_up_outlined, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 12),
            Text(
              AppLocalizations.of(context)!.noBestSellersAvailable,
              style: getMediumStyle(
                fontSize: FontSize.size14,
                fontFamily: FontConstant.cairo,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

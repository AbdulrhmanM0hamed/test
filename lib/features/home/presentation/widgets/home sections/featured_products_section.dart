import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/utils/constant/font_manger.dart';
import '../../../../../core/utils/constant/styles_manger.dart';
import '../../../../../core/utils/theme/app_colors.dart';
import '../../../../../generated/l10n.dart';
import '../../../../../core/utils/animations/custom_progress_indcator.dart';
import '../../../domain/entities/home_product.dart';
import '../../cubits/featured_products/featured_products_cubit.dart';
import '../../cubits/featured_products/featured_products_state.dart';
import '../home_product_card.dart';

class FeaturedProductsSection extends StatelessWidget {
  final Function(HomeProduct)? onProductTap;
  final Function(HomeProduct)? onFavoritePressed;
  final VoidCallback? onSeeAll;

  const FeaturedProductsSection({
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
        _buildSectionHeader(context),
        const SizedBox(height: 16),
        _buildProductsGrid(),
      ],
    );
  }

  Widget _buildSectionHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.star, color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                S.of(context).featuredProducts,
                style: getBoldStyle(
                  fontSize: FontSize.size18,
                  fontFamily: FontConstant.cairo,
                  color: Theme.of(context).textTheme.headlineMedium?.color,
                ),
              ),
            ],
          ),
          if (onSeeAll != null)
            GestureDetector(
              onTap: onSeeAll,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      S.of(context).showMore,
                      style: getSemiBoldStyle(
                        fontSize: FontSize.size12,
                        fontFamily: FontConstant.cairo,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: AppColors.primary,
                      size: 12,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProductsGrid() {
    return BlocBuilder<FeaturedProductsCubit, FeaturedProductsState>(
      builder: (context, state) {
        if (state is FeaturedProductsLoading) {
          return _buildLoadingGrid();
        }

        if (state is FeaturedProductsError) {
          return _buildErrorState(state.message);
        }

        if (state is FeaturedProductsLoaded) {
          final products = state.products;

          if (products.isEmpty) {
            return _buildEmptyState();
          }

          return Container(
            height: 270,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: products.length > 4 ? 4 : products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Container(
                  width: 170,
                  margin: EdgeInsets.only(
                    left:
                        index == (products.length > 4 ? 3 : products.length - 1)
                        ? 0
                        : 12,
                  ),
                  child: HomeProductCard(
                    product: product,
                    onTap: () => onProductTap?.call(product),
                    onFavoritePressed: () => onFavoritePressed?.call(product),
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
    return Container(
      height: 280,
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

  Widget _buildErrorState(String message) {
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
              S.current.errorLoadingFeatured,
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

  Widget _buildEmptyState() {
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
            Icon(Icons.star_outline, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 12),
            Text(
              S.current.noFeaturedAvailable,
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

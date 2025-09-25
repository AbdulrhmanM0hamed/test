import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/features/home/presentation/widgets/section_header.dart';
import '../../../../../core/utils/constant/font_manger.dart';
import '../../../../../core/utils/constant/styles_manger.dart';
import 'package:test/l10n/app_localizations.dart';
import '../../../domain/entities/home_product.dart';
import '../../cubits/featured_products/featured_products_cubit.dart';
import '../../cubits/featured_products/featured_products_state.dart';
import '../featured_product_card_compact.dart';
import '../featured_product_card_compact_shimmer.dart';

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
        // featured_products_section.dart
        SectionHeader(
          onSeeAll: onSeeAll,
          title: AppLocalizations.of(context)!.featuredProducts,
          icon: Icons.star,
          iconColor: Colors.orange,
          backgroundColor: Colors.orange.withValues(alpha: 0.1),
        ),
        const SizedBox(height: 16),
        _buildProductsGrid(),
      ],
    );
  }

  Widget _buildProductsGrid() {
    return BlocBuilder<FeaturedProductsCubit, FeaturedProductsState>(
      builder: (context, state) {
        if (state is FeaturedProductsLoading) {
          return _buildLoadingGrid();
        }

        if (state is FeaturedProductsError) {
          return _buildErrorState(context, state.message);
        }

        if (state is FeaturedProductsLoaded) {
          final products = state.products;

          if (products.isEmpty) {
            return _buildEmptyState(context);
          }

          final double rowHeight = 100.0; // ارتفاع كل صف
          final double spacingBetweenRows = 16.0; // المسافة بين الصفوف

          // حساب الارتفاع الإجمالي (3 صفوف + 2 مسافات بينها + هامش أمان)
          final double totalHeight = (rowHeight * 3) + (spacingBetweenRows * 2) + 10;
          final double screenWidth = MediaQuery.of(context).size.width;
          // تقليل الهامش بين الكروت لتوفير مساحة أكبر
          final double cardWidth = (screenWidth - 20) / 2; // عرض البطاقة أكبر بتقليل الهوامش

          return SizedBox(
            height: totalHeight,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.zero, // تقليل الهوامش الجانبية
                itemCount: (products.length / 6).ceil(),
                itemBuilder: (context, pageIndex) {
                  return _buildProductsPage(
                    context,
                    pageIndex,
                    products,
                    cardWidth,
                    rowHeight,
                    spacingBetweenRows,
                  );
                },
              ),
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  // بناء صفحة كاملة من المنتجات (3 صفوف)
  Widget _buildProductsPage(
    BuildContext context,
    int pageIndex,
    List<HomeProduct> products,
    double cardWidth,
    double rowHeight,
    double spacingBetweenRows,
  ) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 4, // تقليل الهوامش
      child: Column(
        children: [
          // الصف الأول
          SizedBox(
            height: rowHeight,
            child: _buildProductRow(context, pageIndex * 6, products, cardWidth),
          ),
          SizedBox(height: spacingBetweenRows),
          // الصف الثاني
          SizedBox(
            height: rowHeight,
            child: _buildProductRow(
              context,
              pageIndex * 6 + 2,
              products,
              cardWidth,
            ),
          ),
          SizedBox(height: spacingBetweenRows),
          // الصف الثالث
          SizedBox(
            height: rowHeight,
            child: _buildProductRow(
              context,
              pageIndex * 6 + 4,
              products,
              cardWidth,
            ),
          ),
        ],
      ),
    );
  }

  // بناء صف من المنتجات (كل صف يحتوي على كارتين)
  Widget _buildProductRow(
    BuildContext context,
    int startIndex,
    List<HomeProduct> products,
    double cardWidth,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // الكارت الأول
        if (startIndex < products.length)
          FeaturedProductCardCompact(
            product: products[startIndex],
            width: cardWidth,
            onTap: () => onProductTap?.call(products[startIndex]),
          ),
        const SizedBox(width: 8), // تقليل المسافة بين البطاقات
        // الكارت الثاني
        if (startIndex + 1 < products.length)
          FeaturedProductCardCompact(
            product: products[startIndex + 1],
            width: cardWidth,
            onTap: () => onProductTap?.call(products[startIndex + 1]),
          ),
      ],
    );
  }

  Widget _buildLoadingGrid() {
    final double rowHeight = 100.0;
    final double spacingBetweenRows = 16.0;
    final double totalHeight = (rowHeight * 3) + (spacingBetweenRows * 2) + 10;
    
    return SizedBox(
      height: totalHeight,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            // الصف الأول
            SizedBox(
              height: rowHeight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: const FeaturedProductCardCompactShimmer()),
                  const SizedBox(width: 8),
                  Expanded(child: const FeaturedProductCardCompactShimmer()),
                ],
              ),
            ),
            SizedBox(height: spacingBetweenRows),
            // الصف الثاني
            SizedBox(
              height: rowHeight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: const FeaturedProductCardCompactShimmer()),
                  const SizedBox(width: 8),
                  Expanded(child: const FeaturedProductCardCompactShimmer()),
                ],
              ),
            ),
            SizedBox(height: spacingBetweenRows),
            // الصف الثالث
            SizedBox(
              height: rowHeight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: const FeaturedProductCardCompactShimmer()),
                  const SizedBox(width: 8),
                  Expanded(child: const FeaturedProductCardCompactShimmer()),
                ],
              ),
            ),
          ],
        ),
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
              AppLocalizations.of(context)!.errorLoadingFeatured,
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
            Icon(Icons.star_outline, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 12),
            Text(
              AppLocalizations.of(context)!.noFeaturedAvailable,
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

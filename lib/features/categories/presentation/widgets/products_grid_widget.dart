import 'package:flutter/material.dart';
import 'package:test/core/utils/animations/custom_animations.dart';
import 'package:test/core/utils/constant/font_manger.dart';
import 'package:test/core/utils/constant/styles_manger.dart';
import 'package:test/features/categories/domain/entities/product.dart';
import 'package:test/features/categories/presentation/widgets/product_card_professional.dart';
import 'package:test/features/home/presentation/widgets/home_product_card_shimmer.dart';
import 'package:test/l10n/app_localizations.dart';

/// ويدجت عرض شبكة المنتجات
class ProductsGridWidget extends StatelessWidget {
  final List<Product> products;
  final Function(Product) onProductTap;
  final bool isLoadingMore;
  final ScrollController? scrollController;

  const ProductsGridWidget({
    super.key,
    required this.products,
    required this.onProductTap,
    this.isLoadingMore = false,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    //print('🔍 ProductsGridWidget: Building with ${products.length} products');
    return CustomAnimations.fadeIn(
      child: products.isEmpty ? _buildEmptyState() : _buildProductsGrid(),
    );
  }

  /// بناء حالة عدم وجود منتجات
  Widget _buildEmptyState() {
    return Builder(
      builder: (context) {
        return Center(
          child: Text(
            AppLocalizations.of(context)!.noProductsInCategory,
            style: getMediumStyle(
              fontSize: FontSize.size16,
              fontFamily: FontConstant.cairo,
              color: Colors.grey,
            ),
          ),
        );
      },
    );
  }

  /// بناء شبكة المنتجات
  Widget _buildProductsGrid() {
    return Builder(
      builder: (context) {
        final textDirection = Directionality.of(context);
        final itemCount = products.length + (isLoadingMore ? 2 : 0);

        return GridView.builder(
          controller: scrollController,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.66,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: itemCount,
          itemBuilder: (context, index) {
            if (index >= products.length) {
              // Show shimmer loading for additional items
              return const HomeProductCardShimmer();
            }
            
            return Directionality(
              textDirection: textDirection,
              child: ProductCardProfessional(
                product: products[index],
                onTap: () => onProductTap(products[index]),
              ),
            );
          },
        );
      },
    );
  }
}

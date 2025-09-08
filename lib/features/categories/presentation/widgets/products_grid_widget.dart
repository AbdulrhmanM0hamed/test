import 'package:flutter/material.dart';
import 'package:test/core/utils/animations/custom_animations.dart';
import 'package:test/core/utils/constant/font_manger.dart';
import 'package:test/core/utils/constant/styles_manger.dart';
import 'package:test/features/home/presentation/widgets/for_you/models/product.dart';
import 'package:test/features/home/presentation/widgets/product_card.dart';

/// ويدجت عرض شبكة المنتجات
class ProductsGridWidget extends StatelessWidget {
  final List<Product> products;
  final Function(Product) onProductTap;

  const ProductsGridWidget({
    super.key,
    required this.products,
    required this.onProductTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: CustomAnimations.fadeIn(
        child: products.isEmpty ? _buildEmptyState() : _buildProductsGrid(),
      ),
    );
  }

  /// بناء حالة عدم وجود منتجات
  Widget _buildEmptyState() {
    return Center(
      child: Text(
        'لا توجد منتجات في هذه الفئة',
        style: getMediumStyle(
          fontSize: FontSize.size16,
          fontFamily: FontConstant.cairo,
          color: Colors.grey,
        ),
      ),
    );
  }

  /// بناء شبكة المنتجات
  Widget _buildProductsGrid() {
    return Builder(
      builder: (context) {
        final textDirection = Directionality.of(context);

        return GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.85,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            return Directionality(
              textDirection: textDirection,
              child: ProductCard(
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

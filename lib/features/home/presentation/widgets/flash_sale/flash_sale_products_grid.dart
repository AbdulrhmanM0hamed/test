import 'package:flutter/material.dart';
import 'package:test/features/home/presentation/widgets/flash_sale/flash_sale_product_model.dart';
import 'package:test/features/home/presentation/widgets/flash_sale/flash_sale_product_card.dart';

/// شبكة منتجات الفلاش سيل
class FlashSaleProductsGrid extends StatelessWidget {
  final List<FlashSaleProduct> products;
  final AnimationController animationController;

  const FlashSaleProductsGrid({
    super.key,
    required this.products,
    required this.animationController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.8,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          return _buildAnimatedProductCard(index);
        },
      ),
    );
  }

  /// إنشاء بطاقة منتج مع تأثيرات حركية
  Widget _buildAnimatedProductCard(int index) {
    // تأخير عرض المنتجات لإنشاء تأثير متتالي
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        final double t = (index * 0.1).clamp(0.0, 1.0);
        final double scale =
            0.9 + ((animationController.value - t) * 0.1).clamp(0.0, 0.1);
        final double opacity = ((animationController.value - t) * 2.0).clamp(
          0.0,
          1.0,
        );

        return Opacity(
          opacity: opacity,
          child: Transform.scale(scale: scale, child: child),
        );
      },
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: FlashSaleProductCard(product: products[index]),
      ),
    );
  }
}

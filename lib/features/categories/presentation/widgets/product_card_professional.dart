import 'package:flutter/material.dart';
import 'package:test/core/utils/animations/custom_progress_indcator.dart';
import 'package:test/core/utils/constant/font_manger.dart';
import 'package:test/core/utils/constant/styles_manger.dart';
import 'package:test/core/utils/theme/app_colors.dart';
import 'package:test/features/categories/domain/entities/product.dart';

class ProductCardProfessional extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;
  final VoidCallback? onFavoriteToggle;

  const ProductCardProfessional({
    super.key,
    required this.product,
    required this.onTap,
    this.onFavoriteToggle,
  });

  /// تقليم اسم المنتج لتجنب overflow
  String _truncateProductName(String name) {
    const int maxWords = 3;
    final words = name.split(' ');
    if (words.length <= maxWords) {
      return name;
    }
    return '${words.take(maxWords).join(' ')}...';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 12,
              spreadRadius: 0,
              offset: const Offset(0, 4),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 6,
              spreadRadius: 0,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // صورة المنتج مع العناصر العلوية
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  // الصورة الرئيسية
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                      child: Image.network(
                        product.image,
                        fit: BoxFit.contain,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            color: Colors.grey.withValues(alpha: 0.1),
                            child: const CustomProgressIndicator(size: 30),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey.withValues(alpha: 0.1),
                            child: const Center(
                              child: Icon(
                                Icons.image_not_supported,
                                size: 40,
                                color: Colors.grey,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  // شارة الخصم
                  if (product.hasDiscount)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(
                          '-${product.discountPercentage.toStringAsFixed(0)}%',
                          style: getBoldStyle(
                            fontSize: FontSize.size12,
                            fontFamily: FontConstant.cairo,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                  // أيقونة المفضلة
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: onFavoriteToggle,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.9),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          product.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          size: 18,
                          color: product.isFavorite
                              ? Colors.red
                              : Colors.grey[600],
                        ),
                      ),
                    ),
                  ),

                  // شارة "الأفضل"
                  if (product.isBest)
                    Positioned(
                      bottom: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'الأفضل',
                          style: getBoldStyle(
                            fontSize: FontSize.size9,
                            fontFamily: FontConstant.cairo,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // معلومات المنتج
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // البراند مع اللوجو
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(3),
                          child: Image.network(
                            product.brandLogo,
                            width: 14,
                            height: 14,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 14,
                                height: 14,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(3),
                                ),
                                child: const Icon(
                                  Icons.store,
                                  size: 8,
                                  color: Colors.grey,
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(
                            product.brandName,
                            style: getSemiBoldStyle(
                              fontSize: FontSize.size10,
                              fontFamily: FontConstant.cairo,
                              color: Colors.grey[600]!,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),

                    // اسم المنتج
                    Text(
                      _truncateProductName(product.name),
                      style: getSemiBoldStyle(
                        fontSize: FontSize.size13,
                        fontFamily: FontConstant.cairo,
                        color: Colors.black,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),

                    // التقييم (مبسط)
                    if (product.rating >= 0)
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            size: 10,
                            color: AppColors.starActive,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            '${product.rating.toStringAsFixed(1)} (${product.reviewsCount})',
                            style: getRegularStyle(
                              fontSize: FontSize.size12,
                              fontFamily: FontConstant.cairo,
                              color: Colors.grey[600]!,
                            ),
                          ),
                        ],
                      ),

                    const Spacer(),

                    // السعر
                    if (product.hasDiscount) ...[
                      Row(
                        children: [
                          Text(
                            '${product.finalPrice.toStringAsFixed(0)} ${product.currency}',
                            style: getBoldStyle(
                              fontSize: FontSize.size13,
                              fontFamily: FontConstant.cairo,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            product.originalPrice.toStringAsFixed(0),
                            style: getMediumStyle(
                              fontSize: FontSize.size12,
                              fontFamily: FontConstant.cairo,
                              color: Colors.grey,
                            ).copyWith(decoration: TextDecoration.lineThrough),
                          ),
                        ],
                      ),
                    ] else ...[
                      Text(
                        '${product.finalPrice.toStringAsFixed(0)} ${product.currency}',
                        style: getBoldStyle(
                          fontSize: FontSize.size13,
                          fontFamily: FontConstant.cairo,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                    const SizedBox(height: 2),

                    // حالة التوفر والمخزون
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: 5,
                          height: 5,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: product.isAvailable
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                        const SizedBox(width: 3),
                        Text(
                          product.isAvailable
                              ? 'متوفر (${product.stock})'
                              : 'غير متوفر',
                          style: getSemiBoldStyle(
                            fontSize: FontSize.size11,
                            fontFamily: FontConstant.cairo,
                            color: product.isAvailable
                                ? Colors.green
                                : Colors.red,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

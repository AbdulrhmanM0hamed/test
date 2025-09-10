import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:test/core/utils/constant/font_manger.dart';
import 'package:test/core/utils/constant/styles_manger.dart';
import 'package:test/core/utils/theme/app_colors.dart';
import 'package:test/features/product_details/domain/entities/product_details.dart';
import 'package:test/l10n/app_localizations.dart';
import 'add_to_cart_section.dart';

class ProductInfoSection extends StatelessWidget {
  final ProductDetails product;

  const ProductInfoSection({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Brand info
          if (product.brandName.isNotEmpty) ...[
            Row(
              children: [
                CachedNetworkImage(
                  imageUrl: product.brandLogo,
                  width: 24,
                  height: 24,
                  fit: BoxFit.contain,
                  placeholder: (context, url) => Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Icon(
                      Icons.store,
                      size: 16,
                      color: Colors.grey,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  product.brandName,
                  style: getMediumStyle(
                    fontSize: FontSize.size14,
                    fontFamily: FontConstant.cairo,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
          ],

          // Product name
          Text(
            product.name,
            style: getBoldStyle(
              fontSize: FontSize.size20,
              fontFamily: FontConstant.cairo,
              color: Colors.black,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 16),

          // Rating and reviews
          Row(
            children: [
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    index < product.star.floor()
                        ? Icons.star
                        : Icons.star_border,
                    color: AppColors.starActive,
                    size: 20,
                  );
                }),
              ),
              const SizedBox(width: 8),
              Text(
                '${product.star}',
                style: getSemiBoldStyle(
                  fontSize: FontSize.size14,
                  fontFamily: FontConstant.cairo,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '(${product.numOfUserReview} تقييم)',
                style: getMediumStyle(
                  fontSize: FontSize.size12,
                  fontFamily: FontConstant.cairo,
                  color: Colors.grey[600],
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  product.status,
                  style: getSemiBoldStyle(
                    fontSize: FontSize.size12,
                    fontFamily: FontConstant.cairo,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Price section
          _buildPriceSection(context),

          const SizedBox(height: 20),

          // Stock and sales info
          Row(
            children: [
              _buildInfoChip(
                icon: Icons.inventory_2_outlined,
                label: AppLocalizations.of(context)!.stock,
                value: '${product.stock}',
                color: product.stock > 0 ? Colors.green : Colors.red,
              ),
              const SizedBox(width: 12),
              _buildInfoChip(
                icon: Icons.shopping_cart_outlined,
                label: AppLocalizations.of(context)!.salesCount,
                value: '${product.numberOfSale}',
                color: AppColors.primary,
              ),
              const SizedBox(width: 12),
              _buildInfoChip(
                icon: Icons.visibility_outlined,
                label: AppLocalizations.of(context)!.viewsCount,
                value: '${product.views}',
                color: Colors.orange,
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Color/Size selection
          if (product.productSizeColor.isNotEmpty) ...[
            _buildVariantsSection(context),
            const SizedBox(height: 24),
          ],

          // Add to cart section
          AddToCartSection(product: product),
        ],
      ),
    );
  }

  Widget _buildPriceSection(BuildContext context) {
    final mainVariant = product.productSizeColor.isNotEmpty
        ? product.productSizeColor.first
        : null;

    if (mainVariant == null) return const SizedBox.shrink();

    final hasDiscount =
        mainVariant.fakePrice != null && mainVariant.fakePrice!.isNotEmpty;

    return Row(
      children: [
        Text(
          '${double.tryParse(mainVariant.realPrice.replaceAll(',', ''))?.toStringAsFixed(0) ?? mainVariant.realPrice} ${AppLocalizations.of(context)!.egp}',
          style: getBoldStyle(
            fontSize: FontSize.size24,
            fontFamily: FontConstant.cairo,
            color: AppColors.primary,
          ),
        ),
        if (hasDiscount) ...[
          const SizedBox(width: 12),
          Text(
            '${double.tryParse(mainVariant.fakePrice!.replaceAll(',', ''))?.toStringAsFixed(0) ?? mainVariant.fakePrice} ${AppLocalizations.of(context)!.egp}',
            style: TextStyle(
              fontSize: FontSize.size16,
              fontFamily: FontConstant.cairo,
              color: Colors.grey[500],
              decoration: TextDecoration.lineThrough,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              '${mainVariant.discount}% ${AppLocalizations.of(context)!.discount}',
              style: getBoldStyle(
                fontSize: FontSize.size12,
                fontFamily: FontConstant.cairo,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 4),
            Text(
              value,
              style: getBoldStyle(
                fontSize: FontSize.size14,
                fontFamily: FontConstant.cairo,
                color: color,
              ),
            ),
            Text(
              label,
              style: getMediumStyle(
                fontSize: FontSize.size10,
                fontFamily: FontConstant.cairo,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVariantsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.colors,
          style: getSemiBoldStyle(
            fontSize: FontSize.size16,
            fontFamily: FontConstant.cairo,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 8,
          children: product.productSizeColor.map((variant) {
            return _buildColorOption(variant);
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildColorOption(ProductSizeColor variant) {
    final isSelected = false; // TODO: Implement selection logic

    return GestureDetector(
      onTap: () {
        // TODO: Handle color selection
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey[300]!,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (variant.colorCode != null) ...[
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: Color(
                    int.parse(variant.colorCode!.replaceFirst('#', '0xFF')),
                  ),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey[300]!, width: 1),
                ),
              ),
              const SizedBox(width: 8),
            ],
            Text(
              variant.color ?? 'غير محدد',
              style: getSemiBoldStyle(
                fontSize: FontSize.size14,
                fontFamily: FontConstant.cairo,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '(${variant.stock})',
              style: getMediumStyle(
                fontSize: FontSize.size12,
                fontFamily: FontConstant.cairo,
                color: isSelected ? Colors.white70 : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

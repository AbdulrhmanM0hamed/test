import 'package:flutter/material.dart';
import 'package:test/core/utils/common/custom_button.dart';
import 'package:test/core/utils/constant/font_manger.dart';
import 'package:test/core/utils/constant/styles_manger.dart';
import 'package:test/core/utils/theme/app_colors.dart';
import 'package:test/l10n/app_localizations.dart';
import '../../domain/entities/product_details.dart';

class AddToCartSection extends StatefulWidget {
  final ProductDetails product;

  const AddToCartSection({super.key, required this.product});

  @override
  State<AddToCartSection> createState() => _AddToCartSectionState();
}

class _AddToCartSectionState extends State<AddToCartSection> {
  int _quantity = 1;
  ProductSizeColor? _selectedVariant;

  @override
  void initState() {
    super.initState();
    if (widget.product.productSizeColor.isNotEmpty) {
      _selectedVariant = widget.product.productSizeColor.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAvailable = widget.product.stock > 0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
       
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!, width: 1),
      ),
      child: Column(
        children: [
          // Quantity selector
          Row(
            children: [
              Text(
                AppLocalizations.of(context)!.quantity,
                style: TextStyle(
                  fontSize: FontSize.size16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const Spacer(),
              _buildQuantitySelector(),
            ],
          ),

          const SizedBox(height: 20),

          // Add to cart button
          CustomButton(
            text: isAvailable
                ? AppLocalizations.of(context)!.addToCart
                : AppLocalizations.of(context)!.outOfStock,
            onPressed: isAvailable ? _addToCart : null,
            backgroundColor: isAvailable ? AppColors.primary : Colors.grey,
            height: 56,
            prefix: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Icon(
                isAvailable ? Icons.shopping_cart_outlined : Icons.block,
                size: 24,
                color: Colors.white,
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Buy now button
          if (isAvailable)
            Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primary, width: 2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: MaterialButton(
                onPressed: _buyNow,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.flash_on_outlined,
                      size: 24,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      AppLocalizations.of(context)!.buyNow,
                      style: getBoldStyle(
                        fontSize: FontSize.size16,
                        fontFamily: FontConstant.cairo,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildQuantitySelector() {
    return Container(
      decoration: BoxDecoration(
       
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildQuantityButton(
            icon: Icons.remove,
            onPressed: _quantity > 1 ? () => setState(() => _quantity--) : null,
          ),
          Container(
            width: 60,
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(
              '$_quantity',
              textAlign: TextAlign.center,
              style: getSemiBoldStyle(
                fontSize: FontSize.size16,
                fontFamily: FontConstant.cairo,
              
              ),
            ),
          ),
          _buildQuantityButton(
            icon: Icons.add,
            onPressed: _quantity < widget.product.limitation
                ? () => setState(() => _quantity++)
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback? onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: onPressed != null
              ? AppColors.primary.withValues(alpha: 0.1)
              : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: onPressed != null ? AppColors.primary : Colors.grey[400],
          size: 20,
        ),
      ),
    );
  }

  void _addToCart() {
    // TODO: Implement add to cart functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${AppLocalizations.of(context)!.addedToCart} $_quantity ${AppLocalizations.of(context)!.toCart}',
          style: getMediumStyle(
            fontSize: FontSize.size14,
            fontFamily: FontConstant.cairo,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _buyNow() {
    // TODO: Implement buy now functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'الانتقال إلى صفحة الدفع...',
          style: getMediumStyle(
            fontSize: FontSize.size14,
            fontFamily: FontConstant.cairo,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/core/utils/common/custom_button.dart';
import 'package:test/core/utils/constant/font_manger.dart';
import 'package:test/core/utils/constant/styles_manger.dart';
import 'package:test/core/utils/theme/app_colors.dart';
import 'package:test/core/utils/widgets/custom_snackbar.dart';
import 'package:test/core/utils/animations/custom_progress_indcator.dart';
import 'package:test/l10n/app_localizations.dart';
import '../../../../core/services/hybrid_cart_service.dart';
import '../../../cart/presentation/cubit/cart_cubit.dart';
import '../../../cart/presentation/cubit/cart_state.dart';
import '../../domain/entities/product_details.dart';
import 'product_variant_selector.dart';

class AddToCartSection extends StatefulWidget {
  final ProductDetails product;

  const AddToCartSection({super.key, required this.product});

  @override
  State<AddToCartSection> createState() => _AddToCartSectionState();
}

class _AddToCartSectionState extends State<AddToCartSection> {
  int _quantity = 1;
  ProductSizeColor? _selectedVariant;
  bool _isAddingToCart = false;
  bool _isBuyingNow = false;

  @override
  void initState() {
    super.initState();
    if (widget.product.productSizeColor.isNotEmpty) {
      _selectedVariant = widget.product.productSizeColor.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAvailable = (_selectedVariant?.countOfAvailable ?? 0) > 0;

    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey[200]!, width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Variant Selector
              if (widget.product.productSizeColor.isNotEmpty) ...[
                ProductVariantSelector(
                  variants: widget.product.productSizeColor,
                  selectedVariant: _selectedVariant,
                  onVariantSelected: (variant) {
                    setState(() {
                      _selectedVariant = variant;
                      // Reset quantity if it exceeds new variant's stock
                      if (_quantity > variant.countOfAvailable) {
                        _quantity = variant.countOfAvailable > 0 ? 1 : 0;
                      }
                    });
                  },
                ),
                const SizedBox(height: 24),
              ],

              // Selected Variant Price Display
              if (_selectedVariant != null) ...[
                _buildSelectedVariantInfo(),
                const SizedBox(height: 20),
              ],

              // Quantity selector
              if (isAvailable) ...[
                Row(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.quantity,
                      style: getBoldStyle(
                        fontSize: FontSize.size16,
                        fontFamily: FontConstant.cairo,
                        color: AppColors.primary,
                      ),
                    ),
                    const Spacer(),
                    _buildQuantitySelector(),
                  ],
                ),
                const SizedBox(height: 20),
              ],

              // Add to cart button
              BlocBuilder<CartCubit, CartState>(
                builder: (context, cartState) {
                  // Check if product is already in cart
                  bool isInCart = false;
                  int currentQuantity = 0;
                  if (cartState is CartLoaded) {
                    final cartItem = cartState.cart.getItemByProductId(
                      widget.product.id,
                    );
                    isInCart = cartItem != null;
                    currentQuantity = cartItem?.quantity ?? 0;
                  }

                  return CustomButton(
                    text: isAvailable
                        ? (isInCart
                              ? '${AppLocalizations.of(context)!.addToCart} ($currentQuantity)'
                              : AppLocalizations.of(context)!.addToCart)
                        : AppLocalizations.of(context)!.outOfStock,
                    onPressed:
                        (isAvailable && !_isAddingToCart && !_isBuyingNow)
                        ? _addToCart
                        : null,
                    backgroundColor: isAvailable
                        ? AppColors.primary
                        : Colors.grey,
                    height: 56,
                    prefix: Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Icon(
                        isAvailable
                            ? Icons.shopping_cart_outlined
                            : Icons.block,
                        size: 24,
                        color: Colors.white,
                      ),
                    ),
                  );
                },
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
                    onPressed: (!_isAddingToCart && !_isBuyingNow)
                        ? _buyNow
                        : null,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: _isBuyingNow
                        ? SizedBox(width: 24, height: 24)
                        : Row(
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
        ),

        // Loading overlay with CustomProgressIndicator
        if (_isAddingToCart || _isBuyingNow)
          const Positioned.fill(
            child: Center(child: CustomProgressIndicator(size: 80)),
          ),
      ],
    );
  }

  Widget _buildSelectedVariantInfo() {
    if (_selectedVariant == null) return const SizedBox.shrink();
    
    final hasOffer = _selectedVariant!.fakePrice != null && _selectedVariant!.fakePrice!.isNotEmpty;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'السعر المحدد:',
                  style: getMediumStyle(
                    fontSize: FontSize.size12,
                    fontFamily: FontConstant.cairo,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      '${_selectedVariant!.realPrice} ${AppLocalizations.of(context)!.currency}',
                      style: getBoldStyle(
                        fontSize: FontSize.size18,
                        fontFamily: FontConstant.cairo,
                        color: hasOffer ? AppColors.primary : Colors.black,
                      ),
                    ),
                    if (hasOffer) ...[
                      const SizedBox(width: 8),
                      Text(
                        '${_selectedVariant!.fakePrice} ${AppLocalizations.of(context)!.currency}',
                        style: getMediumStyle(
                          fontSize: FontSize.size14,
                          fontFamily: FontConstant.cairo,
                          color: Colors.grey[500],
                        ).copyWith(
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          if (hasOffer && _selectedVariant!.discount != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'خصم ${_selectedVariant!.discount}%',
                style: getBoldStyle(
                  fontSize: FontSize.size12,
                  fontFamily: FontConstant.cairo,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildQuantitySelector() {
    final maxQuantity = _selectedVariant?.countOfAvailable ?? widget.product.stock;
    final limitation = widget.product.limitation;
    
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
            onPressed: _quantity < maxQuantity &&
                    (limitation == 0 || _quantity < limitation)
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

  Future<void> _addToCart() async {
    if (_isAddingToCart) return;

    setState(() {
      _isAddingToCart = true;
    });

    try {
      // Use the selected variant's ID if available, otherwise use product ID
      final productSizeColorId =
          _selectedVariant?.id ?? widget.product.productSizeColor.first.id;

      await HybridCartService.instance.addToCart(
        product: widget.product,
        productSizeColorId: productSizeColorId,
        quantity: _quantity,
      );

      // if (mounted) {
      //   CustomSnackbar.showSuccess(
      //     context: context,
      //     message: AppLocalizations.of(context)!.productAddedToCart,
      //   );
      // }
    } catch (error) {
      if (mounted) {
        CustomSnackbar.showError(
          context: context,
          message: AppLocalizations.of(context)!.failedToAddToCart,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isAddingToCart = false;
        });
      }
    }
  }

  Future<void> _buyNow() async {
    if (_isBuyingNow || _isAddingToCart) return;

    setState(() {
      _isBuyingNow = true;
    });

    try {
      // Use the selected variant's ID if available, otherwise use product ID
      final productSizeColorId =
          _selectedVariant?.id ?? widget.product.productSizeColor.first.id;

      // Add product to cart first
      await HybridCartService.instance.addToCart(
        product: widget.product,
        productSizeColorId: productSizeColorId,
        quantity: _quantity,
      );

      if (mounted) {
        // Navigate to checkout page
        Navigator.pushNamed(context, '/checkout');
      }
    } catch (error) {
      if (mounted) {
        CustomSnackbar.showError(
          context: context,
          message: AppLocalizations.of(context)!.failedToAddToCart,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isBuyingNow = false;
        });
      }
    }
  }
}

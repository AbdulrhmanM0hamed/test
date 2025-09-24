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

    return Stack(
      children: [
        Container(
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
                    onPressed: (isAvailable && !_isAddingToCart)
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
                    onPressed: () {},
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
        ),

        // Loading overlay with CustomProgressIndicator
        if (_isAddingToCart)
          const Positioned.fill(
            child: Center(child: CustomProgressIndicator(size: 80)),
          ),
      ],
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
            onPressed:
                _quantity < widget.product.stock &&
                    (_quantity < widget.product.limitation ||
                        widget.product.limitation == 0)
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

  // void _buyNow() {
  //   // TODO: Implement buy now functionality - navigate to checkout
  //   _showCustomSnackBar(
  //     message: 'الانتقال إلى صفحة الدفع...',
  //     isSuccess: true,
  //     icon: Icons.flash_on_outlined,
  //   );
  // }
}

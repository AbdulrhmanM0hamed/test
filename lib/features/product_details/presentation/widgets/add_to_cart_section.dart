import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/core/utils/common/custom_button.dart';
import 'package:test/core/utils/constant/font_manger.dart';
import 'package:test/core/utils/constant/styles_manger.dart';
import 'package:test/core/utils/theme/app_colors.dart';
import 'package:test/l10n/app_localizations.dart';
import '../../../../core/services/global_cubit_service.dart';
import '../../../cart/presentation/cubit/cart_cubit.dart';
import '../../../cart/presentation/cubit/cart_state.dart';
import '../../domain/entities/product_details.dart';
import 'cart_floating_button.dart';

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
                text: _isAddingToCart
                    ? AppLocalizations.of(context)!.loading
                    : isAvailable
                    ? (isInCart
                          ? '${AppLocalizations.of(context)!.addToCart} ($currentQuantity)'
                          : AppLocalizations.of(context)!.addToCart)
                    : AppLocalizations.of(context)!.outOfStock,
                onPressed: (isAvailable && !_isAddingToCart)
                    ? _addToCart
                    : null,
                backgroundColor: isAvailable ? AppColors.primary : Colors.grey,
                height: 56,
                prefix: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: _isAddingToCart
                      ? SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : Icon(
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

      await GlobalCubitService.instance.addToCart(
        productId: widget.product.id,
        productSizeColorId: productSizeColorId,
        quantity: _quantity,
      );

      if (mounted) {
        _showCustomSnackBar(
          message: '${AppLocalizations.of(context)!.productAddedToCart}',
          isSuccess: true,
          icon: Icons.check_circle_outline,
        );
      }
    } catch (error) {
      if (mounted) {
        _showCustomSnackBar(
          message: AppLocalizations.of(context)!.failedToAddToCart,
          isSuccess: false,
          icon: Icons.error_outline,
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

  void _buyNow() {
    // TODO: Implement buy now functionality - navigate to checkout
    _showCustomSnackBar(
      message: 'الانتقال إلى صفحة الدفع...',
      isSuccess: true,
      icon: Icons.flash_on_outlined,
    );
  }

  void _showCustomSnackBar({
    required String message,
    required bool isSuccess,
    required IconData icon,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: getSemiBoldStyle(
                  fontSize: FontSize.size14,
                  fontFamily: FontConstant.cairo,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: isSuccess ? Colors.green[600] : Colors.red[600],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: AppLocalizations.of(context)!.cart,
          textColor: Colors.white,
          onPressed: () {
            _showCartBottomSheet(context);
          },
        ),
      ),
    );
  }

  void _showCartBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => MultiBlocProvider(
        providers: [
          BlocProvider.value(
            value: GlobalCubitService.instance.cartCubit!,
          ),
          BlocProvider.value(
            value: GlobalCubitService.instance.wishlistCubit!,
          ),
        ],
        child: const CartBottomSheet(),
      ),
    );
  }
}

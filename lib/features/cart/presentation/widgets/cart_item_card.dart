import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:test/core/utils/animations/custom_progress_indcator.dart';
import 'package:test/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:test/features/cart/presentation/cubit/cart_state.dart';
import 'package:test/l10n/app_localizations.dart';
import '../../../../core/utils/constant/app_assets.dart';
import '../../../../core/utils/constant/font_manger.dart';
import '../../../../core/utils/constant/styles_manger.dart';
import '../../../../core/utils/theme/app_colors.dart';
import '../../domain/entities/cart_item.dart';

class CartItemCard extends StatefulWidget {
  final CartItem cartItem;
  final VoidCallback? onRemove;
  final Function(int)? onQuantityChanged;

  const CartItemCard({
    super.key,
    required this.cartItem,
    this.onRemove,
    this.onQuantityChanged,
  });

  @override
  State<CartItemCard> createState() => _CartItemCardState();
}

class _CartItemCardState extends State<CartItemCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;
  bool _isRemoving = false;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(-1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleRemove() async {
    setState(() => _isRemoving = true);

    await _controller.reverse();
    widget.onRemove?.call();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CartCubit, CartState>(
      listener: (context, state) {
        // Reset updating state if there was an error
        if (state is CartError) {
          setState(() => _isUpdating = false);
        }
      },
      child: SlideTransition(
        position: _slideAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Product Image
                  _buildProductImage(),
                  const SizedBox(width: 16),

                  // Product Details
                  Expanded(child: _buildProductDetails()),

                  // Actions Column
                  _buildActionsColumn(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductImage() {
    return Hero(
      tag: 'cart_product_${widget.cartItem.product.id}',
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: const Color.fromARGB(255, 240, 233, 211),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: CachedNetworkImage(
            imageUrl: widget.cartItem.product.image,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              color: Colors.grey[200],
              child: const Center(child: CustomProgressIndicator()),
            ),
            errorWidget: (context, url, error) => Container(
              color: Colors.grey[200],
              child: Icon(
                Icons.image_not_supported_outlined,
                color: Colors.grey[400],
                size: 32,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Product Name
        Text(
          widget.cartItem.product.name,
          style: getBoldStyle(
            fontSize: FontSize.size14,
            fontFamily: FontConstant.cairo,
            color: Colors.black87,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),

        const SizedBox(height: 4),

        // Size and Color Info

        // Price and Rating
        Row(
          children: [
            Text(
              '${widget.cartItem.product.realPrice} ${AppLocalizations.of(context)?.currency}',
              style: getBoldStyle(
                fontSize: FontSize.size14,
                fontFamily: FontConstant.cairo,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 8),
            if (widget.cartItem.product.star > 0) ...[
              SvgPicture.asset(AppAssets.starIcon, width: 12, height: 12),
              const SizedBox(width: 2),
              Text(
                '${widget.cartItem.product.star}',
                style: getMediumStyle(
                  fontSize: FontSize.size11,
                  fontFamily: FontConstant.cairo,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ],
        ),

        const SizedBox(height: 4),

        // Stock Status
        Text(
          widget.cartItem.availabilityText,
          style: getMediumStyle(
            fontSize: FontSize.size11,
            fontFamily: FontConstant.cairo,
            color: widget.cartItem.isAvailable ? Colors.green : Colors.red,
          ),
        ),
      ],
    );
  }

  // Helper method to build quantity control buttons
  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback? onPressed,
    bool isDisabled = false,
    Color? iconColor,
  }) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: isDisabled
            ? Colors.grey[100]
            : AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isDisabled
              ? Colors.grey[300]!
              : AppColors.primary.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isDisabled ? null : onPressed,
          borderRadius: BorderRadius.circular(6),
          child: Icon(
            icon,
            size: 16,
            color: isDisabled
                ? Colors.grey[400]
                : (iconColor ?? AppColors.primary),
          ),
        ),
      ),
    );
  }

  Widget _buildRemoveButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _isRemoving ? null : _handleRemove,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.red.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.red.withValues(alpha: 0.2)),
          ),
          child: Icon(
            Icons.delete_outline,
            color: _isRemoving ? Colors.grey[400] : Colors.red,
            size: 20,
          ),
        ),
      ),
    );
  }

  // Widget _buildRemoveButton() {
  //   return Material(
  //     color: Colors.transparent,
  //     child: InkWell(
  //       onTap: _isRemoving ? null : _handleRemove,
  //       borderRadius: BorderRadius.circular(8),
  //       child: Container(
  //         padding: const EdgeInsets.all(8),
  //         decoration: BoxDecoration(
  //           color: Colors.red.withValues(alpha:0.05),
  //           borderRadius: BorderRadius.circular(8),
  //           border: Border.all(color: Colors.red.withValues(alpha:0.2)),
  //         ),
  //         child: Icon(
  //           Icons.delete_outline,
  //           color: _isRemoving ? Colors.grey[400] : Colors.red,
  //           size: 20,
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildActionsColumn() {
    // Check if this item is currently being updated
    final cartState = context.watch<CartCubit>().state;
    _isUpdating =
        cartState is CartItemUpdating &&
        cartState.cartItemId == widget.cartItem.id;

    final currentQuantity = widget.cartItem.quantity;
    final maxAllowed = widget.cartItem.product.limitation > 0
        ? (widget.cartItem.product.limitation < widget.cartItem.countOfAvailable
              ? widget.cartItem.product.limitation
              : widget.cartItem.countOfAvailable)
        : widget.cartItem.countOfAvailable;
    final canIncrease =
        currentQuantity < maxAllowed &&
        currentQuantity < widget.cartItem.countOfAvailable;
    final canDecrease = currentQuantity > 1;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Remove Button
        _buildRemoveButton(),
        const SizedBox(height: 16),
        // Quantity Controls
        if (_isUpdating) ...[
          const SizedBox(
            width: 100,
            height: 32,
            child: Center(
              child: SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              ),
            ),
          ),
        ] else ...[
          Container(
            height: 32,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[200]!),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Decrease Button
                _buildQuantityButton(
                  icon: Icons.remove,
                  onPressed: canDecrease
                      ? () =>
                            widget.onQuantityChanged?.call(currentQuantity - 1)
                      : null,
                  isDisabled: !canDecrease,
                ),

                // Quantity Display
                Container(
                  width: 36,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    border: Border.symmetric(
                      vertical: BorderSide(color: Color(0xFFF0F0F0), width: 1),
                    ),
                  ),
                  child: Text(
                    '$currentQuantity',
                    style: getBoldStyle(
                      fontSize: FontSize.size14,
                      fontFamily: FontConstant.cairo,
                      color: Colors.grey[800],
                    ),
                  ),
                ),

                // Increase Button
                _buildQuantityButton(
                  icon: Icons.add,
                  onPressed: canIncrease
                      ? () =>
                            widget.onQuantityChanged?.call(currentQuantity + 1)
                      : null,
                  isDisabled: !canIncrease,
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

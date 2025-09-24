import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:test/core/utils/constant/font_manger.dart';
import 'package:test/core/utils/constant/styles_manger.dart';
import 'package:test/core/utils/theme/app_colors.dart';
import 'package:test/core/utils/animations/custom_progress_indcator.dart';
import 'package:test/l10n/app_localizations.dart';

class OfflineWishlistItemCard extends StatefulWidget {
  final Map<String, dynamic> product;
  final VoidCallback? onRemove;
  final VoidCallback? onAddToCart;

  const OfflineWishlistItemCard({
    super.key,
    required this.product,
    this.onRemove,
    this.onAddToCart,
  });

  @override
  State<OfflineWishlistItemCard> createState() => _OfflineWishlistItemCardState();
}

class _OfflineWishlistItemCardState extends State<OfflineWishlistItemCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

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
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productName = widget.product['name'] as String? ?? 'Unknown Product';
    final productImage = widget.product['image'] as String? ?? '';
    final price = widget.product['originalPrice'] ?? widget.product['price'];
    final isAvailable = (widget.product['countOfAvailable'] as int? ?? 0) > 0;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image with Remove Button
              Expanded(
                flex: 3,
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                      child: Container(
                        width: double.infinity,
                        color: Colors.grey[100],
                        child: productImage.isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: productImage,
                                fit: BoxFit.cover,
                                placeholder: (context, url) =>
                                    const Center(child: CustomProgressIndicator()),
                                errorWidget: (context, url, error) => Icon(
                                  Icons.image_not_supported_outlined,
                                  color: Colors.grey[400],
                                  size: 40,
                                ),
                              )
                            : Icon(
                                Icons.image_not_supported_outlined,
                                color: Colors.grey[400],
                                size: 40,
                              ),
                      ),
                    ),
                    
                    // Remove from Wishlist Button
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: widget.onRemove,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.favorite,
                            color: Colors.red,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                    
                    // Availability Badge
                    if (!isAvailable)
                      Positioned(
                        bottom: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Out of Stock',
                            style: getBoldStyle(
                              fontSize: FontSize.size10,
                              fontFamily: FontConstant.cairo,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              
              // Product Details
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Name
                      Text(
                        productName,
                        style: getSemiBoldStyle(
                          fontSize: FontSize.size14,
                          fontFamily: FontConstant.cairo,
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      
                      const SizedBox(height: 4),
                      
                      // Price
                      Text(
                        '${price.toString()} ${AppLocalizations.of(context)!.currency}',
                        style: getBoldStyle(
                          fontSize: FontSize.size14,
                          fontFamily: FontConstant.cairo,
                          color: AppColors.primary,
                        ),
                      ),
                      
                      const Spacer(),
                      
                      // Add to Cart Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: isAvailable ? widget.onAddToCart : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isAvailable 
                                ? AppColors.primary 
                                : Colors.grey[300],
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.shopping_cart_outlined,
                                size: 16,
                                color: isAvailable ? Colors.white : Colors.grey[600],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                isAvailable ? 'Add to Cart' : 'Unavailable',
                                style: getSemiBoldStyle(
                                  fontSize: FontSize.size12,
                                  fontFamily: FontConstant.cairo,
                                  color: isAvailable ? Colors.white : Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

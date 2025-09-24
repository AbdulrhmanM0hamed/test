import 'package:flutter/material.dart';
import 'package:test/core/utils/animations/custom_progress_indcator.dart';
import 'package:test/core/utils/common/custom_button.dart';
import 'package:test/core/utils/constant/font_manger.dart';
import 'package:test/core/utils/constant/styles_manger.dart';
import 'package:test/core/utils/theme/app_colors.dart';
import 'package:test/core/services/offline_wishlist_service.dart';
import 'package:test/core/services/hybrid_cart_service.dart';
import 'package:test/core/services/hybrid_wishlist_service.dart';
import 'package:test/core/utils/widgets/custom_snackbar.dart';
import 'package:test/features/home/domain/entities/home_product.dart';
import 'package:test/features/wishlist/presentation/widgets/offline_wishlist_item_card.dart';
import 'package:test/l10n/app_localizations.dart';

class OfflineWishlistView extends StatefulWidget {
  const OfflineWishlistView({super.key});

  @override
  State<OfflineWishlistView> createState() => _OfflineWishlistViewState();
}

class _OfflineWishlistViewState extends State<OfflineWishlistView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  List<Map<String, dynamic>> _wishlistItems = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.forward();
    _loadWishlistItems();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadWishlistItems() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final items = await OfflineWishlistService.instance.getWishlistItems();

      setState(() {
        _wishlistItems = items;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      CustomSnackbar.showError(
        context: context,
        message: 'Failed to load wishlist items',
      );
    }
  }

  Future<void> _removeFromWishlist(int productId) async {
    try {
      await OfflineWishlistService.instance.removeFromWishlist(productId);
      await _loadWishlistItems(); // Refresh the wishlist

      // Notify hybrid service to update badges
      HybridWishlistService.instance.notifyListeners();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Item removed from wishlist',
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to remove item from wishlist: ${e.toString()}',
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _addToCart(Map<String, dynamic> product) async {
    try {
      await HybridCartService.instance.addToCart(
        product: product,
        productSizeColorId: 1, // Default size/color for offline
        quantity: 1,
      );

      // Remove the item from wishlist after adding to cart
      await _removeFromWishlist(product['id']);

      // Notify hybrid services to update badges
      HybridCartService.instance.notifyListeners();
      HybridWishlistService.instance.notifyListeners();

      if (mounted) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.productAddedToCart,
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${AppLocalizations.of(context)!.failedToAddToCart}: ${e.toString()}',
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _clearWishlist() async {
    try {
      await OfflineWishlistService.instance.clearWishlist();
      await _loadWishlistItems(); // Refresh the wishlist

      // Notify hybrid service to update badges
      HybridWishlistService.instance.notifyListeners();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Wishlist cleared successfully',
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to clear wishlist: ${e.toString()}',
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.favorite,
          style: getBoldStyle(
            fontSize: FontSize.size20,
            fontFamily: FontConstant.cairo,
            color: Theme.of(context).textTheme.displayLarge?.color,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          if (_wishlistItems.isNotEmpty)
            IconButton(
              onPressed: () => _showClearWishlistDialog(),
              icon: Icon(Icons.delete_outline, color: Colors.red),
            ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: _isLoading
            ? const Center(child: CustomProgressIndicator())
            : _wishlistItems.isEmpty
            ? _buildEmptyWishlist()
            : _buildWishlistContent(),
      ),
    );
  }

  Widget _buildEmptyWishlist() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_outline, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Your wishlist is empty',
            style: getSemiBoldStyle(
              fontSize: FontSize.size18,
              fontFamily: FontConstant.cairo,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add items to your wishlist to see them here',
            style: getMediumStyle(
              fontSize: FontSize.size14,
              fontFamily: FontConstant.cairo,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          CustomButton(
            text: 'Continue Shopping',
            onPressed: () => Navigator.of(context).pop(),
            backgroundColor: AppColors.primary,
            textColor: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _buildWishlistContent() {
    return Column(
      children: [
        // Login prompt for offline users
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.primary.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Login to sync your wishlist across devices',
                  style: getMediumStyle(
                    fontSize: FontSize.size12,
                    fontFamily: FontConstant.cairo,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Wishlist items grid
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: _wishlistItems.length,
            itemBuilder: (context, index) {
              final wishlistItem = _wishlistItems[index];
              return OfflineWishlistItemCard(
                product: wishlistItem,
                onRemove: () => _removeFromWishlist(wishlistItem['id']),
                onAddToCart: () => _addToCart(wishlistItem),
              );
            },
          ),
        ),

        // Bottom action bar
        if (_wishlistItems.isNotEmpty) _buildBottomActionBar(),
      ],
    );
  }

  Widget _buildBottomActionBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: CustomButton(
                text: 'Add All to Cart',
                onPressed: () => _addAllToCart(),
                backgroundColor: AppColors.primary,
                textColor: Colors.white,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CustomButton(
                text: 'Login to Sync',
                onPressed: () => _showLoginPrompt(),
                backgroundColor: Colors.transparent,
                textColor: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addAllToCart() async {
    try {
      for (final item in _wishlistItems) {
        await _addToCart(item);
      }
      CustomSnackbar.showSuccess(
        context: context,
        message: 'All items added to cart',
      );
    } catch (e) {
      CustomSnackbar.showError(
        context: context,
        message: 'Failed to add some items to cart',
      );
    }
  }

  void _showLoginPrompt() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Login Required',
          style: getBoldStyle(
            fontSize: FontSize.size16,
            fontFamily: FontConstant.cairo,
          ),
        ),
        content: Text(
          'Please login to sync your wishlist across devices and access more features.',
          style: getMediumStyle(
            fontSize: FontSize.size14,
            fontFamily: FontConstant.cairo,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: getMediumStyle(
                fontSize: FontSize.size14,
                fontFamily: FontConstant.cairo,
                color: Colors.grey[600],
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Navigate to login screen - you can implement this based on your routing
              // Navigator.pushNamed(context, '/login');
            },
            child: Text(
              'Login',
              style: getBoldStyle(
                fontSize: FontSize.size14,
                fontFamily: FontConstant.cairo,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showClearWishlistDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Clear Wishlist',
          style: getBoldStyle(
            fontSize: FontSize.size16,
            fontFamily: FontConstant.cairo,
          ),
        ),
        content: Text(
          'Are you sure you want to remove all items from your wishlist?',
          style: getMediumStyle(
            fontSize: FontSize.size14,
            fontFamily: FontConstant.cairo,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: getMediumStyle(
                fontSize: FontSize.size14,
                fontFamily: FontConstant.cairo,
                color: Colors.grey[600],
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _clearWishlist();
            },
            child: Text(
              'Clear',
              style: getBoldStyle(
                fontSize: FontSize.size14,
                fontFamily: FontConstant.cairo,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:test/core/utils/animations/custom_progress_indcator.dart';
import 'package:test/core/utils/common/custom_button.dart';
import 'package:test/core/utils/constant/font_manger.dart';
import 'package:test/core/utils/constant/styles_manger.dart';
import 'package:test/core/utils/theme/app_colors.dart';
import 'package:test/core/services/offline_wishlist_service.dart';
import 'package:test/core/services/hybrid_wishlist_service.dart';
import 'package:test/core/utils/widgets/custom_snackbar.dart';
import 'package:test/features/wishlist/presentation/widgets/offline_wishlist_item_card.dart' hide Container;
import 'package:test/l10n/app_localizations.dart';

class OfflineWishlistView extends StatefulWidget {
  const OfflineWishlistView({super.key});

  @override
  State<OfflineWishlistView> createState() => _OfflineWishlistViewState();
}

class _OfflineWishlistViewState extends State<OfflineWishlistView>
    with TickerProviderStateMixin {
  List<Map<String, dynamic>> _wishlistItems = [];
  bool _isLoading = true;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

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

    // Listen to HybridWishlistService changes for automatic UI updates
    HybridWishlistService.instance.addListener(_onWishlistChanged);
  }

  @override
  void dispose() {
    _animationController.dispose();
    HybridWishlistService.instance.removeListener(_onWishlistChanged);
    super.dispose();
  }

  void _onWishlistChanged() {
    // Reload wishlist items when HybridWishlistService notifies changes
    _loadWishlistItems();
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
              icon: Icon(Icons.delete_sweep, color: Colors.red, size: 24),
              onPressed: () => _showClearWishlistDialog(),
              tooltip: AppLocalizations.of(context)!.clearAll,
            ),
          const SizedBox(width: 8),
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
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.favorite_border,
              size: 80,
              color: AppColors.primary.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            AppLocalizations.of(context)!.wishlistEmpty,
            style: getBoldStyle(
              fontSize: FontSize.size20,
              fontFamily: FontConstant.cairo,
              color: Theme.of(context).textTheme.titleLarge?.color,
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              AppLocalizations.of(context)!.wishlistEmptyDescription,
              textAlign: TextAlign.center,
              style: getRegularStyle(
                fontSize: FontSize.size14,
                fontFamily: FontConstant.cairo,
                color: Colors.grey[600],
              ),
            ),
          ),
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 64),
            child: CustomButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              text: AppLocalizations.of(context)!.browseProducts,
              backgroundColor: AppColors.primary,
              height: 56,
              prefix: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Icon(
                  Icons.shopping_bag_outlined,
                  size: 24,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWishlistContent() {
    return RefreshIndicator(
      onRefresh: () async {
        await _loadWishlistItems();
      },
      color: AppColors.primary,
      child: Column(
        children: [
          // Header with count
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withValues(alpha: 0.1),
                  AppColors.primary.withValues(alpha: 0.01),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.favorite, color: AppColors.error, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.addProductsToWishlist,
                        style: getBoldStyle(
                          fontSize: FontSize.size16,
                          fontFamily: FontConstant.cairo,
                          color: AppColors.secondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${_wishlistItems.length} ${AppLocalizations.of(context)!.productsInWishlist}',
                        style: getMediumStyle(
                          fontSize: FontSize.size13,
                          fontFamily: FontConstant.cairo,
                          color: Colors.grey[650],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Wishlist items
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 16),
              itemCount: _wishlistItems.length,
              itemBuilder: (context, index) {
                final wishlistItem = _wishlistItems[index];
                final productData =
                    wishlistItem['product'] as Map<String, dynamic>;
                return OfflineWishlistItemCard(
                  product: productData,
                  onTap: () {
                    // TODO: Navigate to product details
                    //debugprint('Navigate to product: ${productData['id']}');
                  },
                );
              },
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

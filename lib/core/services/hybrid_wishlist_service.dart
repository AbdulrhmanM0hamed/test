import 'package:flutter/foundation.dart';
import 'auth_state_service.dart';
import 'offline_wishlist_service.dart';
import 'global_cubit_service.dart';
import '../../features/home/domain/entities/home_product.dart';

class HybridWishlistService extends ChangeNotifier {
  static HybridWishlistService? _instance;
  
  static HybridWishlistService get instance {
    _instance ??= HybridWishlistService._internal();
    return _instance!;
  }
  
  HybridWishlistService._internal() {
    // Listen to auth state changes
    AuthStateService.instance.addListener(_onAuthStateChanged);
  }

  void _onAuthStateChanged() {
    notifyListeners();
  }

  bool get _isLoggedIn => AuthStateService.instance.isLoggedIn;

  // Add to wishlist - handles both online and offline
  Future<void> addToWishlist(HomeProduct product) async {
    if (_isLoggedIn) {
      // Use server-based wishlist
      await GlobalCubitService.instance.addToWishlist(product.id);
    } else {
      // Use local wishlist
      await OfflineWishlistService.instance.addToWishlist(product);
    }
    notifyListeners();
  }

  // Remove from wishlist
  Future<void> removeFromWishlist(int productId) async {
    if (_isLoggedIn) {
      // Use server-based wishlist
      await GlobalCubitService.instance.removeFromWishlist(productId);
    } else {
      // Use local wishlist
      await OfflineWishlistService.instance.removeFromWishlist(productId);
    }
    notifyListeners();
  }

  // Toggle wishlist
  Future<bool> toggleWishlist(HomeProduct product) async {
    final isInWishlist = await this.isInWishlist(product.id);
    
    if (isInWishlist) {
      await removeFromWishlist(product.id);
      return false;
    } else {
      await addToWishlist(product);
      return true;
    }
  }

  // Toggle wishlist by product ID only (for cases where we don't have full product data)
  Future<bool> toggleWishlistByProductId(int productId) async {
    final isInWishlist = await this.isInWishlist(productId);
    
    if (isInWishlist) {
      await removeFromWishlist(productId);
      return false;
    } else {
      // For offline mode, we need to create a minimal product object
      if (!_isLoggedIn) {
        // Create a minimal HomeProduct for offline storage
        final product = HomeProduct(
          id: productId,
          name: 'Product $productId',
          image: '',
          price: '0',
          originalPrice: '0',
          star: 0,
          reviewCount: 0,
          isFavorite: false,
          isBest: false,
          isFeatured: false,
          isLatest: false,
          isSpecialOffer: false,
          limitation: 0,
          countOfAvailable: 0,
          quantityInCart: 0,
          brandName: '',
          brandLogo: null,
          productSizeColorId: null,
        );
        await addToWishlist(product);
      } else {
        // For online mode, use the GlobalCubitService
        await GlobalCubitService.instance.addToWishlist(productId);
      }
      return true;
    }
  }

  // Check if product is in wishlist
  Future<bool> isInWishlist(int productId) async {
    if (_isLoggedIn) {
      // Check server wishlist - this would need to be implemented in GlobalCubitService
      // For now, we'll use the product's isFavorite property
      return false; // TODO: Implement server-side check
    } else {
      // Check local wishlist
      return await OfflineWishlistService.instance.isInWishlist(productId);
    }
  }

  // Get wishlist item count
  Future<int> getWishlistItemCount() async {
    if (_isLoggedIn) {
      // Get from server wishlist
      return 0; // TODO: Implement server-side count
    } else {
      // Get from local wishlist
      return await OfflineWishlistService.instance.getWishlistItemCount();
    }
  }

  // Clear wishlist
  Future<void> clearWishlist() async {
    if (_isLoggedIn) {
      // Clear server wishlist - TODO: Implement in GlobalCubitService
    } else {
      // Clear local wishlist
      await OfflineWishlistService.instance.clearWishlist();
    }
    notifyListeners();
  }

  @override
  void dispose() {
    AuthStateService.instance.removeListener(_onAuthStateChanged);
    super.dispose();
  }
}

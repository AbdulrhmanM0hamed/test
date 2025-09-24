import 'package:flutter/material.dart';
import 'package:test/features/home/domain/entities/home_product.dart';
import 'package:test/features/categories/domain/entities/product.dart';
import 'package:test/core/services/offline_wishlist_service.dart';
import 'package:test/core/services/global_cubit_service.dart';
import 'package:test/features/wishlist/presentation/cubit/wishlist_cubit.dart';

class HybridWishlistService extends ChangeNotifier {
  static HybridWishlistService? _instance;

  static HybridWishlistService get instance {
    _instance ??= HybridWishlistService._internal();
    return _instance!;
  }

  late bool _isLoggedIn;

  HybridWishlistService._internal() {
    _isLoggedIn = false; // Default to offline mode
    notifyListeners();
  }

  // Update login state from external sources
  void updateLoginState(bool isLoggedIn) {
    if (_isLoggedIn != isLoggedIn) {
      _isLoggedIn = isLoggedIn;
      notifyListeners();
    }
  }

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

  // Toggle wishlist for Product entity (from categories)
  Future<bool> toggleWishlistForProduct(Product product) async {
    final isInWishlist = await this.isInWishlist(product.id);

    if (isInWishlist) {
      await removeFromWishlist(product.id);
      return false;
    } else {
      // Convert Product to HomeProduct for consistent storage
      final homeProduct = HomeProduct(
        id: product.id,
        name: product.name,
        image: product.image,
        price: product.realPrice.toString(),
        originalPrice:
            product.fakePrice?.toString() ?? product.realPrice.toString(),
        star: product.star.round().toDouble(),
        reviewCount: product.numOfUserReview,
        isFavorite: product.isFav,
        isBest: product.isBest,
        isFeatured: false,
        isLatest: false,
        isSpecialOffer: product.discount > 0,
        limitation: product.limitation,
        countOfAvailable: product.countOfAvailable,
        quantityInCart: product.quantityInCart ?? 0,
        brandName: product.brandName,
        brandLogo: product.brandLogo,
        productSizeColorId: product.productSizeColorId,
      );

      if (!_isLoggedIn) {
        await addToWishlist(homeProduct);
      } else {
        await GlobalCubitService.instance.addToWishlist(product.id);
      }
      return true;
    }
  }

  // Check if product is in wishlist
  Future<bool> isInWishlist(int productId) async {
    if (_isLoggedIn) {
      // Check server wishlist using WishlistCubit
      final wishlistCubit = GlobalCubitService.instance.wishlistCubit;
      if (wishlistCubit != null && wishlistCubit.state is WishlistLoaded) {
        final wishlistState = wishlistCubit.state as WishlistLoaded;
        return wishlistState.wishlistResponse.wishlist.any(
          (item) => item.product.id == productId,
        );
      }
      return false;
    } else {
      // Check local wishlist
      return await OfflineWishlistService.instance.isInWishlist(productId);
    }
  }

  // Get wishlist item count
  Future<int> getWishlistItemCount() async {
    if (_isLoggedIn) {
      // Get from server wishlist
      final wishlistCubit = GlobalCubitService.instance.wishlistCubit;
      if (wishlistCubit != null && wishlistCubit.state is WishlistLoaded) {
        final wishlistState = wishlistCubit.state as WishlistLoaded;
        return wishlistState.wishlistResponse.count;
      }
      return 0;
    } else {
      // Get from local wishlist
      return await OfflineWishlistService.instance.getWishlistItemCount();
    }
  }

  // Clear wishlist
  Future<void> clearWishlist() async {
    if (_isLoggedIn) {
      // Clear server wishlist
      final wishlistCubit = GlobalCubitService.instance.wishlistCubit;
      if (wishlistCubit != null) {
        await wishlistCubit.removeAllFromWishlist();
      }
    } else {
      // Clear local wishlist
      await OfflineWishlistService.instance.clearWishlist();
    }
    notifyListeners();
  }

  @override
  void dispose() {
    // Clean up resources
    super.dispose();
  }
}

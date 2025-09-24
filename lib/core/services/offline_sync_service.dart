import 'package:flutter/foundation.dart';
import 'offline_cart_service.dart';
import 'offline_wishlist_service.dart';
import 'global_cubit_service.dart';
import 'hybrid_cart_service.dart';
import 'hybrid_wishlist_service.dart';

class OfflineSyncService {
  static OfflineSyncService? _instance;

  static OfflineSyncService get instance {
    _instance ??= OfflineSyncService._internal();
    return _instance!;
  }

  OfflineSyncService._internal();

  // Sync offline data to server after login
  Future<void> syncOfflineDataToServer() async {
    debugPrint('🔄 OfflineSyncService: Starting offline data sync...');

    try {
      // Force reinitialize GlobalCubitService to ensure fresh cubit instances
      GlobalCubitService.instance.forceReinitialize();

      // Wait a bit for initialization
      await Future.delayed(const Duration(milliseconds: 500));

      // Sync cart items silently (without showing snackbars)
      await _syncCartItemsSilently();

      // Sync wishlist items
      await _syncWishlistItems();

      // Refresh the global cubits to update UI
      await GlobalCubitService.instance.refreshAll();

      // Additional delay to ensure UI updates properly
      await Future.delayed(const Duration(milliseconds: 300));

      // Notify HybridCartService to update badges
      HybridCartService.instance.notifyListeners();

      // Notify HybridWishlistService to update badges
      HybridWishlistService.instance.notifyListeners();

      // Additional delay to ensure all operations complete before UI refresh
      await Future.delayed(const Duration(milliseconds: 500));

      debugPrint('✅ OfflineSyncService: Sync completed successfully');
    } catch (e) {
      debugPrint('❌ OfflineSyncService: Sync failed: $e');
      rethrow; // Re-throw to handle in auth_cubit
    }
  }

  // Sync offline cart items to server silently (without triggering snackbars)
  Future<void> _syncCartItemsSilently() async {
    final offlineCartItems = await OfflineCartService.instance
        .getCartItemsForSync();

    if (offlineCartItems.isEmpty) {
      debugPrint('🛒 OfflineSyncService: No offline cart items to sync');
      return;
    }

    debugPrint(
      '🛒 OfflineSyncService: Syncing ${offlineCartItems.length} cart items...',
    );

    // Add each offline cart item to server cart silently
    for (final item in offlineCartItems) {
      try {
        await GlobalCubitService.instance.addToCartSilently(
          productId: item['productId'] as int,
          productSizeColorId: item['productSizeColorId'] as int,
          quantity: item['quantity'] as int,
        );
        debugPrint(
          '✅ OfflineSyncService: Synced cart item ${item['productId']}',
        );
      } catch (e) {
        debugPrint(
          '❌ OfflineSyncService: Failed to sync cart item ${item['productId']}: $e',
        );
      }
    }

    // Clear offline cart after successful sync
    await OfflineCartService.instance.clearCart();
    debugPrint('🛒 OfflineSyncService: Offline cart cleared after sync');

    // Notify HybridCartService to update badges
    try {
      final hybridCartService = HybridCartService.instance;
      hybridCartService.notifyListeners();
      debugPrint('🔄 OfflineSyncService: HybridCartService notified');
    } catch (e) {
      debugPrint(
        '⚠️ OfflineSyncService: Failed to notify HybridCartService: $e',
      );
    }
  }

  // Sync offline wishlist items to server
  Future<void> _syncWishlistItems() async {
    final offlineWishlistIds = await OfflineWishlistService.instance
        .getWishlistProductIdsForSync();

    if (offlineWishlistIds.isEmpty) {
      debugPrint('❤️ OfflineSyncService: No offline wishlist items to sync');
      return;
    }

    debugPrint(
      '❤️ OfflineSyncService: Syncing ${offlineWishlistIds.length} wishlist items...',
    );

    // Add each offline wishlist item to server wishlist silently (without snackbars)
    for (final productId in offlineWishlistIds) {
      try {
        await GlobalCubitService.instance.addToWishlistSilently(productId: productId);
        debugPrint('✅ OfflineSyncService: Synced wishlist item $productId silently');
      } catch (e) {
        debugPrint(
          '❌ OfflineSyncService: Failed to sync wishlist item $productId: $e',
        );
      }
    }

    // Clear offline wishlist after successful sync
    await OfflineWishlistService.instance.clearWishlist();
    debugPrint('❤️ OfflineSyncService: Offline wishlist cleared after sync');
  }

  // Get offline data summary for display
  Future<Map<String, int>> getOfflineDataSummary() async {
    final cartCount = await OfflineCartService.instance.getCartItemCount();
    final wishlistCount = await OfflineWishlistService.instance
        .getWishlistItemCount();

    return {'cartItems': cartCount, 'wishlistItems': wishlistCount};
  }

  // Check if there's offline data to sync
  Future<bool> hasOfflineDataToSync() async {
    final summary = await getOfflineDataSummary();
    return summary['cartItems']! > 0 || summary['wishlistItems']! > 0;
  }
}

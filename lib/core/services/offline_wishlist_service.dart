import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/home/domain/entities/home_product.dart';

class OfflineWishlistService {
  static const String _wishlistKey = 'offline_wishlist_items';
  static OfflineWishlistService? _instance;
  
  static OfflineWishlistService get instance {
    _instance ??= OfflineWishlistService._internal();
    return _instance!;
  }
  
  OfflineWishlistService._internal();

  // Add item to offline wishlist
  Future<void> addToWishlist(HomeProduct product) async {
    final prefs = await SharedPreferences.getInstance();
    final wishlistItems = await getWishlistItems();
    
    // Check if item already exists
    final exists = wishlistItems.any((item) => item['productId'] == product.id);
    
    if (!exists) {
      wishlistItems.add({
        'productId': product.id,
        'product': {
          'id': product.id,
          'name': product.name,
          'image': product.image,
          'price': product.price,
          'originalPrice': product.originalPrice,
          'limitation': product.limitation,
          'countOfAvailable': product.countOfAvailable,
        },
        'addedAt': DateTime.now().toIso8601String(),
      });
      
      await prefs.setString(_wishlistKey, jsonEncode(wishlistItems));
    }
  }

  // Remove item from offline wishlist
  Future<void> removeFromWishlist(int productId) async {
    final prefs = await SharedPreferences.getInstance();
    final wishlistItems = await getWishlistItems();
    
    wishlistItems.removeWhere((item) => item['productId'] == productId);
    
    await prefs.setString(_wishlistKey, jsonEncode(wishlistItems));
  }

  // Toggle item in wishlist
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

  // Get all wishlist items
  Future<List<Map<String, dynamic>>> getWishlistItems() async {
    final prefs = await SharedPreferences.getInstance();
    final wishlistData = prefs.getString(_wishlistKey);
    
    if (wishlistData == null) return [];
    
    try {
      final List<dynamic> decoded = jsonDecode(wishlistData);
      return decoded.cast<Map<String, dynamic>>();
    } catch (e) {
      return [];
    }
  }

  // Get wishlist item count
  Future<int> getWishlistItemCount() async {
    final wishlistItems = await getWishlistItems();
    return wishlistItems.length;
  }

  // Check if product is in wishlist
  Future<bool> isInWishlist(int productId) async {
    final wishlistItems = await getWishlistItems();
    return wishlistItems.any((item) => item['productId'] == productId);
  }

  // Clear all wishlist items
  Future<void> clearWishlist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_wishlistKey);
  }

  // Convert offline wishlist items to server format for sync
  Future<List<int>> getWishlistProductIdsForSync() async {
    final wishlistItems = await getWishlistItems();
    return wishlistItems.map<int>((item) => item['productId'] as int).toList();
  }
}

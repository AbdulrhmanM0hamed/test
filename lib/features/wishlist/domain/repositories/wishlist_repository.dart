import '../entities/wishlist_item.dart';

abstract class WishlistRepository {
  Future<WishlistResponse> getMyWishlist();
  Future<Map<String, dynamic>> addToWishlist(int productId);
  Future<Map<String, dynamic>> removeFromWishlist(int productId);
  Future<Map<String, dynamic>> removeAllFromWishlist();
}

import 'package:test/features/home/data/datasources/wishlist_remote_data_source.dart';

abstract class WishlistRepository {
  Future<Map<String, dynamic>> addToWishlist(int productId);
  Future<Map<String, dynamic>> removeFromWishlist(int productId);
  Future<Map<String, dynamic>> getWishlist();
}

class WishlistRepositoryImpl implements WishlistRepository {
  final WishlistRemoteDataSource _remoteDataSource;

  WishlistRepositoryImpl(this._remoteDataSource);

  @override
  Future<Map<String, dynamic>> addToWishlist(int productId) async {
    return await _remoteDataSource.addToWishlist(productId);
  }

  @override
  Future<Map<String, dynamic>> removeFromWishlist(int productId) async {
    return await _remoteDataSource.removeFromWishlist(productId);
  }

  @override
  Future<Map<String, dynamic>> getWishlist() async {
    return await _remoteDataSource.getWishlist();
  }
}

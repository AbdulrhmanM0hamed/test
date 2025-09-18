import '../../domain/entities/wishlist_item.dart';
import '../../domain/repositories/wishlist_repository.dart';
import '../datasources/wishlist_remote_data_source.dart';

class WishlistRepositoryImpl implements WishlistRepository {
  final WishlistRemoteDataSource _remoteDataSource;

  WishlistRepositoryImpl(this._remoteDataSource);

  @override
  Future<WishlistResponse> getMyWishlist() async {
    return await _remoteDataSource.getMyWishlist();
  }

  @override
  Future<Map<String, dynamic>> addToWishlist(int productId) async {
    return await _remoteDataSource.addToWishlist(productId);
  }

  @override
  Future<Map<String, dynamic>> removeFromWishlist(int productId) async {
    return await _remoteDataSource.removeFromWishlist(productId);
  }

  @override
  Future<Map<String, dynamic>> removeAllFromWishlist() async {
    return await _remoteDataSource.removeAllFromWishlist();
  }
}

import '../repositories/wishlist_repository.dart';

class RemoveFromWishlistUseCase {
  final WishlistRepository _repository;

  RemoveFromWishlistUseCase(this._repository);

  Future<Map<String, dynamic>> call(int productId) async {
    return await _repository.removeFromWishlist(productId);
  }
}

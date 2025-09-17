import '../repositories/wishlist_repository.dart';

class AddToWishlistUseCase {
  final WishlistRepository _repository;

  AddToWishlistUseCase(this._repository);

  Future<Map<String, dynamic>> call(int productId) async {
    return await _repository.addToWishlist(productId);
  }
}

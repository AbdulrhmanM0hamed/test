import '../entities/wishlist_item.dart';
import '../repositories/wishlist_repository.dart';

class GetMyWishlistUseCase {
  final WishlistRepository _repository;

  GetMyWishlistUseCase(this._repository);

  Future<WishlistResponse> call() async {
    return await _repository.getMyWishlist();
  }
}

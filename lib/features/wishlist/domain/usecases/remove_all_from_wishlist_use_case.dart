import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/wishlist_repository.dart';

class RemoveAllFromWishlistUseCase {
  final WishlistRepository repository;

  RemoveAllFromWishlistUseCase(this.repository);

  Future<Either<Failure, String>> call() async {
    try {
      print('🎯 RemoveAllFromWishlistUseCase: Starting execution');

      final result = await repository.removeAllFromWishlist();

      print('📊 RemoveAllFromWishlistUseCase: Repository result: $result');
      print('📝 Message from API: ${result['message']}');

      final message =
          result['message'] ?? 'تم حذف جميع المنتجات من المفضلة بنجاح';
      print('✅ RemoveAllFromWishlistUseCase: Success with message: $message');

      return Right(message);
    } catch (e) {
      print('❌ RemoveAllFromWishlistUseCase: Failed with error: $e');
      print('📍 Error type: ${e.runtimeType}');

      return Left(
        ServerFailure(message: 'فشل في حذف جميع المنتجات من المفضلة'),
      );
    }
  }
}

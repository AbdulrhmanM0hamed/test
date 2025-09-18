import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/wishlist_item.dart';
import '../../domain/usecases/get_my_wishlist_use_case.dart';
import '../../domain/usecases/add_to_wishlist_use_case.dart';
import '../../domain/usecases/remove_from_wishlist_use_case.dart';
import '../../domain/usecases/remove_all_from_wishlist_use_case.dart';

part 'wishlist_state.dart';

class WishlistCubit extends Cubit<WishlistState> {
  final GetMyWishlistUseCase _getMyWishlistUseCase;
  final AddToWishlistUseCase _addToWishlistUseCase;
  final RemoveFromWishlistUseCase _removeFromWishlistUseCase;
  final RemoveAllFromWishlistUseCase _removeAllFromWishlistUseCase;

  WishlistCubit(
    this._getMyWishlistUseCase,
    this._addToWishlistUseCase,
    this._removeFromWishlistUseCase,
    this._removeAllFromWishlistUseCase,
  ) : super(WishlistInitial());

  Future<void> getMyWishlist() async {
    emit(WishlistLoading());

    try {
      final response = await _getMyWishlistUseCase();

      if (response.wishlist.isEmpty) {
        emit(WishlistEmpty());
      } else {
        emit(WishlistLoaded(response));
      }
    } catch (e) {
      emit(WishlistError(e.toString()));
    }
  }

  Future<void> removeFromWishlist(int productId) async {
    try {
      final response = await _removeFromWishlistUseCase(productId);

      if (!isClosed) {
        emit(
          WishlistItemRemoved(
            productId,
            response['message'] ?? 'تم حذف المنتج من المفضلة',
          ),
        );
      }
    } catch (e) {
      if (!isClosed) {
        emit(WishlistError('فشل في حذف المنتج من المفضلة'));
      }
    }
  }

  Future<void> addToWishlist(int productId) async {
    try {
      final response = await _addToWishlistUseCase(productId);

      if (!isClosed) {
        emit(
          WishlistItemAdded(
            productId,
            response['message'] ?? 'تم إضافة المنتج للمفضلة',
          ),
        );
      }
    } catch (e) {
      if (!isClosed) {
        emit(WishlistError('فشل في إضافة المنتج للمفضلة'));
      }
    }
  }

  Future<void> removeAllFromWishlist() async {
    try {
      print('🗑️ WishlistCubit: Starting removeAllFromWishlist');
      print('🔍 UseCase instance: $_removeAllFromWishlistUseCase');
      
      final result = await _removeAllFromWishlistUseCase();
      
      print('📋 WishlistCubit: UseCase result received');
      
      result.fold(
        (failure) {
          print('❌ WishlistCubit: UseCase failed with: ${failure.message}');
          if (!isClosed) {
            emit(WishlistError(failure.message));
          }
        },
        (message) {
          print('✅ WishlistCubit: UseCase success with message: $message');
          if (!isClosed) {
            emit(WishlistCleared(message));
            print('🔄 WishlistCubit: Refreshing wishlist after clear');
            // Refresh wishlist to show empty state
            getMyWishlist();
          }
        },
      );
    } catch (e) {
      print('💥 WishlistCubit: Unexpected error in removeAllFromWishlist');
      print('🔥 Error: $e');
      print('📍 Error type: ${e.runtimeType}');
      print('🔍 Stack trace: ${StackTrace.current}');
      
      if (!isClosed) {
        emit(WishlistError('فشل في حذف جميع المنتجات من المفضلة'));
      }
    }
  }

  void resetState() {
    emit(WishlistInitial());
  }
}

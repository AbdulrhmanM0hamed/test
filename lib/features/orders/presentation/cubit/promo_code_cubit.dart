import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/promo_code.dart';
import '../../domain/usecases/check_promo_code_usecase.dart';

part 'promo_code_state.dart';

class PromoCodeCubit extends Cubit<PromoCodeState> {
  final CheckPromoCodeUseCase checkPromoCodeUseCase;

  PromoCodeCubit({
    required this.checkPromoCodeUseCase,
  }) : super(PromoCodeInitial());

  Future<void> checkPromoCode(String code) async {
    if (code.trim().isEmpty) {
      emit(const PromoCodeError('Please enter a promo code'));
      return;
    }

    emit(PromoCodeLoading());
    
    final result = await checkPromoCodeUseCase(CheckPromoCodeParams(code: code));
    
    result.fold(
      (failure) => emit(PromoCodeError(failure.message)),
      (promoCode) {
        if (promoCode.isValid && promoCode.hasRemainingUses) {
          emit(PromoCodeValid(promoCode));
        } else {
          emit(const PromoCodeError('Promo code is expired or has reached maximum usage'));
        }
      },
    );
  }

  void clearPromoCode() {
    emit(PromoCodeInitial());
  }

  void resetState() {
    emit(PromoCodeInitial());
  }
}

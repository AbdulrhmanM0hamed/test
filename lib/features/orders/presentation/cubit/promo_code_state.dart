part of 'promo_code_cubit.dart';

abstract class PromoCodeState extends Equatable {
  const PromoCodeState();

  @override
  List<Object> get props => [];
}

class PromoCodeInitial extends PromoCodeState {}

class PromoCodeLoading extends PromoCodeState {}

class PromoCodeValid extends PromoCodeState {
  final PromoCode promoCode;

  const PromoCodeValid(this.promoCode);

  @override
  List<Object> get props => [promoCode];
}

class PromoCodeError extends PromoCodeState {
  final String message;

  const PromoCodeError(this.message);

  @override
  List<Object> get props => [message];
}

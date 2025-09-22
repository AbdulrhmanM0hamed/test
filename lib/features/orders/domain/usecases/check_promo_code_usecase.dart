import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../entities/promo_code.dart';
import '../repositories/promo_code_repository.dart';

class CheckPromoCodeUseCase {
  final PromoCodeRepository repository;

  CheckPromoCodeUseCase(this.repository);

  Future<Either<Failure, PromoCode>> call(CheckPromoCodeParams params) async {
    return await repository.checkPromoCode(params.code);
  }
}

class CheckPromoCodeParams extends Equatable {
  final String code;

  const CheckPromoCodeParams({required this.code});

  @override
  List<Object> get props => [code];
}

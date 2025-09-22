import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/promo_code.dart';

abstract class PromoCodeRepository {
  Future<Either<Failure, PromoCode>> checkPromoCode(String code);
}

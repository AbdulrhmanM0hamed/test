import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/services/network/network_info.dart';
import '../../domain/entities/promo_code.dart';
import '../../domain/repositories/promo_code_repository.dart';
import '../datasources/promo_code_remote_data_source.dart';

class PromoCodeRepositoryImpl implements PromoCodeRepository {
  final PromoCodeRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  PromoCodeRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, PromoCode>> checkPromoCode(String code) async {
    if (await networkInfo.isConnected) {
      final response = await remoteDataSource.checkPromoCode(code);
      if (response.success && response.data != null) {
        return Right(response.data!);
      } else {
        return Left(ServerFailure(message: response.message));
      }
    } else {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }
}

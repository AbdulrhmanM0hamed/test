import 'package:dartz/dartz.dart';
import 'package:test/core/error/failures.dart';
import 'package:test/core/services/network/network_info.dart';
import '../datasources/faq_remote_data_source.dart';
import '../../domain/entities/faq.dart';
import '../../domain/repositories/faq_repository.dart';

class FAQRepositoryImpl implements FAQRepository {
  final FAQRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  FAQRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<FAQ>>> getFAQs() async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.getFAQs();
        if (response.success) {
          final faqs = response.data!.map((faqModel) => faqModel.toEntity()).toList();
          return Right(faqs);
        } else {
          return Left(ServerFailure(message: response.message));
        }
      } catch (e) {
        return Left(ServerFailure(message: 'Failed to fetch FAQs'));
      }
    } else {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }
}

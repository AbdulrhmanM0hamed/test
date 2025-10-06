import 'package:dartz/dartz.dart';
import 'package:test/core/error/failures.dart';
import '../entities/faq.dart';
import '../repositories/faq_repository.dart';

class GetFAQsUseCase {
  final FAQRepository repository;

  GetFAQsUseCase({required this.repository});

  Future<Either<Failure, List<FAQ>>> call() async {
    return await repository.getFAQs();
  }
}

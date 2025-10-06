import 'package:dartz/dartz.dart';
import 'package:test/core/error/failures.dart';
import '../entities/faq.dart';

abstract class FAQRepository {
  Future<Either<Failure, List<FAQ>>> getFAQs();
}

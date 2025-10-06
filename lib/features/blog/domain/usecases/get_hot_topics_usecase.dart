import 'package:dartz/dartz.dart';
import 'package:test/core/error/failures.dart';
import '../entities/blog.dart';
import '../repositories/blog_repository.dart';

class GetHotTopicsUseCase {
  final BlogRepository repository;

  GetHotTopicsUseCase(this.repository);

  Future<Either<Failure, List<Blog>>> call() async {
    return await repository.getHotTopics();
  }
}

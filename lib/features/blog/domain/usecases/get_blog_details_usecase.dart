import 'package:dartz/dartz.dart';
import 'package:test/core/error/failures.dart';
import '../entities/blog.dart';
import '../repositories/blog_repository.dart';

class GetBlogDetailsParams {
  final int blogId;

  const GetBlogDetailsParams({required this.blogId});
}

class GetBlogDetailsUseCase {
  final BlogRepository repository;

  GetBlogDetailsUseCase(this.repository);

  Future<Either<Failure, Blog>> call(GetBlogDetailsParams params) async {
    return await repository.getBlogDetails(params.blogId);
  }
}

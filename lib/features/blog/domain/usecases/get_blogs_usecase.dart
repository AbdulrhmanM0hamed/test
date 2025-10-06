import 'package:dartz/dartz.dart';
import 'package:test/core/error/failures.dart';
import '../entities/blog_list_response.dart';
import '../repositories/blog_repository.dart';

class GetBlogsParams {
  final int page;

  const GetBlogsParams({this.page = 1});
}

class GetBlogsUseCase {
  final BlogRepository repository;

  GetBlogsUseCase(this.repository);

  Future<Either<Failure, BlogListResponse>> call(GetBlogsParams params) async {
    return await repository.getBlogs(page: params.page);
  }
}

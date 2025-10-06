import 'package:dartz/dartz.dart';
import 'package:test/core/error/failures.dart';
import '../entities/blog.dart';
import '../entities/blog_list_response.dart';

abstract class BlogRepository {
  /// Get paginated list of blogs
  Future<Either<Failure, BlogListResponse>> getBlogs({int page = 1});

  /// Get blog details by ID
  Future<Either<Failure, Blog>> getBlogDetails(int blogId);

  /// Get hot topics (trending blogs)
  Future<Either<Failure, List<Blog>>> getHotTopics();

  /// Add comment to blog
  Future<Either<Failure, String>> addComment({
    required int blogId,
    required String comment,
  });
}

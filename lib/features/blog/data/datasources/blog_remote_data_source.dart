import 'package:test/core/models/api_response.dart';
import '../models/blog_list_response_model.dart';
import '../models/blog_model.dart';

abstract class BlogRemoteDataSource {
  /// Get paginated list of blogs
  Future<ApiResponse<BlogListResponseModel>> getBlogs({int page = 1});

  /// Get blog details by ID
  Future<ApiResponse<BlogModel>> getBlogDetails(int blogId);

  /// Get hot topics (trending blogs)
  Future<ApiResponse<List<BlogModel>>> getHotTopics();

  /// Add comment to blog
  Future<ApiResponse<String>> addComment({
    required int blogId,
    required String comment,
  });
}

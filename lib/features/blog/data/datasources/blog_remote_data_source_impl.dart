import 'package:dio/dio.dart';
import 'package:test/core/models/api_response.dart';
import 'package:test/core/services/network/dio_service.dart';
import 'package:test/core/utils/constant/api_endpoints.dart';
import '../models/blog_list_response_model.dart';
import '../models/blog_model.dart';
import 'blog_remote_data_source.dart';

class BlogRemoteDataSourceImpl implements BlogRemoteDataSource {
  final DioService dioService;

  BlogRemoteDataSourceImpl({required this.dioService});

  @override
  Future<ApiResponse<BlogListResponseModel>> getBlogs({int page = 1}) async {
    try {
      final response = await dioService.get(ApiEndpoints.blogs(page: page));

      if (response.statusCode == 200) {
        final blogListResponse = BlogListResponseModel.fromJson(response.data);
        return ApiResponse.success(
          message: 'Blogs fetched successfully',
          data: blogListResponse,
        );
      } else {
        return ApiResponse.error(
          message: response.data['message'] ?? 'Failed to fetch blogs',
        );
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.error(message: 'Authentication required');
      }
      return ApiResponse.error(
        message: e.response?.data['message'] ?? 'Network error occurred',
      );
    } catch (e) {
      return ApiResponse.error(message: 'An unexpected error occurred');
    }
  }

  @override
  Future<ApiResponse<BlogModel>> getBlogDetails(int blogId) async {
    try {
      final response = await dioService.get(ApiEndpoints.blogDetails(blogId));

      if (response.statusCode == 200) {
        final blogData = response.data['data'] as Map<String, dynamic>;
        final blog = BlogModel.fromJson(blogData);
        return ApiResponse.success(
          message: 'Blog details fetched successfully',
          data: blog,
        );
      } else {
        return ApiResponse.error(
          message: response.data['message'] ?? 'Failed to fetch blog details',
        );
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.error(message: 'Authentication required');
      }
      if (e.response?.statusCode == 404) {
        return ApiResponse.error(message: 'Blog not found');
      }
      return ApiResponse.error(
        message: e.response?.data['message'] ?? 'Network error occurred',
      );
    } catch (e) {
      return ApiResponse.error(message: 'An unexpected error occurred');
    }
  }

  @override
  Future<ApiResponse<List<BlogModel>>> getHotTopics() async {
    try {
      final response = await dioService.get(ApiEndpoints.hotTopics);

      if (response.statusCode == 200) {
        final blogsJson = response.data['data'] as List<dynamic>;
        final blogs = blogsJson
            .map((blogJson) => BlogModel.fromJson(blogJson))
            .toList();
        return ApiResponse.success(
          message: 'Hot topics fetched successfully',
          data: blogs,
        );
      } else {
        return ApiResponse.error(
          message: response.data['message'] ?? 'Failed to fetch hot topics',
        );
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.error(message: 'Authentication required');
      }
      return ApiResponse.error(
        message: e.response?.data['message'] ?? 'Network error occurred',
      );
    } catch (e) {
      return ApiResponse.error(message: 'An unexpected error occurred');
    }
  }

  @override
  Future<ApiResponse<String>> addComment({
    required int blogId,
    required String comment,
  }) async {
    try {
      final response = await dioService.post(
        ApiEndpoints.addBlogComment(blogId),
        data: {'comment': comment},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResponse.success(
          message: response.data['message'] ?? 'Comment added successfully',
        );
      } else {
        return ApiResponse.error(
          message: response.data['message'] ?? 'Failed to add comment',
        );
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.error(message: 'Authentication required');
      }
      if (e.response?.statusCode == 422) {
        return ApiResponse.error(message: 'Invalid comment data');
      }
      return ApiResponse.error(
        message: e.response?.data['message'] ?? 'Network error occurred',
      );
    } catch (e) {
      return ApiResponse.error(message: 'An unexpected error occurred');
    }
  }
}

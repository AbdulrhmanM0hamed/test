import 'package:dartz/dartz.dart';
import 'package:test/core/error/failures.dart';
import 'package:test/core/services/network/network_info.dart';
import '../../domain/entities/blog.dart';
import '../../domain/entities/blog_list_response.dart';
import '../../domain/repositories/blog_repository.dart';
import '../datasources/blog_remote_data_source.dart';

class BlogRepositoryImpl implements BlogRepository {
  final BlogRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  BlogRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, BlogListResponse>> getBlogs({int page = 1}) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.getBlogs(page: page);
        
        if (response.success) {
          return Right(response.data!.toEntity());
        } else {
          return Left(ServerFailure(message: response.message));
        }
      } catch (e) {
        return Left(ServerFailure(message: 'Failed to fetch blogs'));
      }
    } else {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, Blog>> getBlogDetails(int blogId) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.getBlogDetails(blogId);
        
        if (response.success) {
          return Right(response.data!.toEntity());
        } else {
          return Left(ServerFailure(message: response.message));
        }
      } catch (e) {
        return Left(ServerFailure(message: 'Failed to fetch blog details'));
      }
    } else {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<Blog>>> getHotTopics() async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.getHotTopics();
        
        if (response.success) {
          final blogs = response.data!.map((blog) => blog.toEntity()).toList();
          return Right(blogs);
        } else {
          return Left(ServerFailure(message: response.message));
        }
      } catch (e) {
        return Left(ServerFailure(message: 'Failed to fetch hot topics'));
      }
    } else {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, String>> addComment({
    required int blogId,
    required String comment,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.addComment(
          blogId: blogId,
          comment: comment,
        );
        
        if (response.success) {
          return Right(response.data!);
        } else {
          return Left(ServerFailure(message: response.message));
        }
      } catch (e) {
        return Left(ServerFailure(message: 'Failed to add comment'));
      }
    } else {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }
}

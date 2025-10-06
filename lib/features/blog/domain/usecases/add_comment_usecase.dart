import 'package:dartz/dartz.dart';
import 'package:test/core/error/failures.dart';
import '../repositories/blog_repository.dart';

class AddCommentParams {
  final int blogId;
  final String comment;

  const AddCommentParams({
    required this.blogId,
    required this.comment,
  });
}

class AddCommentUseCase {
  final BlogRepository repository;

  AddCommentUseCase(this.repository);

  Future<Either<Failure, String>> call(AddCommentParams params) async {
    return await repository.addComment(
      blogId: params.blogId,
      comment: params.comment,
    );
  }
}

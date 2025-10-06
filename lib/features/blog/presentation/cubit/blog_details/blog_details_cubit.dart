import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_blog_details_usecase.dart';
import '../../../domain/usecases/add_comment_usecase.dart';
import 'blog_details_state.dart';

class BlogDetailsCubit extends Cubit<BlogDetailsState> {
  final GetBlogDetailsUseCase getBlogDetailsUseCase;
  final AddCommentUseCase addCommentUseCase;

  BlogDetailsCubit({
    required this.getBlogDetailsUseCase,
    required this.addCommentUseCase,
  }) : super(BlogDetailsInitial());

  Future<void> getBlogDetails(int blogId) async {
    emit(BlogDetailsLoading());

    try {
      final result = await getBlogDetailsUseCase.call(
        GetBlogDetailsParams(blogId: blogId),
      );

      result.fold(
        (failure) => emit(BlogDetailsError(message: failure.message)),
        (blog) => emit(BlogDetailsLoaded(blog: blog)),
      );
    } catch (e) {
      emit(BlogDetailsError(message: 'An unexpected error occurred'));
    }
  }

  Future<void> addComment({
    required int blogId,
    required String comment,
  }) async {
    if (state is! BlogDetailsLoaded) return;

    final currentBlog = (state as BlogDetailsLoaded).blog;
    emit(BlogCommentAdding(blog: currentBlog));

    try {
      final result = await addCommentUseCase.call(
        AddCommentParams(blogId: blogId, comment: comment),
      );

      result.fold(
        (failure) => emit(BlogCommentError(
          blog: currentBlog,
          message: failure.message,
        )),
        (message) {
          emit(BlogCommentAdded(blog: currentBlog, message: message));
          // Refresh blog details to get updated comments
          getBlogDetails(blogId);
        },
      );
    } catch (e) {
      emit(BlogCommentError(
        blog: currentBlog,
        message: 'Failed to add comment',
      ));
    }
  }

  void resetToLoaded() {
    if (state is BlogCommentAdded || state is BlogCommentError) {
      final blog = state is BlogCommentAdded
          ? (state as BlogCommentAdded).blog
          : (state as BlogCommentError).blog;
      emit(BlogDetailsLoaded(blog: blog));
    }
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_blogs_usecase.dart';
import 'blog_list_state.dart';

class BlogListCubit extends Cubit<BlogListState> {
  final GetBlogsUseCase getBlogsUseCase;

  BlogListCubit({required this.getBlogsUseCase}) : super(BlogListInitial());

  int _currentPage = 1;
  bool _isLoadingMore = false;

  Future<void> getBlogs({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 1;
      emit(BlogListLoading());
    } else if (state is BlogListLoaded) {
      final currentState = state as BlogListLoaded;
      if (currentState.hasReachedMax || _isLoadingMore) return;
      
      _isLoadingMore = true;
      emit(BlogListLoadingMore(
        currentBlogs: currentState.blogs,
        meta: currentState.meta,
      ));
    } else if (state is BlogListInitial) {
      emit(BlogListLoading());
    }

    try {
      final result = await getBlogsUseCase.call(
        GetBlogsParams(page: _currentPage),
      );

      result.fold(
        (failure) {
          _isLoadingMore = false;
          if (state is BlogListLoadingMore) {
            final currentState = state as BlogListLoadingMore;
            emit(BlogListLoaded(
              blogs: currentState.currentBlogs,
              meta: currentState.meta,
              hasReachedMax: true,
            ));
          } else {
            emit(BlogListError(message: failure.message));
          }
        },
        (blogListResponse) {
          _isLoadingMore = false;
          final newBlogs = blogListResponse.blogs;
          final meta = blogListResponse.meta;

          if (state is BlogListLoadingMore) {
            final currentState = state as BlogListLoadingMore;
            final allBlogs = [...currentState.currentBlogs, ...newBlogs];
            
            emit(BlogListLoaded(
              blogs: allBlogs,
              meta: meta,
              hasReachedMax: !meta.hasNextPage,
            ));
          } else {
            emit(BlogListLoaded(
              blogs: newBlogs,
              meta: meta,
              hasReachedMax: !meta.hasNextPage,
            ));
          }

          if (meta.hasNextPage) {
            _currentPage++;
          }
        },
      );
    } catch (e) {
      _isLoadingMore = false;
      emit(BlogListError(message: 'An unexpected error occurred'));
    }
  }

  Future<void> loadMoreBlogs() async {
    if (state is BlogListLoaded) {
      final currentState = state as BlogListLoaded;
      if (!currentState.hasReachedMax && !_isLoadingMore) {
        await getBlogs();
      }
    }
  }

  Future<void> refreshBlogs() async {
    await getBlogs(refresh: true);
  }
}

import 'package:equatable/equatable.dart';
import '../../../domain/entities/blog.dart';
import '../../../domain/entities/blog_meta.dart';

abstract class BlogListState extends Equatable {
  const BlogListState();

  @override
  List<Object?> get props => [];
}

class BlogListInitial extends BlogListState {}

class BlogListLoading extends BlogListState {}

class BlogListLoadingMore extends BlogListState {
  final List<Blog> currentBlogs;
  final BlogMeta meta;

  const BlogListLoadingMore({
    required this.currentBlogs,
    required this.meta,
  });

  @override
  List<Object?> get props => [currentBlogs, meta];
}

class BlogListLoaded extends BlogListState {
  final List<Blog> blogs;
  final BlogMeta meta;
  final bool hasReachedMax;

  const BlogListLoaded({
    required this.blogs,
    required this.meta,
    this.hasReachedMax = false,
  });

  @override
  List<Object?> get props => [blogs, meta, hasReachedMax];

  BlogListLoaded copyWith({
    List<Blog>? blogs,
    BlogMeta? meta,
    bool? hasReachedMax,
  }) {
    return BlogListLoaded(
      blogs: blogs ?? this.blogs,
      meta: meta ?? this.meta,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
}

class BlogListError extends BlogListState {
  final String message;

  const BlogListError({required this.message});

  @override
  List<Object?> get props => [message];
}

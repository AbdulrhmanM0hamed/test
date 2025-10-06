import 'package:equatable/equatable.dart';
import 'blog.dart';
import 'blog_meta.dart';

class BlogListResponse extends Equatable {
  final List<Blog> blogs;
  final BlogMeta meta;
  final String? nextPageUrl;
  final String? previousPageUrl;

  const BlogListResponse({
    required this.blogs,
    required this.meta,
    this.nextPageUrl,
    this.previousPageUrl,
  });

  @override
  List<Object?> get props => [
        blogs,
        meta,
        nextPageUrl,
        previousPageUrl,
      ];

  bool get hasNextPage => nextPageUrl != null;
  bool get hasPreviousPage => previousPageUrl != null;
}

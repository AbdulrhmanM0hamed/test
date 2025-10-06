import '../../domain/entities/blog_list_response.dart';
import 'blog_model.dart';
import 'blog_meta_model.dart';

class BlogListResponseModel extends BlogListResponse {
  const BlogListResponseModel({
    required super.blogs,
    required super.meta,
    super.nextPageUrl,
    super.previousPageUrl,
  });

  factory BlogListResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};
    
    // Parse blogs from data.data array
    final blogsJson = data['data'] as List<dynamic>? ?? [];
    final blogs = blogsJson
        .map((blogJson) => BlogModel.fromJson(blogJson))
        .toList();

    // Parse meta information
    final metaJson = data['meta'] as Map<String, dynamic>? ?? {};
    final meta = BlogMetaModel.fromJson(metaJson);

    // Parse links
    final linksJson = data['links'] as Map<String, dynamic>? ?? {};
    final nextPageUrl = linksJson['next'] as String?;
    final previousPageUrl = linksJson['prev'] as String?;

    return BlogListResponseModel(
      blogs: blogs,
      meta: meta,
      nextPageUrl: nextPageUrl,
      previousPageUrl: previousPageUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': {
        'data': blogs.map((blog) {
          if (blog is BlogModel) {
            return blog.toJson();
          }
          return {
            'id': blog.id,
            'title': blog.title,
            'slug': blog.slug,
            'text': blog.text,
            'views': blog.views,
            'image': blog.image,
            'created_at_day': blog.createdAtDay,
            'created_at_hour': blog.createdAtHour,
            'comments_count': blog.commentsCount,
            'comments': blog.comments,
            'meta_description': blog.metaDescription,
            'meta_keywords': blog.metaKeywords,
          };
        }).toList(),
        'meta': (meta as BlogMetaModel).toJson(),
        'links': {
          'next': nextPageUrl,
          'prev': previousPageUrl,
        },
      },
    };
  }

  BlogListResponse toEntity() {
    return BlogListResponse(
      blogs: blogs,
      meta: meta,
      nextPageUrl: nextPageUrl,
      previousPageUrl: previousPageUrl,
    );
  }
}

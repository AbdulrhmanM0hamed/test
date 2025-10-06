import '../../domain/entities/blog.dart';
import 'blog_comment_model.dart';

class BlogModel extends Blog {
  const BlogModel({
    required super.id,
    required super.title,
    required super.slug,
    required super.text,
    required super.views,
    required super.image,
    required super.createdAtDay,
    required super.createdAtHour,
    required super.commentsCount,
    required super.comments,
    required super.metaDescription,
    required super.metaKeywords,
  });

  factory BlogModel.fromJson(Map<String, dynamic> json) {
    // Parse comments
    final commentsJson = json['comments'] as List<dynamic>? ?? [];
    final comments = commentsJson
        .map((commentJson) => BlogCommentModel.fromJson(commentJson))
        .toList();

    // Parse meta keywords
    final keywordsJson = json['meta_keywords'] as List<dynamic>? ?? [];
    final keywords = keywordsJson.map((keyword) => keyword.toString()).toList();

    return BlogModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      slug: json['slug'] ?? '',
      text: json['text'] ?? '',
      views: json['views'] ?? 0,
      image: json['image'] ?? '',
      createdAtDay: json['created_at_day'] ?? '',
      createdAtHour: json['created_at_hour'] ?? '',
      commentsCount: json['comments_count'] ?? 0,
      comments: comments,
      metaDescription: json['meta_description'] ?? '',
      metaKeywords: keywords,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'slug': slug,
      'text': text,
      'views': views,
      'image': image,
      'created_at_day': createdAtDay,
      'created_at_hour': createdAtHour,
      'comments_count': commentsCount,
      'comments': comments.map((comment) {
        if (comment is BlogCommentModel) {
          return comment.toJson();
        }
        return {
          'comment': comment.comment,
          'user_name': comment.userName,
          'user_image': comment.userImage,
          'created_at_day': comment.createdAtDay,
          'created_at_hour': comment.createdAtHour,
        };
      }).toList(),
      'meta_description': metaDescription,
      'meta_keywords': metaKeywords,
    };
  }

  Blog toEntity() {
    return Blog(
      id: id,
      title: title,
      slug: slug,
      text: text,
      views: views,
      image: image,
      createdAtDay: createdAtDay,
      createdAtHour: createdAtHour,
      commentsCount: commentsCount,
      comments: comments,
      metaDescription: metaDescription,
      metaKeywords: metaKeywords,
    );
  }
}

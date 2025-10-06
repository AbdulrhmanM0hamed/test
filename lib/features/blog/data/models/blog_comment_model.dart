import '../../domain/entities/blog_comment.dart';

class BlogCommentModel extends BlogComment {
  const BlogCommentModel({
    required super.comment,
    required super.userName,
    required super.userImage,
    required super.createdAtDay,
    required super.createdAtHour,
  });

  factory BlogCommentModel.fromJson(Map<String, dynamic> json) {
    return BlogCommentModel(
      comment: json['comment'] ?? '',
      userName: json['user_name'] ?? '',
      userImage: json['user_image'] ?? '',
      createdAtDay: json['created_at_day'] ?? '',
      createdAtHour: json['created_at_hour'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'comment': comment,
      'user_name': userName,
      'user_image': userImage,
      'created_at_day': createdAtDay,
      'created_at_hour': createdAtHour,
    };
  }

  BlogComment toEntity() {
    return BlogComment(
      comment: comment,
      userName: userName,
      userImage: userImage,
      createdAtDay: createdAtDay,
      createdAtHour: createdAtHour,
    );
  }
}

import 'package:equatable/equatable.dart';

class BlogComment extends Equatable {
  final String comment;
  final String userName;
  final String userImage;
  final String createdAtDay;
  final String createdAtHour;

  const BlogComment({
    required this.comment,
    required this.userName,
    required this.userImage,
    required this.createdAtDay,
    required this.createdAtHour,
  });

  @override
  List<Object?> get props => [
        comment,
        userName,
        userImage,
        createdAtDay,
        createdAtHour,
      ];
}

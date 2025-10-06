import 'package:equatable/equatable.dart';
import '../../../domain/entities/blog.dart';

abstract class BlogDetailsState extends Equatable {
  const BlogDetailsState();

  @override
  List<Object?> get props => [];
}

class BlogDetailsInitial extends BlogDetailsState {}

class BlogDetailsLoading extends BlogDetailsState {}

class BlogDetailsLoaded extends BlogDetailsState {
  final Blog blog;

  const BlogDetailsLoaded({required this.blog});

  @override
  List<Object?> get props => [blog];
}

class BlogDetailsError extends BlogDetailsState {
  final String message;

  const BlogDetailsError({required this.message});

  @override
  List<Object?> get props => [message];
}

// Comment states
class BlogCommentAdding extends BlogDetailsState {
  final Blog blog;

  const BlogCommentAdding({required this.blog});

  @override
  List<Object?> get props => [blog];
}

class BlogCommentAdded extends BlogDetailsState {
  final Blog blog;
  final String message;

  const BlogCommentAdded({
    required this.blog,
    required this.message,
  });

  @override
  List<Object?> get props => [blog, message];
}

class BlogCommentError extends BlogDetailsState {
  final Blog blog;
  final String message;

  const BlogCommentError({
    required this.blog,
    required this.message,
  });

  @override
  List<Object?> get props => [blog, message];
}

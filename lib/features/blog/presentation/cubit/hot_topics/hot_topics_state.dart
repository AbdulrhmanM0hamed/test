import 'package:equatable/equatable.dart';
import '../../../domain/entities/blog.dart';

abstract class HotTopicsState extends Equatable {
  const HotTopicsState();

  @override
  List<Object?> get props => [];
}

class HotTopicsInitial extends HotTopicsState {}

class HotTopicsLoading extends HotTopicsState {}

class HotTopicsLoaded extends HotTopicsState {
  final List<Blog> hotTopics;

  const HotTopicsLoaded({required this.hotTopics});

  @override
  List<Object?> get props => [hotTopics];
}

class HotTopicsError extends HotTopicsState {
  final String message;

  const HotTopicsError({required this.message});

  @override
  List<Object?> get props => [message];
}

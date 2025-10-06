import 'package:equatable/equatable.dart';
import 'blog_comment.dart';

class Blog extends Equatable {
  final int id;
  final String title;
  final String slug;
  final String text;
  final int views;
  final String image;
  final String createdAtDay;
  final String createdAtHour;
  final int commentsCount;
  final List<BlogComment> comments;
  final String metaDescription;
  final List<String> metaKeywords;

  const Blog({
    required this.id,
    required this.title,
    required this.slug,
    required this.text,
    required this.views,
    required this.image,
    required this.createdAtDay,
    required this.createdAtHour,
    required this.commentsCount,
    required this.comments,
    required this.metaDescription,
    required this.metaKeywords,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        slug,
        text,
        views,
        image,
        createdAtDay,
        createdAtHour,
        commentsCount,
        comments,
        metaDescription,
        metaKeywords,
      ];

  // Helper method to get clean text without HTML tags
  String get cleanText {
    return text
        .replaceAll(RegExp(r'<[^>]*>'), '') // Remove HTML tags
        .replaceAll(RegExp(r'&[^;]+;'), '') // Remove HTML entities
        .replaceAll(RegExp(r'\s+'), ' ') // Replace multiple spaces with single space
        .trim();
  }

  // Helper method to get excerpt
  String getExcerpt({int maxLength = 150}) {
    final clean = cleanText;
    if (clean.length <= maxLength) return clean;
    
    final truncated = clean.substring(0, maxLength);
    final lastSpace = truncated.lastIndexOf(' ');
    
    return lastSpace > 0 
        ? '${truncated.substring(0, lastSpace)}...'
        : '$truncated...';
  }

  // Helper method to get reading time estimate
  int get estimatedReadingTime {
    final wordCount = cleanText.split(' ').length;
    return (wordCount / 200).ceil(); // Assuming 200 words per minute
  }
}

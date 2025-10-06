import '../../domain/entities/blog_meta.dart';

class BlogMetaModel extends BlogMeta {
  const BlogMetaModel({
    required super.currentPage,
    required super.from,
    required super.lastPage,
    required super.path,
    required super.perPage,
    required super.to,
    required super.total,
  });

  factory BlogMetaModel.fromJson(Map<String, dynamic> json) {
    return BlogMetaModel(
      currentPage: json['current_page'] ?? 1,
      from: json['from'] ?? 1,
      lastPage: json['last_page'] ?? 1,
      path: json['path'] ?? '',
      perPage: json['per_page'] ?? 10,
      to: json['to'] ?? 1,
      total: json['total'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_page': currentPage,
      'from': from,
      'last_page': lastPage,
      'path': path,
      'per_page': perPage,
      'to': to,
      'total': total,
    };
  }

  BlogMeta toEntity() {
    return BlogMeta(
      currentPage: currentPage,
      from: from,
      lastPage: lastPage,
      path: path,
      perPage: perPage,
      to: to,
      total: total,
    );
  }
}

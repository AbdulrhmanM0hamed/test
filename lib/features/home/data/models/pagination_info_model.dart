import '../../domain/entities/pagination_info.dart';

class PaginationInfoModel extends PaginationInfo {
  const PaginationInfoModel({required super.perPage, required super.to, required super.total});

  factory PaginationInfoModel.fromJson(Map<String, dynamic> json) {
    // Try to get pagination from meta first (Laravel pagination)
    final meta = json['meta'] as Map<String, dynamic>?;
    
    if (meta != null) {
      return PaginationInfoModel(
        perPage: meta['per_page'] ?? 10,
        to: meta['to'] ?? 0,
        total: meta['total'] ?? 0,
      );
    }
    
    // Fallback to direct pagination data
    return PaginationInfoModel(
      perPage: json['per_page'] ?? 10,
      to: json['to'] ?? 0,
      total: json['total'] ?? 0,
    );
  }
}

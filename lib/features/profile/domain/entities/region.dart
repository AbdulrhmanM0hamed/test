class Region {
  final int id;
  final String titleEn;
  final String titleAr;
  final String code;
  final String status;
  final int cityId;
  final String? createdAt;
  final String? updatedAt;

  const Region({
    required this.id,
    required this.titleEn,
    required this.titleAr,
    required this.code,
    required this.status,
    required this.cityId,
    this.createdAt,
    this.updatedAt,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Region && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Region(id: $id, titleAr: $titleAr, titleEn: $titleEn)';
}

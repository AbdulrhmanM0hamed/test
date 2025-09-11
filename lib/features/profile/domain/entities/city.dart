class City {
  final int id;
  final String? image;
  final String titleEn;
  final String titleAr;
  final String? code;
  final String? status;
  final int countryId;
  final String? createdAt;
  final String? updatedAt;

  const City({
    required this.id,
    this.image,
    required this.titleEn,
    required this.titleAr,
    this.code,
    this.status,
    required this.countryId,
    this.createdAt,
    this.updatedAt,
  });

  /// Get localized title based on language
  String getLocalizedTitle(bool isArabic) {
    return isArabic ? titleAr : titleEn;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is City && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'City(id: $id, titleAr: $titleAr, titleEn: $titleEn)';
}

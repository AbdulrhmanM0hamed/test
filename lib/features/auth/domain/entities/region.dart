class Region {
  final int id;
  final String titleEn;
  final String titleAr;
  final int cityId;
  final String? image;

  const Region({
    required this.id,
    required this.titleEn,
    required this.titleAr,
    required this.cityId,
    this.image,
  });

  String getLocalizedTitle(bool isArabic) {
    return isArabic ? titleAr : titleEn;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Region && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

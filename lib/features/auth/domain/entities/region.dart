class Region {
  final int id;
  final String titleEn;
  final String titleAr;
  final int cityId;

  const Region({
    required this.id,
    required this.titleEn,
    required this.titleAr,
    required this.cityId,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Region && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

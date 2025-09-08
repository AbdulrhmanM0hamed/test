class City {
  final int id;
  final String titleEn;
  final String titleAr;
  final int countryId;
  final String image;

  const City({
    required this.id,
    required this.titleEn,
    required this.titleAr,
    required this.countryId,
    required this.image,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is City && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

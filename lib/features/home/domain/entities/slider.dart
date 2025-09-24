class Slider {
  final int id;
  final String image;
  final String link;

  const Slider({
    required this.id,
    required this.image,
    required this.link,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Slider &&
        other.id == id &&
        other.image == image &&
        other.link == link;
  }

  @override
  int get hashCode => id.hashCode ^ image.hashCode ^ link.hashCode;
}

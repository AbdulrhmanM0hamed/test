import '../../domain/entities/slider.dart';

class SliderModel extends Slider {
  const SliderModel({
    required super.id,
    required super.image,
    required super.link,
  });

  factory SliderModel.fromJson(Map<String, dynamic> json) {
    return SliderModel(
      id: json['id'] ?? 0,
      image: json['image'] ?? '',
      link: json['link'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image': image,
      'link': link,
    };
  }

  Slider toEntity() {
    return Slider(
      id: id,
      image: image,
      link: link,
    );
  }
}

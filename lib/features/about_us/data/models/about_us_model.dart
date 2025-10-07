import '../../domain/entities/about_us.dart';

class AboutUsModel {
  final String textEn;
  final String textAr;
  final String videoLink;

  const AboutUsModel({
    required this.textEn,
    required this.textAr,
    required this.videoLink,
  });

  factory AboutUsModel.fromJson(Map<String, dynamic> json) {
    return AboutUsModel(
      textEn: json['text_en'] ?? '',
      textAr: json['text_ar'] ?? '',
      videoLink: json['video_link'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text_en': textEn,
      'text_ar': textAr,
      'video_link': videoLink,
    };
  }

  AboutUs toEntity() {
    return AboutUs(
      textEn: textEn,
      textAr: textAr,
      videoLink: videoLink,
    );
  }
}

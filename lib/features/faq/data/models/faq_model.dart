import '../../domain/entities/faq.dart';

class FAQModel {
  final int id;
  final String question;
  final String answer;

  const FAQModel({
    required this.id,
    required this.question,
    required this.answer,
  });

  factory FAQModel.fromJson(Map<String, dynamic> json) {
    return FAQModel(
      id: json['id'] ?? 0,
      question: json['q'] ?? '',
      answer: json['a'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'q': question,
      'a': answer,
    };
  }

  FAQ toEntity() {
    return FAQ(
      id: id,
      question: question,
      answer: answer,
    );
  }
}

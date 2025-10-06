import '../../domain/entities/faq.dart';

abstract class FAQState {}

class FAQInitial extends FAQState {}

class FAQLoading extends FAQState {}

class FAQLoaded extends FAQState {
  final List<FAQ> faqs;

  FAQLoaded({required this.faqs});
}

class FAQError extends FAQState {
  final String message;

  FAQError({required this.message});
}

import '../../domain/entities/about_us.dart';

abstract class AboutUsState {}

class AboutUsInitial extends AboutUsState {}

class AboutUsLoading extends AboutUsState {}

class AboutUsLoaded extends AboutUsState {
  final AboutUs aboutUs;

  AboutUsLoaded({required this.aboutUs});
}

class AboutUsError extends AboutUsState {
  final String message;

  AboutUsError({required this.message});
}

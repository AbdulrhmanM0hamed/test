import '../../data/models/contact_info_model.dart';

abstract class ContactUsState {}

class ContactUsInitial extends ContactUsState {}

class ContactUsLoading extends ContactUsState {}

class ContactUsLoaded extends ContactUsState {
  final ContactInfoModel contactInfo;

  ContactUsLoaded({required this.contactInfo});
}

class ContactUsError extends ContactUsState {
  final String message;

  ContactUsError({required this.message});
}

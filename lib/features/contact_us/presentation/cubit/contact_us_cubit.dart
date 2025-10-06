import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/contact_info_model.dart';
import '../../domain/usecases/get_contact_info_usecase.dart';
import 'contact_us_state.dart';

class ContactUsCubit extends Cubit<ContactUsState> {
  final GetContactInfoUseCase getContactInfoUseCase;

  ContactUsCubit({required this.getContactInfoUseCase}) : super(ContactUsInitial());

  Future<void> getContactInfo() async {
    emit(ContactUsLoading());
    
    try {
      final response = await getContactInfoUseCase();
      
      if (response.success && response.data != null) {
        emit(ContactUsLoaded(contactInfo: response.data!));
      } else {
        emit(ContactUsError(message: response.message ?? 'Failed to load contact information'));
      }
    } catch (e) {
      emit(ContactUsError(message: 'An error occurred: ${e.toString()}'));
    }
  }
}

import 'package:test/core/models/api_response.dart';
import '../../data/models/contact_info_model.dart';
import '../repositories/contact_us_repository.dart';

class GetContactInfoUseCase {
  final ContactUsRepository repository;

  GetContactInfoUseCase({required this.repository});

  Future<ApiResponse<ContactInfoModel>> call() async {
    return await repository.getContactInfo();
  }
}

import 'package:test/core/models/api_response.dart';
import '../../data/models/contact_info_model.dart';

abstract class ContactUsRepository {
  Future<ApiResponse<ContactInfoModel>> getContactInfo();
}

import 'package:dio/dio.dart';
import 'package:test/core/services/network/dio_service.dart';
import 'package:test/core/utils/constant/api_endpoints.dart';
import 'package:test/features/auth/data/models/terms_and_conditions_model.dart';

class TermsService {
  final DioService _dioService;

  TermsService(this._dioService);

  Future<TermsAndConditionsResponse> getTermsAndConditions() async {
    try {
      final response = await _dioService.get(ApiEndpoints.termsAndConditions);
      return TermsAndConditionsResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Failed to load terms and conditions: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}

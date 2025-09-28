import 'package:test/core/models/api_response.dart';
import 'package:test/core/services/network/dio_service.dart';
import 'package:test/core/utils/constant/api_endpoints.dart';
import '../models/notification_model.dart';

abstract class NotificationsRemoteDataSource {
  Future<ApiResponse<NotificationsResponseModel>> getNotifications();
  Future<ApiResponse<NotificationDetailsResponseModel>> getNotificationDetails(int notificationId);
}

class NotificationsRemoteDataSourceImpl implements NotificationsRemoteDataSource {
  final DioService dioService;

  const NotificationsRemoteDataSourceImpl({required this.dioService});

  @override
  Future<ApiResponse<NotificationsResponseModel>> getNotifications() async {
    try {
      final response = await dioService.get(ApiEndpoints.notifications);

      if (response.statusCode == 200) {
        final notificationsResponse = NotificationsResponseModel.fromJson(response.data);
        return ApiResponse.success(
          data: notificationsResponse,
          message: response.data['message'] ?? 'تم تحميل الإشعارات بنجاح',
        );
      } else {
        return ApiResponse.error(
          message: response.data['message'] ?? 'فشل في تحميل الإشعارات، يرجى المحاولة مرة أخرى',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      return ApiResponse.error(
        message: 'تعذر الاتصال بالخادم، تأكد من اتصالك بالإنترنت',
        statusCode: 500,
      );
    }
  }

  @override
  Future<ApiResponse<NotificationDetailsResponseModel>> getNotificationDetails(int notificationId) async {
    try {
      final response = await dioService.get(ApiEndpoints.notificationDetails(notificationId));

      if (response.statusCode == 200) {
        final notificationDetailsResponse = NotificationDetailsResponseModel.fromJson(response.data);
        return ApiResponse.success(
          data: notificationDetailsResponse,
          message: response.data['message'] ?? 'تم تحميل تفاصيل الإشعار بنجاح',
        );
      } else {
        return ApiResponse.error(
          message: response.data['message'] ?? 'فشل في تحميل تفاصيل الإشعار، يرجى المحاولة مرة أخرى',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      return ApiResponse.error(
        message: 'تعذر الاتصال بالخادم، تأكد من اتصالك بالإنترنت',
        statusCode: 500,
      );
    }
  }
}

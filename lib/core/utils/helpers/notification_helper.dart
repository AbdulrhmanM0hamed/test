import 'package:flutter/material.dart';
import 'package:test/core/services/firebase_notification_service.dart';

class NotificationHelper {
  static final NotificationHelper _instance = NotificationHelper._internal();
  factory NotificationHelper() => _instance;
  NotificationHelper._internal();

  static NotificationHelper get instance => _instance;

  // Subscribe to user-specific topics
  Future<void> subscribeToUserTopics(String userId) async {
    try {
      // Subscribe to user-specific notifications
      await FirebaseNotificationService.instance.subscribeToTopic(
        'user_$userId',
      );

      // Subscribe to general notifications
      await FirebaseNotificationService.instance.subscribeToTopic(
        'general_notifications',
      );

      // Subscribe to order notifications
      await FirebaseNotificationService.instance.subscribeToTopic(
        'order_notifications',
      );

      // Subscribe to promotion notifications
      await FirebaseNotificationService.instance.subscribeToTopic(
        'promotion_notifications',
      );

      //print('✅ Subscribed to all user topics for user: $userId');
    } catch (e) {
      //print('❌ Error subscribing to user topics: $e');
    }
  }

  // Unsubscribe from user-specific topics (on logout)
  Future<void> unsubscribeFromUserTopics(String userId) async {
    try {
      // Unsubscribe from user-specific notifications
      await FirebaseNotificationService.instance.unsubscribeFromTopic(
        'user_$userId',
      );

      // Keep general notifications but unsubscribe from user-specific ones
      await FirebaseNotificationService.instance.unsubscribeFromTopic(
        'order_notifications',
      );

      //print('✅ Unsubscribed from user topics for user: $userId');
    } catch (e) {
      //print('❌ Error unsubscribing from user topics: $e');
    }
  }

  // Subscribe to promotion notifications
  Future<void> subscribeToPromotions() async {
    try {
      await FirebaseNotificationService.instance.subscribeToTopic(
        'promotion_notifications',
      );
      //print('✅ Subscribed to promotion notifications');
    } catch (e) {
      //print('❌ Error subscribing to promotions: $e');
    }
  }

  // Unsubscribe from promotion notifications
  Future<void> unsubscribeFromPromotions() async {
    try {
      await FirebaseNotificationService.instance.unsubscribeFromTopic(
        'promotion_notifications',
      );
      //print('✅ Unsubscribed from promotion notifications');
    } catch (e) {
      //print('❌ Error unsubscribing from promotions: $e');
    }
  }

  // Get notification icon based on type
  static IconData getNotificationIcon(String type) {
    switch (type.toLowerCase()) {
      case 'order':
        return Icons.shopping_bag_outlined;
      case 'promotion':
        return Icons.local_offer_outlined;
      case 'system':
        return Icons.info_outline;
      case 'delivery':
        return Icons.local_shipping_outlined;
      default:
        return Icons.notifications_outlined;
    }
  }

  // Get notification color based on type
  static Color getNotificationColor(String type) {
    switch (type.toLowerCase()) {
      case 'order':
        return const Color(0xFF8B4513); // Coffee brown
      case 'promotion':
        return Colors.orange;
      case 'system':
        return Colors.blue;
      case 'delivery':
        return Colors.green;
      default:
        return const Color(0xFF8B4513);
    }
  }

  // Get notification type label in Arabic
  static String getNotificationTypeLabel(String type) {
    switch (type.toLowerCase()) {
      case 'order':
        return 'إشعار طلب';
      case 'promotion':
        return 'عرض خاص';
      case 'system':
        return 'إشعار النظام';
      case 'delivery':
        return 'إشعار التوصيل';
      default:
        return 'إشعار';
    }
  }

  // Clear all notifications
  Future<void> clearAllNotifications() async {
    try {
      await FirebaseNotificationService.instance.clearAllNotifications();
      //print('✅ All notifications cleared');
    } catch (e) {
      //print('❌ Error clearing notifications: $e');
    }
  }

  // Get FCM token for debugging
  Future<String?> getFCMToken() async {
    try {
      return await FirebaseNotificationService.instance.getCurrentToken();
    } catch (e) {
      //print('❌ Error getting FCM token: $e');
      return null;
    }
  }

  // Handle notification navigation
  static void handleNotificationNavigation(
    BuildContext context,
    Map<String, dynamic> data,
  ) {
    final type = data['type'] as String?;
    final orderId = data['order_id'] as String?;
    final notificationId = data['notification_id'] as String?;

    //print('🧭 Handling notification navigation: type=$type, orderId=$orderId');

    try {
      if (type == 'order' && orderId != null) {
        // Navigate to order details
        Navigator.pushNamed(
          context,
          '/order-details',
          arguments: int.tryParse(orderId),
        );
      } else if (type == 'promotion') {
        // Navigate to promotions or home
        Navigator.pushNamed(context, '/');
      } else if (notificationId != null) {
        // Navigate to notification details
        Navigator.pushNamed(
          context,
          '/notification-details',
          arguments: int.tryParse(notificationId),
        );
      } else {
        // Default: Navigate to notifications list
        Navigator.pushNamed(context, '/notifications');
      }
    } catch (e) {
      //print('❌ Error navigating from notification: $e');
      // Fallback: Navigate to notifications list
      Navigator.pushNamed(context, '/notifications');
    }
  }
}

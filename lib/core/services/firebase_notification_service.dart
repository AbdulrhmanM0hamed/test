import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:test/core/di/dependency_injection.dart';
import 'package:test/core/utils/helpers/notification_helper.dart';
import 'package:test/features/notifications/presentation/cubit/notifications_cubit.dart';
import 'package:test/main.dart' show navigatorKey;

class FirebaseNotificationService {
  static final FirebaseNotificationService _instance =
      FirebaseNotificationService._internal();
  factory FirebaseNotificationService() => _instance;
  FirebaseNotificationService._internal();

  static FirebaseNotificationService get instance => _instance;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  // Initialize Firebase Messaging
  Future<void> initialize() async {
    print('🔥 FirebaseNotificationService: Initializing...');

    try {
      // Request permission for notifications
      await _requestPermission();

      // Initialize local notifications
      await _initializeLocalNotifications();

      // Configure Firebase Messaging
      await _configureFirebaseMessaging();

      // Get FCM token
      await _getFCMToken();

      // Test notification functionality
      await _testNotificationSetup();

      print(
        '✅ FirebaseNotificationService: Initialization completed successfully',
      );
    } catch (e) {
      print('❌ FirebaseNotificationService: Initialization failed: $e');
      rethrow;
    }
  }

  // Test notification setup
  Future<void> _testNotificationSetup() async {
    try {
      print('🧪 Testing notification setup...');

      // Check if notifications are enabled
      final settings = await _firebaseMessaging.getNotificationSettings();
      print(
        '🔔 Current notification settings: ${settings.authorizationStatus}',
      );

      // Get current token
      final token = await _firebaseMessaging.getToken();
      if (token != null) {
        print('✅ FCM Token is available: ${token.substring(0, 20)}...');
      } else {
        print('❌ FCM Token is null');
      }

      // Test local notification
      await _showTestLocalNotification();

      print('✅ Notification setup test completed');
    } catch (e) {
      print('❌ Notification setup test failed: $e');
    }
  }

  // Show test local notification
  Future<void> _showTestLocalNotification() async {
    try {
      const androidDetails = AndroidNotificationDetails(
        'high_importance_channel',
        'High Importance Notifications',
        channelDescription: 'This channel is used for important notifications.',
        importance: Importance.high,
        priority: Priority.high,
        showWhen: true,
        icon: '@mipmap/ic_launcher',
        color: Color(0xFF8B4513),
        playSound: true,
        enableVibration: true,
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _localNotifications.show(
        999999,
        'Sobieh Coffee - Test',
        'Firebase notifications are working! 🎉',
        details,
        payload: '{"type": "test", "message": "Test notification"}',
      );

      print('✅ Test local notification sent');
    } catch (e) {
      print('❌ Failed to send test local notification: $e');
    }
  }

  // Request notification permissions
  Future<void> _requestPermission() async {
    final settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('🔔 Notification permission status: ${settings.authorizationStatus}');

    if (settings.authorizationStatus == AuthorizationStatus.denied) {
      print('❌ User denied notification permissions');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.notDetermined) {
      print('⚠️ User has not yet granted notification permissions');
    } else {
      print('✅ User granted notification permissions');
    }
  }

  // Initialize local notifications
  Future<void> _initializeLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Create notification channel for Android
    const androidChannel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.high,
      playSound: true,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(androidChannel);
  }

  // Configure Firebase Messaging
  Future<void> _configureFirebaseMessaging() async {
    // Handle foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);

    // Handle notification taps when app is in background
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

    // Handle notification tap when app is terminated
    final initialMessage = await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      _handleNotificationTap(initialMessage);
    }
  }

  // Get FCM token
  Future<String?> _getFCMToken() async {
    try {
      print('🎯 Getting FCM token...');
      final token = await _firebaseMessaging.getToken();

      if (token != null) {
        print('✅ FCM Token received successfully');
        print(
          '🎯 Token (first 50 chars): ${token.substring(0, token.length > 50 ? 50 : token.length)}...',
        );
        print('🎯 Token length: ${token.length} characters');

        // Listen for token refresh
        _firebaseMessaging.onTokenRefresh.listen((newToken) {
          print('🔄 FCM Token refreshed');
          print(
            '🔄 New token (first 50 chars): ${newToken.substring(0, newToken.length > 50 ? 50 : newToken.length)}...',
          );
          _sendTokenToServer(newToken);
        });

        // Send initial token to server
        _sendTokenToServer(token);

        return token;
      } else {
        print(
          '❌ FCM Token is null - this might indicate a problem with Firebase setup',
        );
        return null;
      }
    } catch (e) {
      print('❌ Error getting FCM token: $e');
      print('❌ This might indicate Firebase is not properly configured');
      return null;
    }
  }

  // Send token to server
  Future<void> _sendTokenToServer(String token) async {
    try {
      // TODO: Implement API call to send token to server
      print('📤 Sending FCM token to server: $token');

      // Example API call:
      // final dioService = DependencyInjection.getIt<DioService>();
      // await dioService.post('/fcm-token', data: {'token': token});
    } catch (e) {
      print('❌ Error sending token to server: $e');
    }
  }

  // Handle foreground messages
  void _handleForegroundMessage(RemoteMessage message) {
    print('📱 ========== FOREGROUND MESSAGE RECEIVED ==========');
    print('📱 Message ID: ${message.messageId}');
    print('📱 Title: ${message.notification?.title}');
    print('📱 Body: ${message.notification?.body}');
    print('📱 Data: ${message.data}');
    print('📱 From: ${message.from}');
    print('📱 Sent Time: ${message.sentTime}');
    print('📱 TTL: ${message.ttl}');
    print('📱 ===============================================');

    // Show local notification when app is in foreground
    _showLocalNotification(message);

    // Refresh notifications list
    refreshNotificationsList();
  }

  // Handle notification tap
  void _handleNotificationTap(RemoteMessage message) {
    print('👆 Notification tapped: ${message.messageId}');
    print('👆 Data: ${message.data}');

    // Navigate to appropriate screen based on notification data
    _navigateToScreen(message.data);

    // Refresh notifications list
    refreshNotificationsList();
  }

  // Handle local notification tap
  void _onNotificationTapped(NotificationResponse response) {
    print('👆 Local notification tapped: ${response.id}');

    if (response.payload != null) {
      final data = jsonDecode(response.payload!);
      _navigateToScreen(data);
    }
  }

  // Show local notification
  Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    const androidDetails = AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      channelDescription: 'This channel is used for important notifications.',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
      icon: '@mipmap/ic_launcher',
      color: Color(0xFF8B4513), // Coffee brown color
      playSound: true,
      enableVibration: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      message.hashCode,
      notification.title,
      notification.body,
      details,
      payload: jsonEncode(message.data),
    );
  }

  // Navigate to appropriate screen
  void _navigateToScreen(Map<String, dynamic> data) {
    // Get current context from navigator key
    final context = _getNavigatorContext();
    if (context != null) {
      NotificationHelper.handleNotificationNavigation(context, data);
    } else {
      print('❌ No context available for navigation');
    }
  }

  // Get navigator context from global navigator key
  BuildContext? _getNavigatorContext() {
    try {
      return navigatorKey.currentContext;
    } catch (e) {
      print('❌ Error getting navigator context: $e');
      return null;
    }
  }

  // Refresh notifications list
  void refreshNotificationsList() {
    try {
      final notificationsCubit =
          DependencyInjection.getIt<NotificationsCubit>();
      notificationsCubit.refreshNotifications();
      print('🔄 Notifications list refreshed');
    } catch (e) {
      print('❌ Error refreshing notifications list: $e');
    }
  }

  // Subscribe to topic
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _firebaseMessaging.subscribeToTopic(topic);
      print('📢 Subscribed to topic: $topic');
    } catch (e) {
      print('❌ Error subscribing to topic $topic: $e');
    }
  }

  // Unsubscribe from topic
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _firebaseMessaging.unsubscribeFromTopic(topic);
      print('🔇 Unsubscribed from topic: $topic');
    } catch (e) {
      print('❌ Error unsubscribing from topic $topic: $e');
    }
  }

  // Get current FCM token
  Future<String?> getCurrentToken() async {
    try {
      return await _firebaseMessaging.getToken();
    } catch (e) {
      print('❌ Error getting current token: $e');
      return null;
    }
  }

  // Clear all notifications
  Future<void> clearAllNotifications() async {
    try {
      await _localNotifications.cancelAll();
      print('🧹 All local notifications cleared');
    } catch (e) {
      print('❌ Error clearing notifications: $e');
    }
  }

  // Delete FCM token
  Future<void> deleteToken() async {
    try {
      await _firebaseMessaging.deleteToken();
      print('🗑️ FCM token deleted');
    } catch (e) {
      print('❌ Error deleting token: $e');
    }
  }

  // Set auto initialization
  Future<void> setAutoInitEnabled(bool enabled) async {
    try {
      await _firebaseMessaging.setAutoInitEnabled(enabled);
      print('🔧 Auto initialization set to: $enabled');
    } catch (e) {
      print('❌ Error setting auto initialization: $e');
    }
  }

  // Send test notification manually
  Future<void> sendTestNotification() async {
    try {
      print('🧪 Sending manual test notification...');

      await _localNotifications.show(
        DateTime.now().millisecondsSinceEpoch ~/ 1000,
        'Test Notification',
        'This is a manual test notification from Sobieh Coffee! ☕',
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel',
            'High Importance Notifications',
            channelDescription:
                'This channel is used for important notifications.',
            importance: Importance.high,
            priority: Priority.high,
            showWhen: true,
            icon: '@mipmap/ic_launcher',
            color: Color(0xFF8B4513),
            playSound: true,
            enableVibration: true,
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        payload:
            '{"type": "manual_test", "timestamp": "${DateTime.now().toIso8601String()}"}',
      );

      print('✅ Manual test notification sent successfully');
    } catch (e) {
      print('❌ Failed to send manual test notification: $e');
    }
  }

  // Check notification status
  Future<Map<String, dynamic>> getNotificationStatus() async {
    try {
      final settings = await _firebaseMessaging.getNotificationSettings();
      final token = await _firebaseMessaging.getToken();
      
      print('🔍 ========== NOTIFICATION STATUS CHECK ==========');
      print('🔍 Authorization Status: ${settings.authorizationStatus}');
      print('🔍 Alert Setting: ${settings.alert}');
      print('🔍 Badge Setting: ${settings.badge}');
      print('🔍 Sound Setting: ${settings.sound}');
      print('🔍 Announcement Setting: ${settings.announcement}');
      print('🔍 Critical Alert Setting: ${settings.criticalAlert}');
      print('🔍 Token Available: ${token != null}');
      if (token != null) {
        print('🔍 Token: $token');
      }
      print('🔍 ===============================================');
      
      return {
        'permissionStatus': settings.authorizationStatus.toString(),
        'alert': settings.alert.toString(),
        'badge': settings.badge.toString(),
        'sound': settings.sound.toString(),
        'hasToken': token != null,
        'token': token,
        'tokenPreview': token != null ? '${token.substring(0, 20)}...' : null,
        'isInitialized': true,
      };
    } catch (e) {
      print('❌ Error getting notification status: $e');
      return {
        'permissionStatus': 'error',
        'hasToken': false,
        'tokenPreview': null,
        'isInitialized': false,
        'error': e.toString(),
      };
    }
  }
}

// Background message handler (must be top-level function)
@pragma('vm:entry-point')
Future<void> _handleBackgroundMessage(RemoteMessage message) async {
  print('🌙 ========== BACKGROUND MESSAGE RECEIVED ==========');
  print('🌙 Message ID: ${message.messageId}');
  print('🌙 Title: ${message.notification?.title}');
  print('🌙 Body: ${message.notification?.body}');
  print('🌙 Data: ${message.data}');
  print('🌙 From: ${message.from}');
  print('🌙 Sent Time: ${message.sentTime}');
  print('🌙 TTL: ${message.ttl}');
  print('🌙 ===============================================');

  // Handle background message processing here
  // Note: UI operations are not allowed in background handlers
  // You can only perform data processing, local storage operations, etc.

  try {
    // Example: Save notification to local storage
    // final prefs = await SharedPreferences.getInstance();
    // final notifications = prefs.getStringList('background_notifications') ?? [];
    // notifications.add(jsonEncode({
    //   'id': message.messageId,
    //   'title': message.notification?.title,
    //   'body': message.notification?.body,
    //   'data': message.data,
    //   'timestamp': DateTime.now().toIso8601String(),
    // }));
    // await prefs.setStringList('background_notifications', notifications);

    print('✅ Background message processed successfully');
  } catch (e) {
    print('❌ Error processing background message: $e');
  }
}

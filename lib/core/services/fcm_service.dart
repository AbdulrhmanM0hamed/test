// import 'package:firebase_messaging/firebase_messaging.dart';

// class FCMService {
//   static final FCMService _instance = FCMService._internal();
//   factory FCMService() => _instance;
//   FCMService._internal();

//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

//   /// Get FCM token for the current device
//   Future<String?> getFCMToken() async {
//     try {
//       // Request permission for notifications
//       NotificationSettings settings = await _firebaseMessaging.requestPermission(
//         alert: true,
//         announcement: false,
//         badge: true,
//         carPlay: false,
//         criticalAlert: false,
//         provisional: false,
//         sound: true,
//       );

//       if (settings.authorizationStatus == AuthorizationStatus.authorized ||
//           settings.authorizationStatus == AuthorizationStatus.provisional) {
//         // Get the token
//         String? token = await _firebaseMessaging.getToken();
//         return token;
//       }

//       return null;
//     } catch (e) {
//       print('Error getting FCM token: $e');
//       return null;
//     }
//   }

//   /// Initialize FCM service
//   Future<void> initialize() async {
//     try {
//       // Handle foreground messages
//       FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//         print('Got a message whilst in the foreground!');
//         print('Message data: ${message.data}');

//         if (message.notification != null) {
//           print('Message also contained a notification: ${message.notification}');
//         }
//       });

//       // Handle background messages
//       FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

//       // Handle notification taps when app is in background
//       FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//         print('A new onMessageOpenedApp event was published!');
//         // Handle navigation based on notification data
//       });
//     } catch (e) {
//       print('Error initializing FCM: $e');
//     }
//   }

//   /// Refresh FCM token
//   Future<String?> refreshToken() async {
//     try {
//       await _firebaseMessaging.deleteToken();
//       return await getFCMToken();
//     } catch (e) {
//       print('Error refreshing FCM token: $e');
//       return null;
//     }
//   }
// }

// /// Background message handler
// @pragma('vm:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   print("Handling a background message: ${message.messageId}");
// }

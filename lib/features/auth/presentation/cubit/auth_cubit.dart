import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/core/services/token_storage_service.dart';
import 'package:test/core/services/app_state_service.dart';
import 'package:test/core/services/auth_state_service.dart';
import 'package:test/core/services/firebase_notification_service.dart';
import 'package:test/core/utils/error/error_handler.dart';
import 'package:test/features/auth/domain/entities/login_request.dart';
import 'package:test/features/auth/domain/usecases/login_usecase.dart';
import 'package:test/features/auth/domain/usecases/logout_usecase.dart';
import 'package:test/features/auth/domain/usecases/refresh_token_usecase.dart';
import 'package:test/features/auth/domain/usecases/resend_verification_email_usecase.dart';
import 'package:test/features/auth/presentation/cubit/auth_state.dart';
import 'package:test/core/services/offline_sync_service.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase loginUseCase;
  final LogoutUseCase logoutUseCase;
  final RefreshTokenUseCase refreshTokenUseCase;
  final ResendVerificationEmailUseCase resendVerificationEmailUseCase;
  final TokenStorageService tokenStorageService;
  final AppStateService appStateService;
  // final FCMService fcmService;

  AuthCubit({
    required this.loginUseCase,
    required this.logoutUseCase,
    required this.refreshTokenUseCase,
    required this.resendVerificationEmailUseCase,
    required this.tokenStorageService,
    required this.appStateService,
    // required this.fcmService,
  }) : super(AuthInitial());

  Future<void> login({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    try {
      emit(AuthLoading());

      // Get FCM token
      print('🔥 Getting FCM token for login...');
      final fcmToken = await FirebaseNotificationService.instance
          .getCurrentToken();
      print('🎯 FCM Token obtained: ${fcmToken ?? "null"}');

      final loginRequest = LoginRequest(
        email: email,
        password: password,
        fcmToken: fcmToken,
      );

      print('📤 Sending login request to use case...');
      final response = await loginUseCase(loginRequest);
      print('📥 Login use case response received');
      print('✅ Response success: ${response.success}');

      if (response.success && response.data != null) {
        final user = response.data!;
        print('👤 User logged in successfully: ${user.email}');
        print('🎯 User ID: ${user.id}');

        // Store token and user data with expiration
        await tokenStorageService.saveTokens(
          accessToken: user.token,
          refreshToken: user.token,
          sessionToken: user.token,
          expiresIn: user.expiresIn,
        );
        await tokenStorageService.saveUserData(
          userId: user.id,
          userUuid: user.id.toString(),
          userEmail: user.email,
          userStatus: user.status,
        );

        // Handle app state for persistent login
        await appStateService.handleSuccessfulLogin(
          rememberMe: rememberMe,
          email: email,
          password: password,
        );

        // Update AuthStateService to reflect login state
        await AuthStateService.instance.login();

        // Subscribe to user-specific notification topics
        print('📢 Subscribing to notification topics for user: ${user.id}');
        try {
          await FirebaseNotificationService.instance.subscribeToTopic(
            'user_${user.id}',
          );
          await FirebaseNotificationService.instance.subscribeToTopic(
            'general_notifications',
          );
          await FirebaseNotificationService.instance.subscribeToTopic(
            'order_notifications',
          );
          print('✅ Successfully subscribed to notification topics');
        } catch (e) {
          print('❌ Error subscribing to notification topics: $e');
        }

        emit(AuthSuccess(user, message: response.message));

        // Sync offline data to server after successful login and state emission
        try {
          await OfflineSyncService.instance.syncOfflineDataToServer();
        } catch (e) {
          //print('🔄 Failed to sync offline data after login: $e');
          // Don't fail the login process if sync fails
        }
      } else {
        String errorMessage =
            response.getFirstErrorMessage() ?? response.message;

        // Check if it's a 401 Not Verified error
        if (response.statusCode == 401 &&
            (errorMessage.toLowerCase().contains('not verified') ||
                errorMessage == 'Not Verified')) {
          emit(EmailNotVerified(email, errorMessage));
        } else {
          emit(AuthError(errorMessage));
        }
      }
    } catch (e) {
      //print('🔍 LOGIN EXCEPTION: $e');
      //print('🔍 EXCEPTION TYPE: ${e.runtimeType}');

      final errorMessage = ErrorHandler.extractErrorMessage(e);
      //print('🔍 EXTRACTED ERROR MESSAGE: $errorMessage');

      // Check if it's an ApiException or DioException with 401 status and Not Verified message
      if (e is DioException && e.response?.statusCode == 401) {
        //print('🔍 DIO EXCEPTION 401 DETECTED');
        final responseData = e.response?.data;
        //print('🔍 RESPONSE DATA: $responseData');

        if (responseData is Map<String, dynamic>) {
          final message = responseData['message'] ?? '';
          //print('🔍 MESSAGE FROM RESPONSE: $message');

          if (message == 'Not Verified' ||
              message.toLowerCase().contains('not verified')) {
            //print('🔍 EMITTING EmailNotVerified STATE');
            emit(EmailNotVerified(email, message));
            return;
          }
        }
      }

      // Check if error message indicates Not Verified (for ApiException or other types)
      if (errorMessage == 'Not Verified' ||
          errorMessage.toLowerCase().contains('not verified')) {
        //print('🔍 EMITTING EmailNotVerified FROM MESSAGE CHECK');
        emit(EmailNotVerified(email, errorMessage));
      } else {
        //print('🔍 EMITTING AuthError');
        emit(AuthError(errorMessage));
      }
    }
  }

  Future<void> logout() async {
    try {
      if (!isClosed) {
        emit(AuthLoading());
      }

      // Get current user ID before clearing tokens
      final userId = tokenStorageService.userId;
      print('🚪 Logging out user: $userId');

      // Call logout API
      final response = await logoutUseCase();

      // Unsubscribe from user-specific notification topics
      if (userId != null) {
        print('📢 Unsubscribing from notification topics for user: $userId');
        try {
          await FirebaseNotificationService.instance.unsubscribeFromTopic(
            'user_$userId',
          );
          await FirebaseNotificationService.instance.unsubscribeFromTopic(
            'order_notifications',
          );
          print('✅ Successfully unsubscribed from notification topics');
        } catch (e) {
          print('❌ Error unsubscribing from notification topics: $e');
        }
      }

      // Clear stored tokens
      await tokenStorageService.clearAll();

      // Update AuthStateService to reflect logout state
      await AuthStateService.instance.logout();

      // Handle app state for logout
      await appStateService.handleLogout();

      if (response.success) {
        if (!isClosed) {
          emit(AuthLoggedOut(message: response.message));
        }
      } else {
        String errorMessage =
            response.getFirstErrorMessage() ?? response.message;
        if (!isClosed) {
          emit(AuthError(errorMessage));
        }
      }
    } catch (e) {
      final errorMessage = ErrorHandler.extractErrorMessage(e);
      if (!isClosed) {
        emit(AuthError(errorMessage));
      }
    }
  }

  Future<void> refreshToken() async {
    try {
      emit(AuthLoading());

      final refreshData = await refreshTokenUseCase();
      final newToken = refreshData['access_token'] as String;
      final expiresIn = refreshData['expires_in'] as int?;

      // Update token in storage
      await tokenStorageService.updateAccessToken(
        newToken,
        expiresIn: expiresIn,
      );

      emit(AuthTokenRefreshed(message: 'Token refreshed successfully'));
    } catch (e) {
      final errorMessage = ErrorHandler.extractErrorMessage(e);
      emit(AuthError(errorMessage));
    }
  }

  Future<void> resendVerificationEmail(String email) async {
    //print('🔍 RESENDING VERIFICATION EMAIL TO: $email');
    emit(AuthLoading());

    try {
      final response = await resendVerificationEmailUseCase(email);
      //print('🔍 RESEND EMAIL RESPONSE: $response');
      emit(
        VerificationEmailSentSuccess(
          response['message'] ?? 'Verification email sent successfully',
        ),
      );
    } catch (e) {
      //print('🔍 RESEND EMAIL ERROR: $e');
      final errorMessage = ErrorHandler.extractErrorMessage(e);
      emit(AuthError(errorMessage));
    }
  }

  void resetState() {
    emit(AuthInitial());
  }
}

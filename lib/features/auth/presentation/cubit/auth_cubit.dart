import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/core/services/token_storage_service.dart';
import 'package:test/core/services/app_state_service.dart';
import 'package:test/core/utils/error/error_handler.dart';
import 'package:test/features/auth/domain/entities/login_request.dart';
import 'package:test/features/auth/domain/usecases/login_usecase.dart';
import 'package:test/features/auth/domain/usecases/logout_usecase.dart';
import 'package:test/features/auth/presentation/cubit/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase loginUseCase;
  final LogoutUseCase logoutUseCase;
  final TokenStorageService tokenStorageService;
  final AppStateService appStateService;
  // final FCMService fcmService;

  AuthCubit({
    required this.loginUseCase,
    required this.logoutUseCase,
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
      // final fcmToken = await fcmService.getFCMToken();

      final loginRequest = LoginRequest(
        email: email,
        password: password,
        fcmToken: "",
      );

      final response = await loginUseCase(loginRequest);

      if (response.success && response.data != null) {
        final user = response.data!;

        // Store token and user data
        await tokenStorageService.saveTokens(
          accessToken: user.token,
          refreshToken: user.token,
          sessionToken: user.token,
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

        emit(AuthSuccess(user, message: response.message));
      } else {
        String errorMessage =
            response.getFirstErrorMessage() ?? response.message;
        emit(AuthError(errorMessage));
      }
    } catch (e) {
      final errorMessage = ErrorHandler.extractErrorMessage(e);
      emit(AuthError(errorMessage));
    }
  }

  Future<void> logout() async {
    try {
      emit(AuthLoading());

      // Call logout API
      final response = await logoutUseCase();

      // Clear stored tokens
      await tokenStorageService.clearAll();

      // Handle app state for logout
      await appStateService.handleLogout();

      if (response.success) {
        emit(AuthLoggedOut(message: response.message));
      } else {
        String errorMessage =
            response.getFirstErrorMessage() ?? response.message;
        emit(AuthError(errorMessage));
      }
    } catch (e) {
      final errorMessage = ErrorHandler.extractErrorMessage(e);
      emit(AuthError(errorMessage));
    }
  }

  void resetState() {
    emit(AuthInitial());
  }
}

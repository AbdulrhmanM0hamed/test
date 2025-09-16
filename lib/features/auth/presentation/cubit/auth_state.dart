import 'package:test/features/auth/domain/entities/user.dart';

abstract class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final User user;
  final String message;

  const AuthSuccess(this.user, {this.message = 'تم تسجيل الدخول بنجاح'});
}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);
}

class AuthLoggedOut extends AuthState {
  final String message;

  const AuthLoggedOut({this.message = 'تم تسجيل الخروج بنجاح'});
}

class AuthTokenRefreshed extends AuthState {
  final String message;

  const AuthTokenRefreshed({this.message = 'تم تحديث الرمز المميز بنجاح'});
}

class VerificationEmailSentSuccess extends AuthState {
  final String message;

  const VerificationEmailSentSuccess(this.message);
}

class EmailNotVerified extends AuthState {
  final String email;
  final String message;

  const EmailNotVerified(this.email, this.message);
}

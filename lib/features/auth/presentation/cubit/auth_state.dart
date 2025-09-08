import 'package:test/features/auth/domain/entities/user.dart';

abstract class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final User user;

  const AuthSuccess(this.user);
}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);
}

class AuthLoggedOut extends AuthState {}

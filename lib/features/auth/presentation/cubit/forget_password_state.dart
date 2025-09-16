part of 'forget_password_cubit.dart';

abstract class ForgetPasswordState extends Equatable {
  const ForgetPasswordState();

  @override
  List<Object?> get props => [];
}

class ForgetPasswordInitial extends ForgetPasswordState {}

class ForgetPasswordLoading extends ForgetPasswordState {}

class ForgetPasswordEmailSent extends ForgetPasswordState {
  final String email;
  final String message;

  const ForgetPasswordEmailSent({
    required this.email,
    required this.message,
  });

  @override
  List<Object?> get props => [email, message];
}

class ForgetPasswordOtpVerified extends ForgetPasswordState {
  final String email;
  final String otp;
  final String message;

  const ForgetPasswordOtpVerified({
    required this.email,
    required this.otp,
    required this.message,
  });

  @override
  List<Object?> get props => [email, otp, message];
}

class ForgetPasswordSuccess extends ForgetPasswordState {
  final String message;

  const ForgetPasswordSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class ForgetPasswordError extends ForgetPasswordState {
  final String message;

  const ForgetPasswordError({required this.message});

  @override
  List<Object?> get props => [message];
}

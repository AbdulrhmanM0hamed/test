import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:test/features/auth/domain/entities/forget_password_request.dart';
import 'package:test/features/auth/domain/entities/check_otp_request.dart';
import 'package:test/features/auth/domain/entities/change_password_request.dart';
import 'package:test/features/auth/domain/usecases/forget_password_usecase.dart';
import 'package:test/features/auth/domain/usecases/check_otp_usecase.dart';
import 'package:test/features/auth/domain/usecases/change_password_usecase.dart';

part 'forget_password_state.dart';

class ForgetPasswordCubit extends Cubit<ForgetPasswordState> {
  final ForgetPasswordUseCase forgetPasswordUseCase;
  final CheckOtpUseCase checkOtpUseCase;
  final ChangePasswordUseCase changePasswordUseCase;

  ForgetPasswordCubit({
    required this.forgetPasswordUseCase,
    required this.checkOtpUseCase,
    required this.changePasswordUseCase,
  }) : super(ForgetPasswordInitial());

  String _email = '';
  String _otp = '';

  void resetToInitial() {
    _email = '';
    _otp = '';
    emit(ForgetPasswordInitial());
  }

  Future<void> sendForgetPasswordRequest(String email) async {
    emit(ForgetPasswordLoading());
    _email = email;

    try {
      final request = ForgetPasswordRequest(email: email);
      final response = await forgetPasswordUseCase(request);

      if (response.success) {
        emit(ForgetPasswordEmailSent(email: email, message: response.message));
      } else {
        emit(ForgetPasswordError(message: response.message));
      }
    } catch (e) {
      emit(ForgetPasswordError(message: e.toString()));
    }
  }

  Future<void> verifyOtp(String otp) async {
    emit(ForgetPasswordLoading());
    _otp = otp;

    try {
      final request = CheckOtpRequest(email: _email, otp: otp);
      final response = await checkOtpUseCase(request);

      if (response.success) {
        emit(
          ForgetPasswordOtpVerified(
            email: _email,
            otp: otp,
            message: response.message,
          ),
        );
      } else {
        emit(ForgetPasswordError(message: response.message));
      }
    } catch (e) {
      emit(ForgetPasswordError(message: e.toString()));
    }
  }

  Future<void> changePassword(String password, String confirmPassword) async {
    emit(ForgetPasswordLoading());

    try {
      final request = ChangePasswordRequest(
        email: _email,
        otp: _otp,
        password: password,
        confirmPassword: confirmPassword,
      );
      final response = await changePasswordUseCase(request);

      if (response.success) {
        emit(ForgetPasswordSuccess(message: response.message));
      } else {
        emit(ForgetPasswordError(message: response.message));
      }
    } catch (e) {
      emit(ForgetPasswordError(message: e.toString()));
    }
  }

  // Getters for current step tracking
  String get currentEmail => _email;
  String get currentOtp => _otp;

  int get currentStep {
    if (state is ForgetPasswordEmailSent) return 1;
    if (state is ForgetPasswordOtpVerified) return 2;
    if (state is ForgetPasswordSuccess) return 3;
    return 0;
  }
}

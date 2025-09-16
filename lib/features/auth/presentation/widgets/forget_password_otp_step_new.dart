import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/core/utils/theme/app_colors.dart';
import 'package:test/core/utils/widgets/custom_snackbar.dart';
import 'package:test/core/utils/common/custom_button.dart';
import 'package:test/core/utils/constant/font_manger.dart';
import 'package:test/core/utils/constant/styles_manger.dart';
import 'package:test/features/auth/presentation/cubit/forget_password_cubit.dart';
import 'package:test/l10n/app_localizations.dart';

class ForgetPasswordOtpStepNew extends StatefulWidget {
  const ForgetPasswordOtpStepNew({super.key});

  @override
  State<ForgetPasswordOtpStepNew> createState() =>
      _ForgetPasswordOtpStepNewState();
}

class _ForgetPasswordOtpStepNewState extends State<ForgetPasswordOtpStepNew> {
  final List<TextEditingController> _controllers = List.generate(4, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (index) => FocusNode());
  String _otpCode = '';

  // Timer variables
  Timer? _resendTimer;
  int _resendCountdown = 0;
  bool _canResend = true;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _startResendTimer() {
    setState(() {
      _canResend = false;
      _resendCountdown = 60; // 60 seconds countdown
    });

    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _resendCountdown--;
      });

      if (_resendCountdown <= 0) {
        setState(() {
          _canResend = true;
        });
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cubit = context.read<ForgetPasswordCubit>();
    final screenWidth = MediaQuery.of(context).size.width;

    return BlocListener<ForgetPasswordCubit, ForgetPasswordState>(
      listener: (context, state) {
        if (state is ForgetPasswordError) {
          CustomSnackbar.showError(context: context, message: state.message);
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 40),

          // Header Icon
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.security_outlined,
              size: 50,
              color: AppColors.primary,
            ),
          ),

          const SizedBox(height: 32),

          // Title
          Text(
            l10n.verifyCode,
            style: getBoldStyle(
              fontSize: FontSize.size24,
              fontFamily: FontConstant.cairo,
              color: Theme.of(context).textTheme.headlineLarge?.color,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 16),

          // Description
          Text(
            '${l10n.verificationCode} sent to ${cubit.currentEmail}',
            style: getMediumStyle(
              fontSize: FontSize.size16,
              fontFamily: FontConstant.cairo,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 40),

          // OTP Input Fields
          Directionality(
            textDirection: TextDirection.ltr,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(4, (index) {
                return Container(
                  width: screenWidth * 0.15,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _focusNodes[index].hasFocus
                          ? AppColors.primary
                          : _controllers[index].text.isNotEmpty
                              ? AppColors.primary
                              : Colors.grey.withOpacity(0.3),
                      width: 2,
                    ),
                    color: _focusNodes[index].hasFocus
                        ? AppColors.primary.withOpacity(0.05)
                        : _controllers[index].text.isNotEmpty
                            ? AppColors.primary.withOpacity(0.1)
                            : Theme.of(context).cardColor,
                  ),
                  child: TextField(
                    controller: _controllers[index],
                    focusNode: _focusNodes[index],
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    style: getBoldStyle(
                      fontSize: FontSize.size24,
                      fontFamily: FontConstant.cairo,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black87,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: const InputDecoration(
                      counterText: '',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        if (index < 3) {
                          _focusNodes[index + 1].requestFocus();
                        } else {
                          _focusNodes[index].unfocus();
                        }
                      } else if (value.isEmpty && index > 0) {
                        _focusNodes[index - 1].requestFocus();
                      }
                      _updateOtpCode();
                    },
                    onSubmitted: (value) {
                      if (index < 3 && value.isNotEmpty) {
                        _focusNodes[index + 1].requestFocus();
                      } else {
                        _focusNodes[index].unfocus();
                        if (_otpCode.length == 4) {
                          _verifyOtp();
                        }
                      }
                    },
                  ),
                );
              }),
            ),
          ),

          const SizedBox(height: 40),

          // Verify Button
          BlocBuilder<ForgetPasswordCubit, ForgetPasswordState>(
            builder: (context, state) {
              final isLoading = state is ForgetPasswordLoading;

              return CustomButton(
                text: l10n.verifyCode,
                onPressed: _otpCode.length < 4 ? null : _verifyOtp,
                isLoading: isLoading,
              );
            },
          ),

          const SizedBox(height: 24),

          // Resend OTP
          BlocBuilder<ForgetPasswordCubit, ForgetPasswordState>(
            builder: (context, state) {
              final isLoading = state is ForgetPasswordLoading;
              final canTap = !isLoading && _canResend;

              return Column(
                children: [
                  TextButton(
                    onPressed: canTap ? _resendOtp : null,
                    child: Text(
                      _canResend
                          ? l10n.resendCode
                          : '${l10n.resendCode} ($_resendCountdown)',
                      style: getSemiBoldStyle(
                        fontSize: FontSize.size14,
                        fontFamily: FontConstant.cairo,
                        color: canTap ? AppColors.primary : Colors.grey,
                      ),
                    ),
                  ),
                  if (!_canResend)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        Localizations.localeOf(context).languageCode == 'ar'
                            ? 'يمكنك إعادة الإرسال خلال $_resendCountdown ثانية'
                            : 'You can resend in $_resendCountdown seconds',
                        style: getRegularStyle(
                          fontSize: FontSize.size12,
                          fontFamily: FontConstant.cairo,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                ],
              );
            },
          ),

          const SizedBox(height: 16),

          // Help Text
          Text(
            l10n.codeExpired,
            style: getRegularStyle(
              fontSize: FontSize.size12,
              fontFamily: FontConstant.cairo,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),

          const Spacer(),

          // Navigation buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    context.read<ForgetPasswordCubit>().resetToInitial();
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    l10n.previous,
                    style: getMediumStyle(
                      fontSize: FontSize.size16,
                      fontFamily: FontConstant.cairo,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  void _updateOtpCode() {
    setState(() {
      _otpCode = _controllers.map((controller) => controller.text).join();
    });
  }

  void _verifyOtp() {
    if (_otpCode.length == 4) {
      context.read<ForgetPasswordCubit>().verifyOtp(_otpCode);
    }
  }

  void _resendOtp() {
    if (_canResend) {
      final cubit = context.read<ForgetPasswordCubit>();
      cubit.sendForgetPasswordRequest(cubit.currentEmail);
      _startResendTimer(); // Start countdown again
    }
  }
}

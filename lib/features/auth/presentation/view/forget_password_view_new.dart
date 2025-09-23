import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/core/utils/common/custom_app_bar.dart';
import 'package:test/core/utils/theme/app_colors.dart';
import 'package:test/core/utils/animations/custom_progress_indcator.dart';
import 'package:test/core/utils/widgets/custom_snackbar.dart';
import 'package:test/core/utils/constant/font_manger.dart';
import 'package:test/core/utils/constant/styles_manger.dart';
import 'package:test/features/auth/presentation/cubit/forget_password_cubit.dart';
import 'package:test/features/auth/presentation/view/login_view.dart';
import 'package:test/features/auth/presentation/widgets/forget_password_email_step.dart';
import 'package:test/features/auth/presentation/widgets/forget_password_otp_step_new.dart';
import 'package:test/features/auth/presentation/widgets/forget_password_new_password_step.dart';
import 'package:test/l10n/app_localizations.dart';

class ForgetPasswordViewNew extends StatefulWidget {
  const ForgetPasswordViewNew({super.key});
  static const String routeName = '/forget-password-new';

  @override
  State<ForgetPasswordViewNew> createState() => _ForgetPasswordViewNewState();
}

class _ForgetPasswordViewNewState extends State<ForgetPasswordViewNew> {
  int activeStep = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: AppLocalizations.of(context)!.forgetPassword),

      body: BlocConsumer<ForgetPasswordCubit, ForgetPasswordState>(
        listener: (context, state) {
          if (state is ForgetPasswordEmailSent) {
            setState(() {
              activeStep = 1;
            });
          } else if (state is ForgetPasswordOtpVerified) {
            CustomSnackbar.showSuccess(
              context: context,
              message: state.message,
            );
            setState(() {
              activeStep = 2;
            });
          } else if (state is ForgetPasswordSuccess) {
            CustomSnackbar.showSuccess(
              context: context,
              message: state.message,
            );
            Future.delayed(const Duration(milliseconds: 1000), () {
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginView()),
                  (route) => false,
                );
              }
            });
          } else if (state is ForgetPasswordError) {
            CustomSnackbar.showError(context: context, message: state.message);
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              Column(
                children: [
                  // Custom Step Indicator
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: _buildCustomStepIndicator(),
                  ),

                  // Step Content
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: _buildStepContent(),
                    ),
                  ),
                ],
              ),

              // Loading Overlay
              if (state is ForgetPasswordLoading)
                Container(
                  color: Colors.black.withValues(alpha: 0.3),
                  child: const Center(child: CustomProgressIndicator(size: 80)),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStepContent() {
    switch (activeStep) {
      case 0:
        return const ForgetPasswordEmailStep();
      case 1:
        return const ForgetPasswordOtpStepNew();
      case 2:
        return const ForgetPasswordNewPasswordStep();
      default:
        return const ForgetPasswordEmailStep();
    }
  }

  Widget _buildCustomStepIndicator() {
    return Column(
      children: [
        // Step circles with connecting lines
        Row(
          children: [
            // Step 1
            _buildStepCircle(0, Icons.email),
            // Line 1
            Expanded(child: _buildConnectingLine(0)),
            // Step 2
            _buildStepCircle(1, Icons.security),
            // Line 2
            Expanded(child: _buildConnectingLine(1)),
            // Step 3
            _buildStepCircle(2, Icons.lock_reset),
          ],
        ),

        const SizedBox(height: 12),

        // Step labels
        Row(
          children: [
            Expanded(
              child: _buildStepLabel(
                0,
                AppLocalizations.of(context)!.writeEmail,
              ),
            ),
            Expanded(
              child: _buildStepLabel(
                1,
                AppLocalizations.of(context)!.verificationCode,
              ),
            ),
            Expanded(
              child: _buildStepLabel(
                2,
                AppLocalizations.of(context)!.newPassword,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStepCircle(int stepIndex, IconData icon) {
    final isActive = activeStep >= stepIndex;
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? AppColors.primary : Colors.grey.shade200,
        border: Border.all(
          color: isActive ? AppColors.primary : Colors.grey.shade300,
          width: 2,
        ),
      ),
      child: Icon(icon, color: isActive ? Colors.white : Colors.grey, size: 24),
    );
  }

  Widget _buildConnectingLine(int stepIndex) {
    final isActive = activeStep > stepIndex;
    return Container(
      height: 2,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(1),
      ),
    );
  }

  Widget _buildStepLabel(int stepIndex, String label) {
    final isActive = activeStep >= stepIndex;
    return Text(
      label,
      textAlign: TextAlign.center,
      style: getRegularStyle(
        color: isActive ? AppColors.primary : Colors.grey,
        fontSize: FontSize.size12,
        fontFamily: FontConstant.cairo,
      ),
    );
  }
}

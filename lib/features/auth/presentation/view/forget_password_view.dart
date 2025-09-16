import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/core/utils/animations/custom_progress_indcator.dart';
import 'package:test/core/utils/constant/font_manger.dart';
import 'package:test/core/utils/constant/styles_manger.dart';
import 'package:test/features/auth/presentation/cubit/forget_password_cubit.dart';
import 'package:test/features/auth/presentation/widgets/forget_password_step_indicator.dart';
import 'package:test/features/auth/presentation/widgets/forget_password_email_step.dart';
import 'package:test/features/auth/presentation/widgets/forget_password_otp_step_new.dart';
import 'package:test/features/auth/presentation/widgets/forget_password_new_password_step.dart';
import 'package:test/l10n/app_localizations.dart';

class ForgetPasswordView extends StatelessWidget {
  static const String routeName = '/forgot-password';
  const ForgetPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).iconTheme.color,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          AppLocalizations.of(context)!.forgetPasswordTitle,
          style: getSemiBoldStyle(
            fontSize: FontSize.size18,
            fontFamily: FontConstant.cairo,
            color: Theme.of(context).textTheme.headlineLarge?.color,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<ForgetPasswordCubit, ForgetPasswordState>(
        builder: (context, state) {
          // Show centered loading overlay when loading
          if (state is ForgetPasswordLoading) {
            return Stack(
              children: [
                // Background content
                _buildMainContent(context, state),
                // Centered loading overlay
                Container(
                  color: Colors.black.withOpacity(0.3),
                  child: const Center(child: CustomProgressIndicator(size: 80)),
                ),
              ],
            );
          }

          return _buildMainContent(context, state);
        },
      ),
    );
  }

  Widget _buildMainContent(BuildContext context, ForgetPasswordState state) {
    return Column(
      children: [
        // Progress Indicator
        ForgetPasswordStepIndicator(
          currentStep: context.read<ForgetPasswordCubit>().currentStep,
          totalSteps: 3,
        ),

        // Content
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _buildCurrentStep(context, state),
          ),
        ),
      ],
    );
  }

  Widget _buildCurrentStep(BuildContext context, ForgetPasswordState state) {
    final currentStep = context.read<ForgetPasswordCubit>().currentStep;

    switch (currentStep) {
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
}

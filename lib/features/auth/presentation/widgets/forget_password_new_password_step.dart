import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/core/utils/theme/app_colors.dart';
import 'package:test/core/utils/common/password_field.dart';
import 'package:test/core/utils/common/custom_button.dart';
import 'package:test/core/utils/validators/form_validators_clean.dart';
import 'package:test/core/utils/widgets/custom_snackbar.dart';
import 'package:test/core/utils/constant/font_manger.dart';
import 'package:test/core/utils/constant/styles_manger.dart';
import 'package:test/features/auth/presentation/cubit/forget_password_cubit.dart';
import 'package:test/l10n/app_localizations.dart';

class ForgetPasswordNewPasswordStep extends StatefulWidget {
  const ForgetPasswordNewPasswordStep({super.key});

  @override
  State<ForgetPasswordNewPasswordStep> createState() => _ForgetPasswordNewPasswordStepState();
}

class _ForgetPasswordNewPasswordStepState extends State<ForgetPasswordNewPasswordStep> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return BlocListener<ForgetPasswordCubit, ForgetPasswordState>(
      listener: (context, state) {
        if (state is ForgetPasswordError) {
          CustomSnackbar.showError(context: context, message: state.message);
        } else if (state is ForgetPasswordSuccess) {
          CustomSnackbar.showSuccess(
            context: context,
            message: CustomSnackbar.getLocalizedMessage(
              context: context,
              messageAr: 'تم تغيير كلمة المرور بنجاح',
              messageEn: 'Password changed successfully',
            ),
          );
          // Navigate back to login after success
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      },
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            
            // Title
            Text(
              l10n.enterNewPassword,
              style: getBoldStyle(
                fontSize: FontSize.size24,
                fontFamily: FontConstant.cairo,
                color: Theme.of(context).textTheme.headlineLarge?.color,
              ),
            ),
            
            const SizedBox(height: 8),
            
            // Description
            Text(
              'Create a strong password for your account',
              style: getMediumStyle(
                fontSize: FontSize.size16,
                fontFamily: FontConstant.cairo,
                color: Colors.grey[600],
              ),
            ),
            
            const SizedBox(height: 40),
            
            // New Password field
            PasswordField(
              controller: _passwordController,
              hintText: l10n.newPassword,
              validator: (value) => FormValidators.validatePassword(value, context),
            ),
            
            const SizedBox(height: 20),
            
            // Confirm Password field
            PasswordField(
              controller: _confirmPasswordController,
              hintText: l10n.confirmNewPassword,
              validator: (value) => FormValidators.validatePasswordConfirmation(
                value,
                _passwordController.text,
                context,
              ),
            ),
            
            const SizedBox(height: 40),
            
            // Change Password button
            BlocBuilder<ForgetPasswordCubit, ForgetPasswordState>(
              builder: (context, state) {
                final isLoading = state is ForgetPasswordLoading;
                
                return CustomButton(
                  text: l10n.changePassword,
                  onPressed: _changePassword,
                  isLoading: isLoading,
                );
              },
            ),
            
            const Spacer(),
            
            // Navigation buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // Go back to OTP step
                      context.read<ForgetPasswordCubit>().sendForgetPasswordRequest(
                        context.read<ForgetPasswordCubit>().currentEmail,
                      );
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
      ),
    );
  }

  void _changePassword() {
    if (_formKey.currentState!.validate()) {
      context.read<ForgetPasswordCubit>().changePassword(
        _passwordController.text.trim(),
        _confirmPasswordController.text.trim(),
      );
    }
  }
}

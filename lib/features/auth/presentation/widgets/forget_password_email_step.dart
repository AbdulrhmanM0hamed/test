import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/core/utils/theme/app_colors.dart';
import 'package:test/core/utils/common/custom_text_field.dart';
import 'package:test/core/utils/common/custom_button.dart';
import 'package:test/core/utils/validators/form_validators_clean.dart';
import 'package:test/core/utils/widgets/custom_snackbar.dart';
import 'package:test/core/utils/constant/font_manger.dart';
import 'package:test/core/utils/constant/styles_manger.dart';
import 'package:test/features/auth/presentation/cubit/forget_password_cubit.dart';
import 'package:test/l10n/app_localizations.dart';

class ForgetPasswordEmailStep extends StatefulWidget {
  const ForgetPasswordEmailStep({super.key});

  @override
  State<ForgetPasswordEmailStep> createState() => _ForgetPasswordEmailStepState();
}

class _ForgetPasswordEmailStepState extends State<ForgetPasswordEmailStep> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return BlocListener<ForgetPasswordCubit, ForgetPasswordState>(
      listener: (context, state) {
        if (state is ForgetPasswordError) {
          CustomSnackbar.showError(context: context, message: state.message);
        } else if (state is ForgetPasswordEmailSent) {
          CustomSnackbar.showSuccess(
            context: context, 
            message: CustomSnackbar.getLocalizedMessage(
              context: context,
              messageAr: 'تم إرسال رمز التحقق إلى بريدك الإلكتروني',
              messageEn: 'Verification code sent to your email',
            ),
          );
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
              l10n.forgetPasswordTitle,
              style: getBoldStyle(
                fontSize: FontSize.size24,
                fontFamily: FontConstant.cairo,
                color: Theme.of(context).textTheme.headlineLarge?.color,
              ),
            ),
            
            const SizedBox(height: 8),
            
            // Description
            Text(
              l10n.forgetPasswordDesc,
              style: getMediumStyle(
                fontSize: FontSize.size16,
                fontFamily: FontConstant.cairo,
                color: Colors.grey[600],
              ),
            ),
            
            const SizedBox(height: 40),
            
            // Email field
            CustomTextField(
              controller: _emailController,
              label: l10n.email,
              hint: l10n.writeEmail,
              keyboardType: TextInputType.emailAddress,
              prefix: const Icon(Icons.email_outlined),
              validator: (value) => FormValidators.validateEmail(value, context),
            ),
            
            const SizedBox(height: 40),
            
            // Send button
            BlocBuilder<ForgetPasswordCubit, ForgetPasswordState>(
              builder: (context, state) {
                final isLoading = state is ForgetPasswordLoading;
                
                return CustomButton(
                  text: l10n.sendVerificationCode,
                  onPressed: _sendVerificationCode,
                  isLoading: isLoading,
                );
              },
            ),
            
            const Spacer(),
            
            // Back to login
            Center(
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  l10n.backToLogin,
                  style: getMediumStyle(
                    fontSize: FontSize.size16,
                    fontFamily: FontConstant.cairo,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _sendVerificationCode() {
    if (_formKey.currentState!.validate()) {
      context.read<ForgetPasswordCubit>().sendForgetPasswordRequest(_emailController.text.trim());
    }
  }
}

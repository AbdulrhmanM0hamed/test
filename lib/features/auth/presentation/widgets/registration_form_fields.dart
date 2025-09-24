import 'package:flutter/material.dart';
import 'package:test/core/utils/common/custom_text_field.dart';
import 'package:test/core/utils/common/password_field.dart';
import 'package:test/core/utils/constant/font_manger.dart';
import 'package:test/core/utils/constant/styles_manger.dart';
import 'package:test/core/utils/validators/form_validators_clean.dart';
import 'package:test/l10n/app_localizations.dart';

class RegistrationFormFields extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final bool obscurePassword;
  final bool obscureConfirmPassword;
  final VoidCallback onPasswordVisibilityToggle;
  final VoidCallback onConfirmPasswordVisibilityToggle;

  const RegistrationFormFields({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.phoneController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.obscurePassword,
    required this.obscureConfirmPassword,
    required this.onPasswordVisibilityToggle,
    required this.onConfirmPasswordVisibilityToggle,
  });

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context)!;

    return Column(
      children: [
        // Name Field
        _buildFieldWithLabel(
          label: s.fullName,
          child: CustomTextField(
            controller: nameController,
            hint: s.enterFullName,
            validator: (value) =>
                FormValidators.validateFullName(value, context),
          ),
        ),
        const SizedBox(height: 16),

        // Email Field
        _buildFieldWithLabel(
          label: s.email,
          child: CustomTextField(
            controller: emailController,
            hint: s.writeEmail,
            keyboardType: TextInputType.emailAddress,
            validator: (value) => FormValidators.validateEmail(value, context),
          ),
        ),
        const SizedBox(height: 16),

        // Phone Field
        _buildFieldWithLabel(
          label: s.phoneNumber,
          child: CustomTextField(
            controller: phoneController,
            hint: s.enterPhoneNumber,
            keyboardType: TextInputType.phone,
            validator: (value) =>
                FormValidators.validatePhoneNumber(value, context),
          ),
        ),
        const SizedBox(height: 16),

        // Password Field
        _buildFieldWithLabel(
          label: s.password,
          child: PasswordField(
            controller: passwordController,
            hint: s.writePassword,

            validator: (value) =>
                FormValidators.validatePassword(value, context),
          ),
        ),
        const SizedBox(height: 16),

        // Confirm Password Field
        _buildFieldWithLabel(
          label: s.confirmPassword,
          child: PasswordField(
            controller: confirmPasswordController,
            hint: s.reEnterPassword,
            validator: (value) => FormValidators.validatePasswordConfirmation(
              value,
              passwordController.text,
              context,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFieldWithLabel({required String label, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: getMediumStyle(
            fontFamily: FontConstant.cairo,
            fontSize: FontSize.size14,
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}

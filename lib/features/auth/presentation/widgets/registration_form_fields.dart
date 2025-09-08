import 'package:flutter/material.dart';
import 'package:test/core/utils/common/custom_text_field.dart';
import 'package:test/core/utils/common/password_field.dart';
import 'package:test/core/utils/constant/font_manger.dart';
import 'package:test/core/utils/constant/styles_manger.dart';
import 'package:test/core/utils/theme/app_colors.dart';
import 'package:test/core/utils/validators/form_validators.dart';
import 'package:test/generated/l10n.dart';

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
    final S s = S.of(context);

    return Column(
      children: [
        // Name Field
        _buildFieldWithLabel(
          label: 'الاسم الكامل',
          child: CustomTextField(
            controller: nameController,
            hint: 'أدخل الاسم الكامل',
            validator: FormValidators.validateName,
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
            validator: FormValidators.validateEmail,
          ),
        ),
        const SizedBox(height: 16),

        // Phone Field
        _buildFieldWithLabel(
          label: 'رقم الهاتف',
          child: CustomTextField(
            controller: phoneController,
            hint: 'أدخل رقم الهاتف',
            keyboardType: TextInputType.phone,
            validator: FormValidators.validatePhone,
          ),
        ),
        const SizedBox(height: 16),

        // Password Field
        _buildFieldWithLabel(
          label: s.password,
          child: PasswordField(
            controller: passwordController,
            hintText: s.writePassword,

            validator: FormValidators.validatePassword,
          ),
        ),
        const SizedBox(height: 16),

        // Confirm Password Field
        _buildFieldWithLabel(
          label: 'تأكيد كلمة المرور',
          child: CustomTextField(
            controller: confirmPasswordController,
            hint: 'أدخل كلمة المرور مرة أخرى',

            validator: (value) => FormValidators.validateConfirmPassword(
              value,
              passwordController.text,
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
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}

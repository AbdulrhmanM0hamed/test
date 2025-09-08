import 'package:flutter/material.dart';
import 'package:test/core/utils/common/custom_text_field.dart';
import 'package:test/core/utils/common/custom_button.dart';
import 'package:test/core/utils/constant/app_assets.dart';
import 'package:test/core/utils/constant/font_manger.dart';
import 'package:test/core/utils/constant/styles_manger.dart';
import 'package:test/core/utils/theme/app_colors.dart';
import 'package:test/core/utils/validators/form_validators.dart';
import 'package:test/features/auth/presentation/widgets/social_auth_button.dart';
import 'package:test/generated/l10n.dart';

class RegisterView extends StatefulWidget {
  static const String routeName = '/register';

  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isLoading = false;
  bool _acceptTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _register() {
    if (_formKey.currentState!.validate() && _acceptTerms) {
      // Implement registration logic here
      setState(() {
        _isLoading = true;
      });

      // Simulating API call
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _isLoading = false;
        });
        // Navigate to home screen after successful registration
        Navigator.pushReplacementNamed(context, '/home');
      });
    } else if (!_acceptTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يرجى الموافقة على الشروط والأحكام'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final S s = S.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // App Logo
                  Center(child: Image.asset(AppAssets.logo, height: 100)),
                  SizedBox(height: size.height * 0.02),

                  // Register Text
                  Text(
                    s.signup,
                    style: getBoldStyle(
                      fontFamily: FontConstant.cairo,
                      fontSize: FontSize.size24,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Welcome Text
                  Text(
                    s.welcomeIn,
                    style: getRegularStyle(
                      fontFamily: FontConstant.cairo,
                      fontSize: FontSize.size16,
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),

                  // Name Field
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        s.name,
                        style: getMediumStyle(
                          fontFamily: FontConstant.cairo,
                          fontSize: FontSize.size14,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      CustomTextField(
                        controller: _nameController,
                        hint: s.writeUsername,
                        validator: FormValidators.validateName,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Email Field
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        s.email,
                        style: getMediumStyle(
                          fontFamily: FontConstant.cairo,
                          fontSize: FontSize.size14,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      CustomTextField(
                        controller: _emailController,
                        hint: s.writeEmail,
                        keyboardType: TextInputType.emailAddress,
                        validator: FormValidators.validateEmail,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Password Field
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        s.password,
                        style: getMediumStyle(
                          fontFamily: FontConstant.cairo,
                          fontSize: FontSize.size14,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      CustomTextField(
                        controller: _passwordController,
                        hint: s.writePassword,
                        obscureText: true,
                        validator: FormValidators.validatePassword,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Confirm Password Field
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        s.ensurePassword,
                        style: getMediumStyle(
                          fontFamily: FontConstant.cairo,
                          fontSize: FontSize.size14,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      CustomTextField(
                        controller: _confirmPasswordController,
                        hint: s.rewritePassword,
                        obscureText: true,
                        validator: (value) =>
                            FormValidators.validateConfirmPassword(
                              value,
                              _passwordController.text,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Terms and Conditions
                  Row(
                    children: [
                      Checkbox(
                        value: _acceptTerms,
                        activeColor: AppColors.primary,
                        onChanged: (value) {
                          setState(() {
                            _acceptTerms = value!;
                          });
                        },
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _acceptTerms = !_acceptTerms;
                            });
                          },
                          child: Text(
                            s.Iagree,
                            style: getRegularStyle(
                              fontFamily: FontConstant.cairo,
                              fontSize: FontSize.size14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Register Button
                  CustomButton(
                    text: s.signup,
                    isLoading: _isLoading,
                    onPressed: _register,
                  ),

                  const SizedBox(height: 24),

                  // OR Divider
                  Row(
                    children: [
                      const Expanded(
                        child: Divider(color: AppColors.border, thickness: 1),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          s.or,
                          style: getRegularStyle(
                            fontFamily: FontConstant.cairo,
                            fontSize: FontSize.size14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                      const Expanded(
                        child: Divider(color: AppColors.border, thickness: 1),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Social Logins
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SocialAuthButton(
                        iconPath: AppAssets.applIcon,
                        onPressed: () {
                          // Implement Apple login
                        },
                      ),
                      const SizedBox(width: 16),
                      SocialAuthButton(
                        iconPath: AppAssets.facebookIcon,
                        onPressed: () {
                          // Implement Facebook login
                        },
                      ),
                      const SizedBox(width: 16),
                      SocialAuthButton(
                        iconPath: AppAssets.googleIcon,
                        onPressed: () {
                          // Implement Google login
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Login Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        s.haveAccount,
                        style: getRegularStyle(
                          fontFamily: FontConstant.cairo,
                          fontSize: FontSize.size14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          s.loginNow,
                          style: getBoldStyle(
                            fontFamily: FontConstant.cairo,
                            fontSize: FontSize.size14,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

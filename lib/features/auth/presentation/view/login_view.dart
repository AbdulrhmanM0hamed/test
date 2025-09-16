import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/core/di/dependency_injection.dart';
import 'package:test/core/utils/common/custom_text_field.dart';
import 'package:test/core/utils/common/custom_button.dart';
import 'package:test/core/utils/constant/app_assets.dart';
import 'package:test/core/utils/constant/font_manger.dart';
import 'package:test/core/utils/constant/styles_manger.dart';
import 'package:test/core/utils/theme/app_colors.dart';
import 'package:test/core/utils/validators/form_validators.dart';
import 'package:test/core/utils/animations/custom_progress_indcator.dart';
import 'package:test/core/utils/widgets/custom_snackbar.dart';
import 'package:test/features/auth/presentation/view/forget_password_view.dart';
import 'package:test/features/auth/presentation/view/register_view.dart';
import 'package:test/features/auth/presentation/widgets/social_auth_button.dart';
import 'package:test/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:test/features/auth/presentation/cubit/auth_state.dart';
import 'package:test/features/home/presentation/view/bottom_nav_bar.dart';
import 'package:test/l10n/app_localizations.dart';
import 'package:test/core/services/app_state_service.dart';

class LoginView extends StatefulWidget {
  static const String routeName = '/login';

  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _loadSavedCredentials() async {
    final appStateService = DependencyInjection.getIt.get<AppStateService>();
    final savedCredentials = appStateService.getSavedCredentials();

    if (savedCredentials['email'] != null &&
        savedCredentials['password'] != null) {
      setState(() {
        _emailController.text = savedCredentials['email']!;
        _passwordController.text = savedCredentials['password']!;
        _rememberMe = appStateService.getRememberMe();
      });
    }
  }

  void _login(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        rememberMe: _rememberMe,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocProvider(
      create: (context) => DependencyInjection.createAuthCubit(),
      child: Builder(
        builder: (context) => Scaffold(
          body: BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {
              print('🔍 LOGIN VIEW STATE CHANGE: ${state.runtimeType}');

              if (state is AuthSuccess) {
                print('🔍 AuthSuccess received');
                CustomSnackbar.showSuccess(
                  context: context,
                  message: state.message,
                );
                Navigator.pushReplacementNamed(context, BottomNavBar.routeName);
              } else if (state is AuthError) {
                print('🔍 AuthError received: ${state.message}');
                CustomSnackbar.showError(
                  context: context,
                  message: state.message,
                );
              } else if (state is EmailNotVerified) {
                print(
                  '🔍 EmailNotVerified received: ${state.email} - ${state.message}',
                );

                // Automatically resend verification email
                context.read<AuthCubit>().resendVerificationEmail(state.email);

                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (dialogContext) => Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 10,
                    backgroundColor: Colors.white,
                    child: Container(
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.white,
                            AppColors.primary.withValues(alpha: 0.02),
                          ],
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Success checkmark icon with animation effect
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.success,
                                  AppColors.success.withValues(alpha: 0.8),
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.success.withValues(
                                    alpha: 0.3,
                                  ),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.check_circle_outline,
                              size: 50,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Title
                          Text(
                            'تم إرسال بريد التفعيل',
                            style: getBoldStyle(
                              fontSize: FontSize.size20,
                              fontFamily: FontConstant.cairo,
                              color: AppColors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),

                          // Message
                          Text(
                            'تم إرسال رابط التفعيل إلى بريدك الإلكتروني\nيرجى التحقق من صندوق الوارد أو الرسائل المهملة',
                            style: getRegularStyle(
                              fontSize: FontSize.size15,
                              fontFamily: FontConstant.cairo,
                              color: AppColors.textSecondary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),

                          // Email display with professional styling
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppColors.primary.withValues(alpha: 0.2),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.email_outlined,
                                  color: AppColors.primary,
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    state.email,
                                    style: getMediumStyle(
                                      fontSize: FontSize.size14,
                                      fontFamily: FontConstant.cairo,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 32),

                          // Cancel button at bottom left
                          Align(
                            alignment: Alignment.centerLeft,
                            child: TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: BorderSide(
                                    color: AppColors.grey.withValues(
                                      alpha: 0.3,
                                    ),
                                    width: 1,
                                  ),
                                ),
                                backgroundColor: Colors.grey.withValues(
                                  alpha: 0.05,
                                ),
                              ),
                              child: Text(
                                AppLocalizations.of(context)!.cancel,
                                style: getMediumStyle(
                                  fontSize: FontSize.size14,
                                  fontFamily: FontConstant.cairo,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              } else if (state is VerificationEmailSentSuccess) {
                print('🔍 VerificationEmailSentSuccess received');
                CustomSnackbar.showSuccess(
                  context: context,
                  message: state.message,
                );
              }
            },
            builder: (context, state) {
              return Stack(
                children: [
                  SafeArea(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // App Logo
                              SizedBox(height: size.height * 0.03),
                              Center(
                                child: Image.asset(AppAssets.logo, height: 165),
                              ),
                              SizedBox(height: size.height * 0.01),

                              // Login Text
                              Text(
                                AppLocalizations.of(context)!.login,
                                style: getBoldStyle(
                                  fontFamily: FontConstant.cairo,
                                  fontSize: FontSize.size24,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(height: 8),

                              // Welcome Text
                              Text(
                                AppLocalizations.of(context)!.welcomeBackDesc,
                                style: getRegularStyle(
                                  fontFamily: FontConstant.cairo,
                                  fontSize: FontSize.size16,
                                  color: AppColors.textSecondary,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 32),

                              // Email/Username Field
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!.email,
                                    style: getMediumStyle(
                                      fontFamily: FontConstant.cairo,
                                      fontSize: FontSize.size14,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  CustomTextField(
                                    controller: _emailController,
                                    hint: AppLocalizations.of(
                                      context,
                                    )!.writeEmail,
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
                                    AppLocalizations.of(context)!.password,
                                    style: getMediumStyle(
                                      fontFamily: FontConstant.cairo,
                                      fontSize: FontSize.size14,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  CustomTextField(
                                    controller: _passwordController,
                                    hint: AppLocalizations.of(
                                      context,
                                    )!.writePassword,
                                    obscureText: true,
                                    validator:
                                        FormValidators.validatePasswordLogin,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),

                              // Remember Me and Forgot Password Row
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // Remember Me Checkbox
                                  Row(
                                    children: [
                                      Checkbox(
                                        value: _rememberMe,
                                        onChanged: (value) {
                                          setState(() {
                                            _rememberMe = value ?? false;
                                          });
                                        },
                                        activeColor: AppColors.primary,
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        AppLocalizations.of(
                                          context,
                                        )!.rememberMe,
                                        style: getRegularStyle(
                                          fontFamily: FontConstant.cairo,
                                          fontSize: FontSize.size14,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                    ],
                                  ),

                                  // Forgot Password
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pushNamed(
                                        context,
                                        ForgetPasswordView.routeName,
                                      );
                                    },
                                    child: Text(
                                      AppLocalizations.of(
                                        context,
                                      )!.forgotPassword,
                                      style: getRegularStyle(
                                        fontFamily: FontConstant.cairo,
                                        fontSize: FontSize.size14,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 24),

                              // Login Button
                              CustomButton(
                                text: AppLocalizations.of(context)!.login,
                                onPressed: () => _login(context),
                              ),

                              const SizedBox(height: 24),

                              // OR Divider
                              Row(
                                children: [
                                  const Expanded(
                                    child: Divider(
                                      color: AppColors.border,
                                      thickness: 1,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                    child: Text(
                                      AppLocalizations.of(context)!.or,
                                      style: getRegularStyle(
                                        fontFamily: FontConstant.cairo,
                                        fontSize: FontSize.size14,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ),
                                  const Expanded(
                                    child: Divider(
                                      color: AppColors.border,
                                      thickness: 1,
                                    ),
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

                              const SizedBox(height: 16),

                              // Register Link
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    AppLocalizations.of(
                                      context,
                                    )!.dontHaveAccount,
                                    style: getRegularStyle(
                                      fontFamily: FontConstant.cairo,
                                      fontSize: FontSize.size14,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pushNamed(
                                        context,
                                        RegisterView.routeName,
                                      );
                                    },
                                    child: Text(
                                      AppLocalizations.of(context)!.signup,
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
                  // Loading overlay
                  if (state is AuthLoading)
                    Container(
                      color: Colors.black.withValues(alpha: 0.3),
                      child: const CustomProgressIndicator(),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

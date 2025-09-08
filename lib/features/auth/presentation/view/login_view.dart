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
import 'package:test/features/auth/presentation/widgets/social_auth_button.dart';
import 'package:test/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:test/features/auth/presentation/cubit/auth_state.dart';
import 'package:test/features/home/presentation/view/bottom_nav_bar.dart';
import 'package:test/generated/l10n.dart';
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
    
    if (savedCredentials['email'] != null && savedCredentials['password'] != null) {
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
    final S s = S.of(context);

    return BlocProvider(
      create: (context) => DependencyInjection.createAuthCubit(),
      child: Builder(
        builder: (context) => Scaffold(
          backgroundColor: Colors.white,
          body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            CustomSnackbar.showSuccess(
              context: context,
              message: state.message,
            );
            Navigator.pushReplacementNamed(context, BottomNavBar.routeName);
          } else if (state is AuthError) {
            CustomSnackbar.showError(context: context, message: state.message);
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
                            child: Image.asset(AppAssets.logo, height: 120),
                          ),
                          SizedBox(height: size.height * 0.03),

                          // Login Text
                          Text(
                            s.login,
                            style: getBoldStyle(
                              fontFamily: FontConstant.cairo,
                              fontSize: FontSize.size24,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 8),

                          // Welcome Text
                          Text(
                            s.welcomeBackDesc,
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
                                validator: FormValidators.validatePasswordLogin,
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Remember Me and Forgot Password Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'تذكرني',
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
                                    '/forgot-password',
                                  );
                                },
                                child: Text(
                                  s.forgotPassword,
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
                            text: s.login,
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
                                  s.or,
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

                          const SizedBox(height: 32),

                          // Register Link
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                s.dontHaveAccount,
                                style: getRegularStyle(
                                  fontFamily: FontConstant.cairo,
                                  fontSize: FontSize.size14,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/register');
                                },
                                child: Text(
                                  s.signup,
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

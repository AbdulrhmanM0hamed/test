import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/core/di/dependency_injection.dart';
import 'package:test/core/utils/common/custom_button.dart';
import 'package:test/core/utils/constant/app_assets.dart';
import 'package:test/core/utils/constant/font_manger.dart';
import 'package:test/core/utils/constant/styles_manger.dart';
import 'package:test/core/utils/theme/app_colors.dart';
import 'package:test/core/utils/animations/custom_progress_indcator.dart';
import 'package:test/core/utils/widgets/custom_snackbar.dart';
import 'package:test/features/auth/presentation/cubit/registration_cubit.dart';
import 'package:test/features/auth/presentation/cubit/registration_state.dart';
import 'package:test/features/auth/presentation/widgets/registration_form_fields.dart';
import 'package:test/features/auth/presentation/widgets/registration_personal_info.dart';
import 'package:test/features/auth/presentation/widgets/registration_location_selector.dart';
import 'package:test/features/auth/presentation/widgets/registration_terms_checkbox.dart';
import 'package:test/features/auth/presentation/widgets/social_auth_button.dart';
import 'package:test/features/profile/domain/entities/country.dart';
import 'package:test/features/profile/domain/entities/city.dart';
import 'package:test/features/profile/domain/entities/region.dart';
import 'package:test/l10n/app_localizations.dart';

class RegisterView extends StatefulWidget {
  static const String routeName = '/register';

  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptTerms = false;
  DateTime? _selectedBirthDate;
  String? _selectedGender;
  Country? _selectedCountry;
  City? _selectedCity;
  Region? _selectedRegion;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _selectBirthDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(
        const Duration(days: 6570),
      ), // 18 years ago
      firstDate: DateTime(1950),
      lastDate: DateTime.now().subtract(
        const Duration(days: 4380),
      ), // 12 years ago
    );

    if (picked != null && picked != _selectedBirthDate) {
      setState(() {
        _selectedBirthDate = picked;
      });
    }
  }

  void _register(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      if (!_acceptTerms) {
        CustomSnackbar.showError(
          context: context,
          message: AppLocalizations.of(context)!.acceptTermsRequired,
        );
        return;
      }

      if (_selectedBirthDate == null) {
        CustomSnackbar.showError(
          context: context,
          message: AppLocalizations.of(context)!.birthdateRequired,
        );
        return;
      }

      if (_selectedGender == null) {
        CustomSnackbar.showError(
          context: context,
          message: AppLocalizations.of(context)!.genderRequired,
        );
        return;
      }

      if (_selectedCountry == null) {
        CustomSnackbar.showError(
          context: context,
          message: AppLocalizations.of(context)!.countryRequired,
        );
        return;
      }

      if (_selectedCity == null) {
        CustomSnackbar.showError(
          context: context,
          message: AppLocalizations.of(context)!.cityRequired,
        );
        return;
      }

      if (_selectedRegion == null) {
        CustomSnackbar.showError(
          context: context,
          message: AppLocalizations.of(context)!.regionRequired,
        );
        return;
      }

      context.read<RegistrationCubit>().register(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        password: _passwordController.text.trim(),
        confirmPassword: _confirmPasswordController.text.trim(),
        birthDate: _selectedBirthDate!,
        gender: _selectedGender!,
        country: _selectedCountry!,
        city: _selectedCity,
        region: _selectedRegion,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final s = AppLocalizations.of(context);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => DependencyInjection.createRegistrationCubit(),
        ),
        BlocProvider(
          create: (context) =>
              DependencyInjection.createLocationCubit()..getCountries(),
        ),
      ],
      child: Builder(
        builder: (context) => Scaffold(
          body: BlocConsumer<RegistrationCubit, RegistrationState>(
            listener: (context, state) {
              if (state is RegistrationSuccess) {
                CustomSnackbar.showSuccess(
                  context: context,
                  message:
                      state.message ??
                      s?.accountCreatedSuccessfully ??
                      'Account created successfully',
                );
                Navigator.pushReplacementNamed(context, '/login');
              } else if (state is RegistrationError) {
                CustomSnackbar.showError(
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
                              SizedBox(height: size.height * 0.02),
                              Center(
                                child: Image.asset(AppAssets.logo, height: 165),
                              ),
                              SizedBox(height: size.height * 0.01),

                              // Register Text
                              Text(
                                s!.signup,
                                style: getBoldStyle(
                                  fontFamily: FontConstant.cairo,
                                  fontSize: FontSize.size24,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(height: 8),

                              // Welcome Text
                              Text(
                                s.createYourAccount,
                                style: getRegularStyle(
                                  fontFamily: FontConstant.cairo,
                                  fontSize: FontSize.size16,
                                  color: AppColors.textSecondary,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 24),

                              // Form Fields
                              RegistrationFormFields(
                                nameController: _nameController,
                                emailController: _emailController,
                                phoneController: _phoneController,
                                passwordController: _passwordController,
                                confirmPasswordController:
                                    _confirmPasswordController,
                                obscurePassword: _obscurePassword,
                                obscureConfirmPassword: _obscureConfirmPassword,
                                onPasswordVisibilityToggle: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                                onConfirmPasswordVisibilityToggle: () {
                                  setState(() {
                                    _obscureConfirmPassword =
                                        !_obscureConfirmPassword;
                                  });
                                },
                              ),
                              const SizedBox(height: 16),

                              // Personal Info
                              RegistrationPersonalInfo(
                                selectedBirthDate: _selectedBirthDate,
                                selectedGender: _selectedGender,
                                onBirthDateTap: _selectBirthDate,
                                onGenderSelected: (gender) {
                                  setState(() {
                                    _selectedGender = gender;
                                  });
                                },
                              ),
                              const SizedBox(height: 16),

                              // Location Selector
                              RegistrationLocationSelector(
                                selectedCountry: _selectedCountry,
                                selectedCity: _selectedCity,
                                selectedRegion: _selectedRegion,
                                onCountrySelected: (country) {
                                  setState(() {
                                    _selectedCountry = country;
                                    _selectedCity = null;
                                    _selectedRegion = null;
                                  });
                                },
                                onCitySelected: (city) {
                                  setState(() {
                                    _selectedCity = city;
                                    _selectedRegion = null;
                                  });
                                },
                                onRegionSelected: (region) {
                                  setState(() {
                                    _selectedRegion = region;
                                  });
                                },
                              ),
                              const SizedBox(height: 16),

                              // Terms Checkbox
                              RegistrationTermsCheckbox(
                                acceptTerms: _acceptTerms,
                                onChanged: (value) {
                                  setState(() {
                                    _acceptTerms = value ?? false;
                                  });
                                },
                              ),
                              const SizedBox(height: 24),

                              // Register Button
                              CustomButton(
                                text: s.signup,
                                onPressed: () => _register(context),
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
                              const SizedBox(height: 16),

                              // Login Link
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    s.alreadyHaveAccount,
                                    style: getRegularStyle(
                                      fontFamily: FontConstant.cairo,
                                      fontSize: FontSize.size14,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pushReplacementNamed(
                                        context,
                                        '/login',
                                      );
                                    },
                                    child: Text(
                                      s.login,
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
                  if (state is RegistrationLoading)
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

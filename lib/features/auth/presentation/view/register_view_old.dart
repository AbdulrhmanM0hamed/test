// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:test/core/di/dependency_injection.dart';
// import 'package:test/core/utils/common/custom_button.dart';
// import 'package:test/core/utils/constant/app_assets.dart';
// import 'package:test/core/utils/constant/font_manger.dart';
// import 'package:test/core/utils/constant/styles_manger.dart';
// import 'package:test/core/utils/theme/app_colors.dart';
// import 'package:test/core/utils/animations/custom_progress_indcator.dart';
// import 'package:test/core/utils/validators/form_validators.dart';
// import 'package:test/core/utils/widgets/custom_snackbar.dart';
// import 'package:test/features/auth/presentation/cubit/registration_cubit.dart';
// import 'package:test/features/auth/presentation/cubit/registration_state.dart';
// import 'package:test/features/auth/presentation/cubit/location_cubit.dart';
// import 'package:test/features/auth/presentation/widgets/country_selector.dart';
// import 'package:test/features/auth/presentation/widgets/professional_form_field.dart';
// import 'package:test/features/auth/presentation/widgets/registration_form_fields.dart';
// import 'package:test/features/auth/presentation/widgets/registration_personal_info.dart';
// import 'package:test/features/auth/presentation/widgets/registration_location_selector.dart';
// import 'package:test/features/auth/presentation/widgets/registration_terms_checkbox.dart';
// import 'package:test/features/auth/presentation/widgets/social_auth_button.dart';
// import 'package:test/features/profile/data/models/country_model.dart';
// import 'package:test/features/profile/domain/entities/country.dart';
// import 'package:test/features/profile/domain/entities/city.dart';
// import 'package:test/features/profile/domain/entities/region.dart';
// import 'package:test/generated/l10n.dart';

// class RegisterView extends StatefulWidget {
//   static const String routeName = '/register';

//   const RegisterView({super.key});

//   @override
//   State<RegisterView> createState() => _RegisterViewState();
// }

// class _RegisterViewState extends State<RegisterView> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _phoneController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _confirmPasswordController =
//       TextEditingController();
  
//   bool _isLoading = false;
//   bool _acceptTerms = false;
//   bool _obscurePassword = true;
//   bool _obscureConfirmPassword = true;
//   String? _selectedCountry;
//   String _selectedGender = 'male';
//   DateTime? _selectedBirthDate;
//   Country? _selectedCountryObj;
//   City? _selectedCity;
//   Region? _selectedRegion;

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _emailController.dispose();
//     _phoneController.dispose();
//     _passwordController.dispose();
//     _confirmPasswordController.dispose();
//     super.dispose();
//   }

//   void _register() {
//     final cubit = context.read<RegistrationCubit>();
//     if (_formKey.currentState!.validate() &&
//         _acceptTerms &&
//         _selectedCountryObj != null) {
//       cubit.signup(
//         name: _nameController.text.trim(),
//         email: _emailController.text.trim(),
//         phone: _phoneController.text.trim(),
//         birthDate: _selectedBirthDate?.toIso8601String().split('T')[0] ?? '',
//         gender: _selectedGender,
//         password: _passwordController.text,
//         confirmPassword: _confirmPasswordController.text,
//       );
//     } else if (!_acceptTerms) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('يرجى الموافقة على الشروط والأحكام'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     } else if (_selectedCountryObj == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('يرجى اختيار الدولة'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }

//   void _selectBirthDate() async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: _selectedBirthDate ?? DateTime(2000),
//       firstDate: DateTime(1950),
//       lastDate: DateTime.now().subtract(const Duration(days: 365 * 13)),
//       builder: (context, child) {
//         return Theme(
//           data: Theme.of(context).copyWith(
//             colorScheme: Theme.of(
//               context,
//             ).colorScheme.copyWith(primary: AppColors.primary),
//           ),
//           child: child!,
//         );
//       },
//     );
//     if (picked != null && picked != _selectedBirthDate) {
//       setState(() {
//         _selectedBirthDate = picked;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider<RegistrationCubit>(
//       create: (_) =>
//           DependencyInjection.getIt<RegistrationCubit>()..loadCountries(),
//       child: BlocConsumer<RegistrationCubit, RegistrationState>(
//         listener: (context, state) {
//           if (state is RegistrationLoading) {
//             setState(() => _isLoading = true);
//           } else {
//             setState(() => _isLoading = false);
//           }
//           if (state is RegistrationSuccess) {
//             Navigator.pushReplacementNamed(context, '/home');
//           } else if (state is RegistrationError) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text(state.message),
//                 backgroundColor: Colors.red,
//               ),
//             );
//           }
//         },
//         builder: (context, state) {
//           final cubit = context.read<RegistrationCubit>();
//           final S s = S.of(context);

//           return Scaffold(
//             backgroundColor: Colors.grey[50],
//             body: SafeArea(
//               child: SingleChildScrollView(
//                 child: Padding(
//                   padding: const EdgeInsets.all(24.0),
//                   child: Form(
//                     key: _formKey,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.stretch,
//                       children: [
//                         // Header Section
//                         Container(
//                           padding: const EdgeInsets.symmetric(vertical: 32),
//                           child: Column(
//                             children: [
//                               // App Logo with animation
//                               Hero(
//                                 tag: 'app_logo',
//                                 child: Container(
//                                   width: 120,
//                                   height: 120,
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(24),
//                                     boxShadow: [
//                                       BoxShadow(
//                                         color: AppColors.primary.withOpacity(
//                                           0.2,
//                                         ),
//                                         blurRadius: 20,
//                                         offset: const Offset(0, 10),
//                                       ),
//                                     ],
//                                   ),
//                                   child: ClipRRect(
//                                     borderRadius: BorderRadius.circular(24),
//                                     child: Image.asset(
//                                       AppAssets.logo,
//                                       fit: BoxFit.cover,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               const SizedBox(height: 24),
                              
//                               // Welcome Text
//                               Text(
//                                 s.signup,
//                                 style: getBoldStyle(
//                                   fontFamily: FontConstant.cairo,
//                                   fontSize: FontSize.size24,
//                                   color: AppColors.primary,
//                                 ),
//                               ),
//                               const SizedBox(height: 8),
//                               Text(
//                                 s.welcomeIn,
//                                 style: getRegularStyle(
//                                   fontFamily: FontConstant.cairo,
//                                   fontSize: FontSize.size16,
//                                   color: AppColors.textSecondary,
//                                 ),
//                                 textAlign: TextAlign.center,
//                               ),
//                             ],
//                           ),
//                         ),

//                         // Form Section
//                         Container(
//                           padding: const EdgeInsets.all(24),
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(20),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.black.withOpacity(0.05),
//                                 blurRadius: 20,
//                                 offset: const Offset(0, 5),
//                               ),
//                             ],
//                           ),
//                           child: Column(
//                             children: [
//                               // Name Field
//                               ProfessionalFormField(
//                                 controller: _nameController,
//                                 label: s.name,
//                                 hint: s.writeUsername,
//                                 prefixIcon: Icons.person_outline,
//                                 validator: FormValidators.validateName,
//                               ),
//                               const SizedBox(height: 20),

//                               // Email Field
//                               ProfessionalFormField(
//                                 controller: _emailController,
//                                 label: s.email,
//                                 hint: s.writeEmail,
//                                 prefixIcon: Icons.email_outlined,
//                                 keyboardType: TextInputType.emailAddress,
//                                 validator: FormValidators.validateEmail,
//                               ),
//                               const SizedBox(height: 20),

//                               // Phone Field
//                               ProfessionalFormField(
//                                 controller: _phoneController,
//                                 label: 'رقم الهاتف',
//                                 hint: 'أدخل رقم الهاتف',
//                                 prefixIcon: Icons.phone_outlined,
//                                 keyboardType: TextInputType.phone,
//                                 // inputFormatters: [
//                                 //   FilteringTextInputFormatter.digitsOnly,
//                                 // ],
//                                 validator: (value) {
//                                   if (value == null || value.isEmpty) {
//                                     return 'يرجى إدخال رقم الهاتف';
//                                   }
//                                   if (value.length < 10) {
//                                     return 'رقم الهاتف يجب أن يكون 10 أرقام على الأقل';
//                                   }
//                                   return null;
//                                 },
//                               ),
//                               const SizedBox(height: 20),

//                               // Birth Date Field
//                               GestureDetector(
//                                 onTap: _selectBirthDate,
//                                 child: Container(
//                                   padding: const EdgeInsets.all(16),
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(12),
//                                     border: Border.all(color: AppColors.border),
//                                     color: Colors.white,
//                                   ),
//                                   child: Row(
//                                     children: [
//                                       Icon(
//                                         Icons.calendar_today_outlined,
//                                         color: AppColors.textSecondary,
//                                       ),
//                                       const SizedBox(width: 12),
//                                       Expanded(
//                                         child: Text(
//                                           _selectedBirthDate != null
//                                               ? '${_selectedBirthDate!.day}/${_selectedBirthDate!.month}/${_selectedBirthDate!.year}'
//                                               : 'تاريخ الميلاد',
//                                           style: getRegularStyle(
//                                             fontFamily: FontConstant.cairo,
//                                             fontSize: FontSize.size16,
//                                             color: _selectedBirthDate != null
//                                                 ? AppColors.textPrimary
//                                                 : AppColors.textSecondary,
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                               const SizedBox(height: 20),

//                               // Gender Selection
//                               Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     'الجنس',
//                                     style: getMediumStyle(
//                                       fontFamily: FontConstant.cairo,
//                                       fontSize: FontSize.size14,
//                                       color: AppColors.textPrimary,
//                                     ),
//                                   ),
//                                   const SizedBox(height: 8),
//                                   Row(
//                                     children: [
//                                       Expanded(
//                                         child: GestureDetector(
//                                           onTap: () => setState(
//                                             () => _selectedGender = 'male',
//                                           ),
//                                           child: Container(
//                                             padding: const EdgeInsets.all(16),
//                                             decoration: BoxDecoration(
//                                               borderRadius:
//                                                   BorderRadius.circular(12),
//                                               border: Border.all(
//                                                 color: _selectedGender == 'male'
//                                                     ? AppColors.primary
//                                                     : AppColors.border,
//                                                 width: _selectedGender == 'male'
//                                                     ? 2
//                                                     : 1,
//                                               ),
//                                               color: _selectedGender == 'male'
//                                                   ? AppColors.primary
//                                                         .withOpacity(0.05)
//                                                   : Colors.white,
//                                             ),
//                                             child: Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment.center,
//                                               children: [
//                                                 Icon(
//                                                   Icons.male,
//                                                   color:
//                                                       _selectedGender == 'male'
//                                                       ? AppColors.primary
//                                                       : AppColors.textSecondary,
//                                                 ),
//                                                 const SizedBox(width: 8),
//                                                 Text(
//                                                   'ذكر',
//                                                   style: getMediumStyle(
//                                                     fontFamily:
//                                                         FontConstant.cairo,
//                                                     fontSize: FontSize.size14,
//                                                     color:
//                                                         _selectedGender ==
//                                                             'male'
//                                                         ? AppColors.primary
//                                                         : AppColors.textPrimary,
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                       const SizedBox(width: 12),
//                                       Expanded(
//                                         child: GestureDetector(
//                                           onTap: () => setState(
//                                             () => _selectedGender = 'female',
//                                           ),
//                                           child: Container(
//                                             padding: const EdgeInsets.all(16),
//                                             decoration: BoxDecoration(
//                                               borderRadius:
//                                                   BorderRadius.circular(12),
//                                               border: Border.all(
//                                                 color:
//                                                     _selectedGender == 'female'
//                                                     ? AppColors.primary
//                                                     : AppColors.border,
//                                                 width:
//                                                     _selectedGender == 'female'
//                                                     ? 2
//                                                     : 1,
//                                               ),
//                                               color: _selectedGender == 'female'
//                                                   ? AppColors.primary
//                                                         .withOpacity(0.05)
//                                                   : Colors.white,
//                                             ),
//                                             child: Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment.center,
//                                               children: [
//                                                 Icon(
//                                                   Icons.female,
//                                                   color:
//                                                       _selectedGender ==
//                                                           'female'
//                                                       ? AppColors.primary
//                                                       : AppColors.textSecondary,
//                                                 ),
//                                                 const SizedBox(width: 8),
//                                                 Text(
//                                                   'أنثى',
//                                                   style: getMediumStyle(
//                                                     fontFamily:
//                                                         FontConstant.cairo,
//                                                     fontSize: FontSize.size14,
//                                                     color:
//                                                         _selectedGender ==
//                                                             'female'
//                                                         ? AppColors.primary
//                                                         : AppColors.textPrimary,
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                               const SizedBox(height: 20),

//                               // Country Selection
//                               CountrySelector(
//                                 selectedCountry: _selectedCountry,
//                                 onCountrySelected: (country) {
//                                   setState(() {
//                                     _selectedCountry = country;
//                                     // Set the country object based on selection
//                                     if (country == 'egypt') {
//                                       _selectedCountryObj = CountryModel(
//                                         status: '',
//                                         id: 1,
//                                         titleEn: 'Egypt',
//                                         titleAr: 'مصر',
//                                         currency: 'EGP',
//                                         currencyAr: 'جنيه مصري',
//                                         shortcut: 'EG',
//                                         code: '+20',
//                                         image: 'assets/images/egypt.svg',
//                                       );
//                                     } else if (country == 'saudi') {
//                                       _selectedCountryObj = CountryModel(
//                                         status: '',
//                                         id: 2,
//                                         titleEn: 'Saudi Arabia',
//                                         titleAr: 'السعودية',
//                                         currency: 'SAR',
//                                         currencyAr: 'ريال سعودي',
//                                         shortcut: 'SA',
//                                         code: '+966',
//                                         image: 'assets/images/suidi.svg',
//                                       );
//                                     }
//                                   });
//                                 },
//                               ),
//                               const SizedBox(height: 20),

//                               // Password Field
//                               ProfessionalFormField(
//                                 controller: _passwordController,
//                                 label: s.password,
//                                 hint: s.writePassword,
//                                 prefixIcon: Icons.lock_outline,
//                                 suffixIcon: _obscurePassword
//                                     ? Icons.visibility_off_outlined
//                                     : Icons.visibility_outlined,
//                                 obscureText: _obscurePassword,
//                                 onSuffixTap: () => setState(
//                                   () => _obscurePassword = !_obscurePassword,
//                                 ),
//                                 validator: FormValidators.validatePassword,
//                               ),
//                               const SizedBox(height: 20),

//                               // Confirm Password Field
//                               ProfessionalFormField(
//                                 controller: _confirmPasswordController,
//                                 label: s.ensurePassword,
//                                 hint: s.rewritePassword,
//                                 prefixIcon: Icons.lock_outline,
//                                 suffixIcon: _obscureConfirmPassword
//                                     ? Icons.visibility_off_outlined
//                                     : Icons.visibility_outlined,
//                                 obscureText: _obscureConfirmPassword,
//                                 onSuffixTap: () => setState(
//                                   () => _obscureConfirmPassword =
//                                       !_obscureConfirmPassword,
//                                 ),
//                                 validator: (value) =>
//                                     FormValidators.validateConfirmPassword(
//                                       value,
//                                       _passwordController.text,
//                                     ),
//                               ),
//                               const SizedBox(height: 24),

//                               // Terms and Conditions
//                               Container(
//                                 padding: const EdgeInsets.all(16),
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(12),
//                                   color: Colors.grey[50],
//                                 ),
//                                 child: Row(
//                                   children: [
//                                     Transform.scale(
//                                       scale: 1.2,
//                                       child: Checkbox(
//                                         value: _acceptTerms,
//                                         activeColor: AppColors.primary,
//                                         shape: RoundedRectangleBorder(
//                                           borderRadius: BorderRadius.circular(
//                                             4,
//                                           ),
//                                         ),
//                                         onChanged: (value) {
//                                           setState(() {
//                                             _acceptTerms = value!;
//                                           });
//                                         },
//                                       ),
//                                     ),
//                                     Expanded(
//                                       child: GestureDetector(
//                                         onTap: () {
//                                           setState(() {
//                                             _acceptTerms = !_acceptTerms;
//                                           });
//                                         },
//                                         child: Text(
//                                           s.Iagree,
//                                           style: getRegularStyle(
//                                             fontFamily: FontConstant.cairo,
//                                             fontSize: FontSize.size14,
//                                             color: AppColors.textPrimary,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               const SizedBox(height: 32),

//                               // Register Button
//                               Container(
//                                 width: double.infinity,
//                                 height: 56,
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(16),
//                                   gradient: LinearGradient(
//                                     colors: [
//                                       AppColors.primary,
//                                       AppColors.primary.withOpacity(0.8),
//                                     ],
//                                   ),
//                                   boxShadow: [
//                                     BoxShadow(
//                                       color: AppColors.primary.withOpacity(0.3),
//                                       blurRadius: 12,
//                                       offset: const Offset(0, 6),
//                                     ),
//                                   ],
//                                 ),
//                                 child: Material(
//                                   color: Colors.transparent,
//                                   child: InkWell(
//                                     borderRadius: BorderRadius.circular(16),
//                                     onTap: _isLoading ? null : _register,
//                                     child: Center(
//                                       child: _isLoading
//                                           ? const SizedBox(
//                                               width: 24,
//                                               height: 24,
//                                               child: CircularProgressIndicator(
//                                                 color: Colors.white,
//                                                 strokeWidth: 2,
//                                               ),
//                                             )
//                                           : Text(
//                                               s.signup,
//                                               style: getBoldStyle(
//                                                 fontFamily: FontConstant.cairo,
//                                                 fontSize: FontSize.size18,
//                                                 color: Colors.white,
//                                               ),
//                                             ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),

//                         const SizedBox(height: 32),

//                         // Social Login Section
//                         Container(
//                           padding: const EdgeInsets.all(24),
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(20),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.black.withOpacity(0.05),
//                                 blurRadius: 20,
//                                 offset: const Offset(0, 5),
//                               ),
//                             ],
//                           ),
//                           child: Column(
//                             children: [
//                               // OR Divider
//                               Row(
//                                 children: [
//                                   const Expanded(
//                                     child: Divider(
//                                       color: AppColors.border,
//                                       thickness: 1,
//                                     ),
//                                   ),
//                                   Padding(
//                                     padding: const EdgeInsets.symmetric(
//                                       horizontal: 16,
//                                     ),
//                                     child: Text(
//                                       s.or,
//                                       style: getRegularStyle(
//                                         fontFamily: FontConstant.cairo,
//                                         fontSize: FontSize.size14,
//                                         color: AppColors.textSecondary,
//                                       ),
//                                     ),
//                                   ),
//                                   const Expanded(
//                                     child: Divider(
//                                       color: AppColors.border,
//                                       thickness: 1,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               const SizedBox(height: 24),

//                               // Social Logins
//                               Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceEvenly,
//                                 children: [
//                                   SocialAuthButton(
//                                     iconPath: AppAssets.applIcon,
//                                     onPressed: () {
//                                       // Implement Apple login
//                                     },
//                                   ),
//                                   SocialAuthButton(
//                                     iconPath: AppAssets.facebookIcon,
//                                     onPressed: () {
//                                       // Implement Facebook login
//                                     },
//                                   ),
//                                   SocialAuthButton(
//                                     iconPath: AppAssets.googleIcon,
//                                     onPressed: () {
//                                       // Implement Google login
//                                     },
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),

//                         const SizedBox(height: 32),

//                         // Login Link
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Text(
//                               s.haveAccount,
//                               style: getRegularStyle(
//                                 fontFamily: FontConstant.cairo,
//                                 fontSize: FontSize.size16,
//                                 color: AppColors.textSecondary,
//                               ),
//                             ),
//                             TextButton(
//                               onPressed: () {
//                                 Navigator.pop(context);
//                               },
//                               child: Text(
//                                 s.loginNow,
//                                 style: getBoldStyle(
//                                   fontFamily: FontConstant.cairo,
//                                   fontSize: FontSize.size16,
//                                   color: AppColors.primary,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 32),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

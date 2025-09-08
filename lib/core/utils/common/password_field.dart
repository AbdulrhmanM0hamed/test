import 'package:test/core/utils/theme/app_colors.dart';
import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  const PasswordField({
    super.key,
    required this.hintText,
    this.validator,
    this.controller,
    this.onSaved,
  });

  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final String hintText;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _isObscure,
      validator: widget.validator,
      onSaved: widget.onSaved,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        prefixIcon: const Icon(Icons.lock),
        labelText: widget.hintText,
        suffixIcon: IconButton(
          icon: Icon(_isObscure ? Icons.visibility_off : Icons.visibility),
          onPressed: () {
            setState(() {
              _isObscure = !_isObscure;
            });
          },
        ),
      ),
    );
  }
}


// Authentication endpoints
// Route::post('/register', [RegisteredUserController::class, 'register'])
//     ->name('register');

// Route::post('/login', [AuthenticatedSessionController::class, 'store'])
//     ->name('login');

// Route::get('/statistics', [StatisticsController::class, 'stats'])->name('api.statistics');

// Route::get('/home-page-best-shops', [HomePageBestShops::class, '


// Route::post('/logout', [AuthenticatedSessionController::class, 'destroy'])
//     ->middleware('auth')
//     ->name('logout')


//   "message": "لقد قمت بتسجيل الدخول بالفعل.",

    // "user": {
    //     "id": 1,
    //     "avatar_url": "01JHP7P8PWM1TPM5350FZBRKYR.jpg",
    //     "name": "super admin",
    //     "address": null,
    //     "phone": null,
    //     "email": "super@gmail.com",
    //     "email_verified_at": null,
    //     "created_at": "2025-01-15T21:41:54.000000Z",
    //     "updated_at": "2025-01-16T00:19:56.000000Z",
    //     "is_active": 1,
    //     "state_id": null,
    //     "city_id": null
    // }


    //     "success": true,
    // "data": {
    //     "happyClients": 24,
    //     "services": 63,
    //     "fashionHouses": 10,
    //     "beautySalons": 0

    // }

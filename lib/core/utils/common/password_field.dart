import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final Widget? prefix;
  final bool readOnly;
  final VoidCallback? onTap;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLines;
  final int? maxLength;
  final TextDirection? textDirection;
  final bool? enabled;
  final TextAlign textAlign;
  final String? initialValue;
  final FocusNode? focusNode;
  final Color? fillColor;
  final void Function(String?)? onSaved;
  final bool showToggleIcon;

  const PasswordField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.validator,
    this.keyboardType,
    this.onChanged,
    this.onSubmitted,
    this.prefix,
    this.readOnly = false,
    this.onTap,
    this.inputFormatters,
    this.maxLines = 1,
    this.maxLength,
    this.textDirection,
    this.enabled,
    this.textAlign = TextAlign.start,
    this.initialValue,
    this.focusNode,
    this.fillColor,
    this.onSaved,
    this.showToggleIcon = true,
  });

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      initialValue: widget.initialValue,
      focusNode: widget.focusNode,
      obscureText: _obscureText,
      keyboardType: widget.keyboardType,
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onSubmitted,
      readOnly: widget.readOnly,
      onTap: widget.onTap,
      inputFormatters: widget.inputFormatters,
      maxLines: widget.maxLines,
      maxLength: widget.maxLength,
      textDirection: widget.textDirection,
      enabled: widget.enabled,
      textAlign: widget.textAlign,
      validator: widget.validator,
      onSaved: widget.onSaved,
      style: Theme.of(context).textTheme.bodyMedium,
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hint,
        prefixIcon: widget.prefix ?? const Icon(Icons.lock_outline),
        suffixIcon: widget.showToggleIcon
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  color: Theme.of(context).hintColor,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
            : null,
        filled: true,
        fillColor: widget.fillColor ?? Colors.transparent,
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

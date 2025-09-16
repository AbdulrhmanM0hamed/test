import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/features/auth/presentation/cubit/auth_state.dart';
import 'package:test/l10n/app_localizations.dart';
import '../../../../core/utils/constant/font_manger.dart';
import '../../../../core/utils/constant/styles_manger.dart';
import '../../../../core/utils/theme/app_colors.dart';
import '../cubit/auth_cubit.dart';

class EmailVerificationDialog extends StatelessWidget {
  final String email;
  final AuthCubit? authCubit;

  const EmailVerificationDialog({
    super.key,
    required this.email,
    this.authCubit,
  });

  static Future<void> show(BuildContext context, String email) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return EmailVerificationDialog(email: email);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return BlocProvider.value(
      value: authCubit ?? context.read<AuthCubit>(),
      child: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is VerificationEmailSentSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(localizations.verificationEmailSent),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          contentPadding: const EdgeInsets.all(24),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Email verification icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.email_outlined,
                  size: 40,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 20),

              // Title
              Text(
                localizations.emailVerificationRequired,
                style: getBoldStyle(
                  fontSize: FontSize.size18,
                  fontFamily: FontConstant.cairo,
                  color: AppColors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),

              // Message
              Text(
                localizations.emailNotVerifiedMessage,
                style: getRegularStyle(
                  fontSize: FontSize.size14,
                  fontFamily: FontConstant.cairo,
                  color: AppColors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),

              // Email display
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.grey.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  email,
                  style: getMediumStyle(
                    fontSize: FontSize.size14,
                    fontFamily: FontConstant.cairo,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Buttons
              Row(
                children: [
                  // Cancel button
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(
                            color: AppColors.grey.withValues(alpha: 0.3),
                          ),
                        ),
                      ),
                      child: Text(
                        localizations.cancel,
                        style: getMediumStyle(
                          fontSize: FontSize.size14,
                          fontFamily: FontConstant.cairo,
                          color: AppColors.grey,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Resend button
                  Expanded(
                    child: BlocBuilder<AuthCubit, AuthState>(
                      builder: (context, state) {
                        final isLoading = state is AuthLoading;

                        return ElevatedButton(
                          onPressed: isLoading
                              ? null
                              : () => context
                                    .read<AuthCubit>()
                                    .resendVerificationEmail(email),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: isLoading
                              ? SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      AppColors.white,
                                    ),
                                  ),
                                )
                              : Text(
                                  localizations.resendVerificationEmail,
                                  style: getMediumStyle(
                                    fontSize: FontSize.size14,
                                    fontFamily: FontConstant.cairo,
                                    color: AppColors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

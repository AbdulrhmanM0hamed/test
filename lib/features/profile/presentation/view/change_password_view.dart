import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/core/services/profile_refresh_service.dart';
import 'package:test/core/utils/animations/custom_progress_indcator.dart';
import 'package:test/core/utils/common/custom_app_bar.dart';
import 'package:test/core/utils/common/custom_button.dart';
import 'package:test/core/utils/common/password_field.dart';
import 'package:test/core/utils/validators/form_validators_clean.dart';
import 'package:test/core/utils/widgets/custom_snackbar.dart';
import 'package:test/features/profile/domain/entities/update_profile_request.dart';
import 'package:test/features/profile/domain/entities/user_profile.dart';
import 'package:test/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:test/features/profile/presentation/cubit/profile_state.dart';
import 'package:test/l10n/l10n.dart';

class ChangePasswordView extends StatefulWidget {
  final UserProfile userProfile;

  const ChangePasswordView({super.key, required this.userProfile});

  @override
  State<ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: context.l10n.changePassword),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileError) {
            CustomSnackbar.showError(context: context, message: state.message);
          } else if (state is ProfileUpdated) {
            CustomSnackbar.showSuccess(
              context: context,
              message: context.l10n.passwordChangedSuccessfully,
            );
            // إشعار جميع الصفحات بتحديث البروفايل
            ProfileRefreshService().notifyProfileUpdated();
            Navigator.of(context).pop();
          }
        },
        builder: (context, state) {
          final isLoading = state is ProfileUpdating;

          return Stack(
            children: [
              Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Info Card
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.red[200]!),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.security, color: Colors.red[600]),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                context.l10n.passwordUpdateTip,
                                style: TextStyle(
                                  color: Colors.red[700],
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Current Password
                      Text(
                        context.l10n.currentPasswordLabel,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 8),
                      PasswordField(
                        hint: context.l10n.currentPasswordHint,
                        controller: _oldPasswordController,
                        validator: (value) =>
                            FormValidators.validatePassword(value, context),
                      ),
                      const SizedBox(height: 24),

                      // New Password
                      Text(
                        context.l10n.newPasswordLabel,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 8),
                      PasswordField(
                        hint: context.l10n.newPasswordHint,
                        controller: _newPasswordController,
                        validator: (value) =>
                            FormValidators.validatePassword(value, context),
                      ),
                      const SizedBox(height: 24),

                      // Confirm Password
                      Text(
                        context.l10n.confirmNewPasswordLabel,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 8),
                      PasswordField(
                        hint: context.l10n.confirmNewPasswordHint,
                        controller: _confirmPasswordController,
                        validator: (value) =>
                            FormValidators.validatePasswordConfirmation(
                              value,
                              _newPasswordController.text,
                              context,
                            ),
                      ),
                      const Spacer(),

                      // Save Button
                      CustomButton(
                        text: context.l10n.saveChanges,
                        onPressed: isLoading ? null : _updatePassword,
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),

              if (isLoading)
                Container(
                  color: Colors.black.withValues(alpha: 0.3),
                  child: const Center(child: CustomProgressIndicator()),
                ),
            ],
          );
        },
      ),
    );
  }

  void _updatePassword() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final request = UpdateProfileRequest(
      name: null,
      phone: null,
      birthDate: null,
      address: null,
      gender: null,
      oldPassword: _oldPasswordController.text,
      newPassword: _newPasswordController.text,
      confirmPassword: _confirmPasswordController.text,
    );

    context.read<ProfileCubit>().updateProfileNew(request);
  }
}

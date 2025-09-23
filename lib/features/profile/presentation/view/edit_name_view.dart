import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/core/services/profile_refresh_service.dart';
import 'package:test/core/utils/animations/custom_progress_indcator.dart';
import 'package:test/core/utils/common/custom_app_bar.dart';
import 'package:test/core/utils/common/custom_button.dart';
import 'package:test/core/utils/common/custom_text_field.dart';
import 'package:test/core/utils/validators/form_validators_clean.dart';
import 'package:test/core/utils/widgets/custom_snackbar.dart';
import 'package:test/features/profile/domain/entities/update_profile_request.dart';
import 'package:test/features/profile/domain/entities/user_profile.dart';
import 'package:test/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:test/features/profile/presentation/cubit/profile_state.dart';
import 'package:test/l10n/l10n.dart';

class EditNameView extends StatefulWidget {
  final UserProfile userProfile;

  const EditNameView({super.key, required this.userProfile});

  @override
  State<EditNameView> createState() => _EditNameViewState();
}

class _EditNameViewState extends State<EditNameView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.userProfile.name;

    // تحميل البروفايل إذا لم يكن محمل
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cubit = context.read<ProfileCubit>();
      if (cubit.state is ProfileInitial) {
        print(
          'DEBUG: ProfileCubit is in ProfileInitial state, loading profile...',
        );
        cubit.getProfile();
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: context.l10n.fullName),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileError) {
            CustomSnackbar.showError(context: context, message: state.message);
          } else if (state is ProfileUpdated) {
            CustomSnackbar.showSuccess(
              context: context,
              message: context.l10n.profileUpdatedSuccessfully,
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
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.blue[200]!),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.info_outline, color: Colors.blue[600]),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                context.l10n.nameUpdateTip,
                                style: TextStyle(
                                  color: Colors.blue[700],
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Current Name Display
                      Text(
                        context.l10n.currentName,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          widget.userProfile.name,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // New Name Input
                      Text(
                        context.l10n.newName,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 8),
                      CustomTextField(
                        hint: context.l10n.fullName,
                        controller: _nameController,
                        validator: (value) =>
                            FormValidators.validateFullName(value, context),
                      ),
                      const Spacer(),

                      // Save Button
                      CustomButton(
                        text: context.l10n.saveChanges,
                        onPressed: isLoading ? null : _updateName,
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

  void _updateName() {
    print('DEBUG: _updateName called');

    if (!_formKey.currentState!.validate()) {
      print('DEBUG: Form validation failed');
      return;
    }

    final newName = _nameController.text.trim();
    print(
      'DEBUG: New name: "$newName", Old name: "${widget.userProfile.name}"',
    );

    if (newName == widget.userProfile.name) {
      print('DEBUG: Name unchanged, showing warning');
      CustomSnackbar.showWarning(
        context: context,
        message: context.l10n.nameNotChanged,
      );
      return;
    }

    final request = UpdateProfileRequest(
      name: newName,
      phone: null,
      birthDate: null,
      address: null,
      gender: null,
      oldPassword: null,
      newPassword: null,
      confirmPassword: null,
    );

    print('DEBUG: Created UpdateProfileRequest with name: "${request.name}"');
    print('DEBUG: Calling ProfileCubit.updateProfileNew');

    context.read<ProfileCubit>().updateProfileNew(request);
  }
}

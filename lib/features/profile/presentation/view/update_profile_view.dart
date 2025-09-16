import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/core/utils/animations/custom_progress_indcator.dart';
import 'package:test/core/utils/common/custom_button.dart';
import 'package:test/core/utils/common/custom_text_field.dart';
import 'package:test/core/utils/common/password_field.dart';
import 'package:test/core/utils/widgets/custom_snackbar.dart';
import 'package:test/features/profile/domain/entities/update_profile_request.dart';
import 'package:test/features/profile/domain/entities/user_profile.dart';
import 'package:test/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:test/features/profile/presentation/cubit/profile_state.dart';
import 'package:test/l10n/l10n.dart';

class UpdateProfileView extends StatefulWidget {
  final UserProfile userProfile;

  const UpdateProfileView({super.key, required this.userProfile});

  @override
  State<UpdateProfileView> createState() => _UpdateProfileViewState();
}

class _UpdateProfileViewState extends State<UpdateProfileView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  File? _selectedImage;
  DateTime? _selectedBirthDate;
  bool _isPasswordChangeEnabled = false;

  @override
  void initState() {
    super.initState();
    _initializeFields();
  }

  void _initializeFields() {
    _nameController.text = widget.userProfile.name;
    _phoneController.text = widget.userProfile.phone;
    if (widget.userProfile.birthDate != null) {
      _birthDateController.text = widget.userProfile.birthDate!;
      try {
        _selectedBirthDate = DateTime.parse(widget.userProfile.birthDate!);
      } catch (e) {
        // Handle parsing error
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _birthDateController.dispose();
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.updateProfile),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
      ),
      backgroundColor: Colors.grey[50],
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileError) {
            CustomSnackbar.showError(context: context, message: state.message);
          } else if (state is ProfileUpdated) {
            CustomSnackbar.showSuccess(
              context: context,
              message: context.l10n.profileUpdatedSuccessfully,
            );
            Navigator.of(context).pop();
          }
        },
        builder: (context, state) {
          final isLoading = state is ProfileUpdating;

          return Stack(
            children: [
              Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile Image Section
                      _buildProfileImageSection(),
                      const SizedBox(height: 24),

                      // Basic Information Section
                      Text(
                        context.l10n.basicInformation,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 16),

                      CustomTextField(
                        hint: context.l10n.fullName,
                        controller: _nameController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return context.l10n.nameRequired;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      CustomTextField(
                        hint: context.l10n.phoneNumber,
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return context.l10n.phoneRequired;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Birth Date Field
                      GestureDetector(
                        onTap: _selectBirthDate,
                        child: AbsorbPointer(
                          child: CustomTextField(
                            controller: _birthDateController,
                            hint: context.l10n.birthDate,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Password Change Section
                      _buildPasswordChangeSection(),
                      const SizedBox(height: 32),

                      // Update Button
                      CustomButton(
                        text: context.l10n.updateProfile,
                        onPressed: isLoading ? null : _updateProfile,
                        isLoading: isLoading,
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),

              if (isLoading)
                Container(
                  color: Colors.black.withOpacity(0.3),
                  child: const Center(child: CustomProgressIndicator()),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildProfileImageSection() {
    return Center(
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey[300],
                backgroundImage: _selectedImage != null
                    ? FileImage(_selectedImage!)
                    : widget.userProfile.image != null
                    ? NetworkImage(widget.userProfile.image!)
                    : null,
                child:
                    _selectedImage == null && widget.userProfile.image == null
                    ? Icon(Icons.person, size: 60, color: Colors.grey[600])
                    : null,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Text(context.l10n.updateProfile),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            context.l10n.tapToChangePhoto,
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordChangeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              context.l10n.changePassword,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const Spacer(),
            Switch(
              value: _isPasswordChangeEnabled,
              onChanged: (value) {
                setState(() {
                  _isPasswordChangeEnabled = value;
                  if (!value) {
                    _oldPasswordController.clear();
                    _newPasswordController.clear();
                    _confirmPasswordController.clear();
                  }
                });
              },
            ),
          ],
        ),

        if (_isPasswordChangeEnabled) ...[
          const SizedBox(height: 16),
          PasswordField(
            hintText: context.l10n.currentPassword,
            controller: _oldPasswordController,
            validator: (value) {
              if (_isPasswordChangeEnabled &&
                  (value == null || value.isEmpty)) {
                return context.l10n.currentPasswordRequired;
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          PasswordField(
            hintText: context.l10n.newPassword,
            controller: _newPasswordController,
            validator: (value) {
              if (_isPasswordChangeEnabled) {
                if (value == null || value.isEmpty) {
                  return context.l10n.newPasswordRequired;
                }
                if (value.length < 8) {
                  return context.l10n.passwordTooShort;
                }
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          PasswordField(
            hintText: context.l10n.confirmPassword,
            controller: _confirmPasswordController,
            validator: (value) {
              if (_isPasswordChangeEnabled) {
                if (value == null || value.isEmpty) {
                  return context.l10n.confirmPasswordRequired;
                }
                if (value != _newPasswordController.text) {
                  return context.l10n.passwordsDoNotMatch;
                }
              }
              return null;
            },
          ),
        ],
      ],
    );
  }

  Future<void> _pickImage() async {
    // TODO: Implement image picker
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Image picker feature coming soon')),
    );
  }

  Future<void> _selectBirthDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          _selectedBirthDate ??
          DateTime.now().subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _selectedBirthDate = picked;
        _birthDateController.text =
            '${picked.year}/${picked.month.toString().padLeft(2, '0')}/${picked.day.toString().padLeft(2, '0')}';
      });
    }
  }

  void _updateProfile() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final request = UpdateProfileRequest(
      name: _nameController.text.trim().isNotEmpty
          ? _nameController.text.trim()
          : null,
      phone: _phoneController.text.trim().isNotEmpty
          ? _phoneController.text.trim()
          : null,
      birthDate: _birthDateController.text.trim().isNotEmpty
          ? _birthDateController.text.trim()
          : null,
      primaryImage: _selectedImage,
      oldPassword:
          _isPasswordChangeEnabled && _oldPasswordController.text.isNotEmpty
          ? _oldPasswordController.text
          : null,
      newPassword:
          _isPasswordChangeEnabled && _newPasswordController.text.isNotEmpty
          ? _newPasswordController.text
          : null,
      confirmPassword:
          _isPasswordChangeEnabled && _confirmPasswordController.text.isNotEmpty
          ? _confirmPasswordController.text
          : null,
    );

    if (request.isEmpty) {
      CustomSnackbar.showWarning(
        context: context,
        message: context.l10n.noChangesToUpdate,
      );
      return;
    }

    context.read<ProfileCubit>().updateProfileNew(request);
  }
}

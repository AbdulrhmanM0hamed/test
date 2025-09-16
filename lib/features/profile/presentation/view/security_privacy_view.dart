import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/core/utils/animations/custom_progress_indcator.dart';
import 'package:test/core/utils/common/custom_button.dart';
import 'package:test/core/utils/common/password_field.dart';
import 'package:test/core/utils/widgets/custom_snackbar.dart';
import 'package:test/features/profile/domain/entities/update_profile_request.dart';
import 'package:test/features/profile/domain/entities/user_profile.dart';
import 'package:test/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:test/features/profile/presentation/cubit/profile_state.dart';
import 'package:test/l10n/l10n.dart';

class SecurityPrivacyView extends StatefulWidget {
  final UserProfile userProfile;

  const SecurityPrivacyView({super.key, required this.userProfile});

  @override
  State<SecurityPrivacyView> createState() => _SecurityPrivacyViewState();
}

class _SecurityPrivacyViewState extends State<SecurityPrivacyView> {
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isPasswordChangeEnabled = false;

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
      appBar: AppBar(
        title: const Text('الأمان والخصوصية'),
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
              SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Security Info Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.red[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.red[200]!),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.security, color: Colors.red[600]),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'حافظ على أمان حسابك بتحديث كلمة المرور بانتظام واستخدام كلمة مرور قوية.',
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

                    // Password Change Section
                    _buildPasswordChangeSection(),
                    const SizedBox(height: 24),

                    // Privacy Settings Section
                    _buildPrivacySection(),
                    const SizedBox(height: 24),

                    // Account Security Section
                    _buildAccountSecuritySection(),
                    const SizedBox(height: 40),

                    // Save Button (only show if password change is enabled)
                    if (_isPasswordChangeEnabled) ...[
                      Form(
                        key: _formKey,
                        child: CustomButton(
                          text: 'حفظ التغييرات',
                          onPressed: isLoading ? null : _updatePassword,
                          isLoading: isLoading,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ],
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

  Widget _buildPasswordChangeSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lock_outline, color: Colors.blue[600]),
              const SizedBox(width: 12),
              const Text(
                'تغيير كلمة المرور',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
              hintText: 'كلمة المرور الحالية',
              controller: _oldPasswordController,
              validator: (value) {
                if (_isPasswordChangeEnabled) {
                  if (value == null || value.isEmpty) {
                    return 'كلمة المرور الحالية مطلوبة';
                  }
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
      ),
    );
  }

  Widget _buildPrivacySection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.privacy_tip_outlined, color: Colors.green[600]),
              const SizedBox(width: 12),
              const Text(
                'إعدادات الخصوصية',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildPrivacyOption(
            'إظهار الملف الشخصي للآخرين',
            'السماح للمستخدمين الآخرين برؤية ملفك الشخصي',
            true,
          ),
          const SizedBox(height: 12),
          _buildPrivacyOption(
            'السماح بالإشعارات',
            'تلقي إشعارات حول التحديثات والعروض',
            true,
          ),
          const SizedBox(height: 12),
          _buildPrivacyOption(
            'مشاركة البيانات للتحليل',
            'مساعدة في تحسين الخدمة من خلال مشاركة بيانات مجهولة',
            false,
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacyOption(String title, String subtitle, bool value) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: (newValue) {
            // Handle privacy setting change
          },
        ),
      ],
    );
  }

  Widget _buildAccountSecuritySection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.shield_outlined, color: Colors.orange[600]),
              const SizedBox(width: 12),
              const Text(
                'أمان الحساب',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSecurityOption(
            Icons.phone_android,
            'الأجهزة المتصلة',
            'إدارة الأجهزة التي تستخدم حسابك',
            () {
              // Navigate to connected devices
            },
          ),
          const SizedBox(height: 12),
          _buildSecurityOption(
            Icons.history,
            'سجل تسجيل الدخول',
            'عرض آخر مرات تسجيل الدخول',
            () {
              // Navigate to login history
            },
          ),
          const SizedBox(height: 12),
          _buildSecurityOption(
            Icons.delete_outline,
            'حذف الحساب',
            'حذف حسابك نهائياً',
            () {
              _showDeleteAccountDialog();
            },
            isDestructive: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityOption(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(
              icon,
              color: isDestructive ? Colors.red[600] : Colors.grey[600],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: isDestructive ? Colors.red[600] : Colors.black,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف الحساب'),
        content: const Text(
          'هل أنت متأكد من رغبتك في حذف حسابك؟ هذا الإجراء لا يمكن التراجع عنه.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Handle account deletion
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('حذف'),
          ),
        ],
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

      oldPassword: _oldPasswordController.text,
      newPassword: _newPasswordController.text,
      confirmPassword: _confirmPasswordController.text,
    );

    context.read<ProfileCubit>().updateProfileNew(request);
  }
}

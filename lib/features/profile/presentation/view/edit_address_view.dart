import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/core/utils/animations/custom_progress_indcator.dart';
import 'package:test/core/utils/common/custom_button.dart';
import 'package:test/core/utils/common/custom_text_field.dart';
import 'package:test/core/utils/widgets/custom_snackbar.dart';
import 'package:test/features/profile/domain/entities/user_profile.dart';
import 'package:test/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:test/features/profile/presentation/cubit/profile_state.dart';
import 'package:test/l10n/l10n.dart';

class EditAddressView extends StatefulWidget {
  final UserProfile userProfile;

  const EditAddressView({super.key, required this.userProfile});

  @override
  State<EditAddressView> createState() => _EditAddressViewState();
}

class _EditAddressViewState extends State<EditAddressView> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _addressController.text = widget.userProfile.address ?? '';
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.address),
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
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Info Card
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.orange[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.orange[200]!),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.location_on_outlined, color: Colors.orange[600]),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'يمكنك تحديث عنوانك هنا. هذا يساعد في تحسين خدمات التوصيل.',
                                style: TextStyle(
                                  color: Colors.orange[700],
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Current Address Display
                      Text(
                        'العنوان الحالي',
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
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.location_on, color: Colors.grey[600]),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                widget.userProfile.address?.isNotEmpty == true
                                  ? widget.userProfile.address!
                                  : 'غير محدد',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // New Address Input
                      Text(
                        'العنوان الجديد',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 8),
                      CustomTextField(
                        hint: context.l10n.address,
                        controller: _addressController,
                        maxLines: 3,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'العنوان مطلوب';
                          }
                          if (value.trim().length < 5) {
                            return 'العنوان يجب أن يكون 5 أحرف على الأقل';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Address Tips
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'نصائح لكتابة العنوان:',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[700],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '• اكتب اسم الشارع والحي\n• أضف رقم المبنى أو الشقة\n• اذكر المدينة والمحافظة\n• يمكنك إضافة علامات مميزة',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),

                      // Save Button
                      CustomButton(
                        text: 'حفظ التغييرات',
                        onPressed: isLoading ? null : _updateAddress,
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

  void _updateAddress() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final newAddress = _addressController.text.trim();
    if (newAddress == widget.userProfile.address) {
      CustomSnackbar.showWarning(
        context: context,
        message: 'لم يتم تغيير العنوان',
      );
      return;
    }

    // Since address is not supported by the current endpoint,
    // show a message to the user
    CustomSnackbar.showWarning(
      context: context,
      message: 'تعديل العنوان غير متاح حالياً - سيتم إضافة هذه الميزة قريباً',
    );
  }
}

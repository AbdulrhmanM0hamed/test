import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/core/services/profile_refresh_service.dart';
import 'package:test/core/utils/animations/custom_progress_indcator.dart';
import 'package:test/core/utils/common/custom_app_bar.dart';
import 'package:test/core/utils/common/custom_button.dart';
import 'package:test/core/utils/constant/font_manger.dart';
import 'package:test/core/utils/constant/styles_manger.dart';
import 'package:test/core/utils/widgets/custom_snackbar.dart';
import 'package:test/features/profile/domain/entities/update_profile_request.dart';
import 'package:test/features/profile/domain/entities/user_profile.dart';
import 'package:test/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:test/features/profile/presentation/cubit/profile_state.dart';
import 'package:test/l10n/l10n.dart';

class EditBirthDateView extends StatefulWidget {
  final UserProfile userProfile;

  const EditBirthDateView({super.key, required this.userProfile});

  @override
  State<EditBirthDateView> createState() => _EditBirthDateViewState();
}

class _EditBirthDateViewState extends State<EditBirthDateView> {
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    if (widget.userProfile.birthDate?.isNotEmpty == true) {
      try {
        _selectedDate = DateTime.parse(widget.userProfile.birthDate!);
      } catch (e) {
        _selectedDate = null;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: context.l10n.birthDate),
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
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Info Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.purple[200]!),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.cake_outlined, color: Colors.purple[600]),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              context.l10n.birthDateUpdateTip,
                              style: TextStyle(
                                color: Colors.purple[700],
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Current Birth Date Display
                    Text(
                      context.l10n.currentBirthDate,
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
                        color: Colors.grey[650],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today, color: Colors.grey[600]),
                          const SizedBox(width: 12),
                          Text(
                            widget.userProfile.birthDate?.isNotEmpty == true
                                ? _formatDate(widget.userProfile.birthDate!)
                                : context.l10n.notSpecifiedValue,
                            style: getBoldStyle(
                              fontFamily: FontConstant.cairo,
                              fontSize: FontSize.size16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // New Birth Date Selection
                    Text(
                      context.l10n.newBirthDate,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: isLoading ? null : _selectDate,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              color: _selectedDate != null
                                  ? Colors.blue[600]
                                  : Colors.grey[600],
                            ),
                            const SizedBox(width: 12),
                            Text(
                              _selectedDate != null
                                  ? _formatDate(_selectedDate.toString())
                                  : context.l10n.selectBirthDate,
                              style: TextStyle(
                                fontSize: FontSize.size16,
                                color: _selectedDate != null
                                    ? Theme.of(context).brightness ==
                                              Brightness.light
                                          ? Colors.black
                                          : Colors.white
                                    : Colors.grey[600],
                              ),
                            ),
                            const Spacer(),
                            Icon(
                              Icons.arrow_drop_down,
                              color: Colors.grey[600],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Spacer(),

                    // Save Button
                    CustomButton(
                      text: context.l10n.saveChanges,
                      onPressed: isLoading ? null : _updateBirthDate,
                    ),
                    const SizedBox(height: 20),
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

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          _selectedDate ??
          DateTime.now().subtract(const Duration(days: 365 * 20)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      locale: const Locale('ar'),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue[600]!,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _updateBirthDate() {
    if (_selectedDate == null) {
      CustomSnackbar.showWarning(
        context: context,
        message: context.l10n.pleaseSelectBirthDate,
      );
      return;
    }

    final newBirthDate = _selectedDate!.toIso8601String().split('T')[0];
    if (newBirthDate == widget.userProfile.birthDate) {
      CustomSnackbar.showWarning(
        context: context,
        message: context.l10n.birthDateNotChanged,
      );
      return;
    }

    final request = UpdateProfileRequest(
      name: null,
      phone: null,
      birthDate: newBirthDate,
      address: null,
      gender: null,
      oldPassword: null,
      newPassword: null,
      confirmPassword: null,
    );

    context.read<ProfileCubit>().updateProfileNew(request);
  }
}

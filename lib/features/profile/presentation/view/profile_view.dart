import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/core/utils/animations/custom_progress_indcator.dart';
import 'package:test/core/utils/widgets/custom_snackbar.dart';
import 'package:test/core/utils/widgets/logout_confirmation_dialog.dart';
import 'package:test/features/profile/domain/entities/user_profile.dart';
import 'package:test/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:test/features/profile/presentation/cubit/profile_state.dart';
import 'package:test/features/profile/presentation/widgets/profile_header.dart';
import 'package:test/features/profile/presentation/widgets/profile_info_card.dart';
import 'package:test/features/profile/presentation/widgets/profile_stats_card.dart';
import 'package:test/features/profile/presentation/widgets/profile_action_button.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().getProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileError) {
            CustomSnackbar.showError(context: context, message: state.message);
          } else if (state is ProfileUpdated) {
            CustomSnackbar.showSuccess(context: context, message: 'تم تحديث البيانات بنجاح');
          }
        },
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: CustomProgressIndicator());
          }

          if (state is ProfileLoaded || 
              state is ProfileUpdating || 
              state is ProfileImageUploading) {
            UserProfile userProfile;
            bool isUpdating = false;

            if (state is ProfileLoaded) {
              userProfile = state.userProfile;
            } else if (state is ProfileUpdating) {
              userProfile = state.currentProfile;
              isUpdating = true;
            } else if (state is ProfileImageUploading) {
              userProfile = state.currentProfile;
              isUpdating = true;
            } else {
              return const SizedBox();
            }

            return Stack(
              children: [
                CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: ProfileHeader(
                        userProfile: userProfile,
                        onEditImage: () => _showImagePicker(context),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Stats Section
                            Row(
                              children: [
                                ProfileStatsCard(
                                  label: 'عضو منذ',
                                  value: _getJoinedYear(userProfile.createdAt),
                                  icon: Icons.calendar_today,
                                  color: Colors.blue,
                                ),
                                const SizedBox(width: 12),
                                ProfileStatsCard(
                                  label: 'الحالة',
                                  value: userProfile.isActive ? 'نشط' : 'غير نشط',
                                  icon: Icons.check_circle,
                                  color: userProfile.isActive ? Colors.green : Colors.orange,
                                ),
                                const SizedBox(width: 12),
                                ProfileStatsCard(
                                  label: 'التوثيق',
                                  value: userProfile.isEmailVerified ? 'موثق' : 'غير موثق',
                                  icon: Icons.verified_user,
                                  color: userProfile.isEmailVerified ? Colors.green : Colors.red,
                                ),
                              ],
                            ),
                            
                            const SizedBox(height: 24),
                            
                            // Personal Information Section
                            const Text(
                              'المعلومات الشخصية',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 16),
                            
                            ProfileInfoCard(
                              title: 'الاسم الكامل',
                              value: userProfile.name,
                              icon: Icons.person,
                              isEditable: true,
                              onTap: () => _showEditDialog(context, 'name', userProfile.name),
                            ),
                            
                            ProfileInfoCard(
                              title: 'البريد الإلكتروني',
                              value: userProfile.email,
                              icon: Icons.email,
                              iconColor: Colors.blue,
                            ),
                            
                            ProfileInfoCard(
                              title: 'رقم الهاتف',
                              value: userProfile.phone,
                              icon: Icons.phone,
                              iconColor: Colors.green,
                              isEditable: true,
                              onTap: () => _showEditDialog(context, 'phone', userProfile.phone),
                            ),
                            
                            ProfileInfoCard(
                              title: 'تاريخ الميلاد',
                              value: userProfile.birthDate ?? '',
                              icon: Icons.cake,
                              iconColor: Colors.pink,
                              isEditable: true,
                              onTap: () => _showDatePicker(context, userProfile.birthDate),
                            ),
                            
                            ProfileInfoCard(
                              title: 'الجنس',
                              value: _getGenderText(userProfile.gender),
                              icon: Icons.wc,
                              iconColor: Colors.purple,
                              isEditable: true,
                              onTap: () => _showGenderPicker(context, userProfile.gender),
                            ),
                            
                            ProfileInfoCard(
                              title: 'العنوان',
                              value: userProfile.address ?? '',
                              icon: Icons.location_on,
                              iconColor: Colors.red,
                              isEditable: true,
                              onTap: () => _showEditDialog(context, 'address', userProfile.address ?? ''),
                            ),
                            
                            const SizedBox(height: 24),
                            
                            // Location Information Section
                            const Text(
                              'معلومات الموقع',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 16),
                            
                            ProfileInfoCard(
                              title: 'الدولة',
                              value: userProfile.country.titleAr,
                              icon: Icons.flag,
                              iconColor: Colors.orange,
                            ),
                            
                            ProfileInfoCard(
                              title: 'المدينة',
                              value: userProfile.city.titleAr,
                              icon: Icons.location_city,
                              iconColor: Colors.teal,
                            ),
                            
                            ProfileInfoCard(
                              title: 'المنطقة',
                              value: userProfile.region.titleAr,
                              icon: Icons.place,
                              iconColor: Colors.indigo,
                            ),
                            
                            const SizedBox(height: 24),
                            
                            // Actions Section
                            const Text(
                              'الإعدادات',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 16),
                            
                            ProfileActionButton(
                              title: 'تعديل الملف الشخصي',
                              icon: Icons.edit,
                              onTap: () => _showEditProfileSheet(context, userProfile),
                            ),
                            
                            ProfileActionButton(
                              title: 'إعدادات الحساب',
                              icon: Icons.settings,
                              onTap: () => _showAccountSettings(context),
                            ),
                            
                            ProfileActionButton(
                              title: 'الأمان والخصوصية',
                              icon: Icons.security,
                              onTap: () => _showSecuritySettings(context),
                            ),
                            
                            ProfileActionButton(
                              title: 'المساعدة والدعم',
                              icon: Icons.help,
                              onTap: () => _showHelpCenter(context),
                            ),
                            
                            ProfileActionButton(
                              title: 'تسجيل الخروج',
                              icon: Icons.logout,
                              onTap: () => _showLogoutDialog(context),
                              isDestructive: true,
                            ),
                            
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                
                if (isUpdating)
                  Container(
                    color: Colors.black.withOpacity(0.3),
                    child: const Center(
                      child: CustomProgressIndicator(),
                    ),
                  ),
              ],
            );
          }

          if (state is ProfileError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'حدث خطأ في تحميل البيانات',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => context.read<ProfileCubit>().getProfile(),
                    child: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }

  String _getJoinedYear(String createdAt) {
    try {
      final date = DateTime.parse(createdAt);
      return date.year.toString();
    } catch (e) {
      return 'غير محدد';
    }
  }

  String _getGenderText(String gender) {
    switch (gender.toLowerCase()) {
      case 'male':
        return 'ذكر';
      case 'female':
        return 'أنثى';
      default:
        return 'غير محدد';
    }
  }

  void _showImagePicker(BuildContext context) {
    // TODO: Implement image picker
    CustomSnackbar.showInfo(context: context, message: 'سيتم إضافة خاصية تغيير الصورة قريباً');
  }

  void _showEditDialog(BuildContext context, String field, String currentValue) {
    // TODO: Implement edit dialog
    CustomSnackbar.showInfo(context: context, message: 'سيتم إضافة خاصية التعديل قريباً');
  }

  void _showDatePicker(BuildContext context, String? currentDate) {
    // TODO: Implement date picker
    CustomSnackbar.showInfo(context: context, message: 'سيتم إضافة خاصية اختيار التاريخ قريباً');
  }

  void _showGenderPicker(BuildContext context, String currentGender) {
    // TODO: Implement gender picker
    CustomSnackbar.showInfo(context: context, message: 'سيتم إضافة خاصية اختيار الجنس قريباً');
  }

  void _showEditProfileSheet(BuildContext context, UserProfile userProfile) {
    // TODO: Implement edit profile sheet
    CustomSnackbar.showInfo(context: context, message: 'سيتم إضافة خاصية تعديل الملف الشخصي قريباً');
  }

  void _showAccountSettings(BuildContext context) {
    // TODO: Implement account settings
    CustomSnackbar.showInfo(context: context, message: 'سيتم إضافة إعدادات الحساب قريباً');
  }

  void _showSecuritySettings(BuildContext context) {
    // TODO: Implement security settings
    CustomSnackbar.showInfo(context: context, message: 'سيتم إضافة إعدادات الأمان قريباً');
  }

  void _showHelpCenter(BuildContext context) {
    // TODO: Implement help center
    CustomSnackbar.showInfo(context: context, message: 'سيتم إضافة مركز المساعدة قريباً');
  }

  void _showLogoutDialog(BuildContext context) {
    LogoutConfirmationDialog.show(context);
  }
}

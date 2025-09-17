import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:test/core/utils/animations/custom_progress_indcator.dart';
import 'package:test/core/utils/constant/font_manger.dart';
import 'package:test/core/utils/constant/styles_manger.dart';
import 'package:test/core/utils/widgets/custom_snackbar.dart';
import 'package:test/core/utils/widgets/logout_confirmation_dialog.dart';
import 'package:test/features/profile/domain/entities/user_profile.dart';
import 'package:test/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:test/features/profile/presentation/cubit/profile_state.dart';
import 'package:test/features/profile/presentation/view/edit_birth_date_view.dart';
import 'package:test/features/profile/presentation/view/edit_name_view.dart';
import 'package:test/features/profile/presentation/view/edit_phone_view.dart';
import 'package:test/features/profile/presentation/view/change_password_view.dart';
import 'package:test/features/profile/presentation/widgets/profile_action_button.dart';
import 'package:test/features/profile/presentation/widgets/profile_header.dart';
import 'package:test/features/profile/presentation/widgets/profile_stats_card.dart';
import 'package:test/l10n/app_localizations.dart';
import 'package:test/core/di/dependency_injection.dart';

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
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileError) {
            CustomSnackbar.showError(context: context, message: state.message);
          } else if (state is ProfileUpdated) {
            CustomSnackbar.showSuccess(
              context: context,
              message: AppLocalizations.of(context)!.dataUpdatedSuccessfully,
            );
          } else if (state is ProfileImageUpdated) {
            CustomSnackbar.showSuccess(
              context: context,
              message: AppLocalizations.of(context)!.imageUpdatedSuccessfully,
            );
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
                                  label: AppLocalizations.of(
                                    context,
                                  )!.memberSince,
                                  value: _getJoinedYear(userProfile.createdAt),
                                  icon: Icons.calendar_today,
                                  color: Colors.blue,
                                ),
                                const SizedBox(width: 12),
                                ProfileStatsCard(
                                  label: AppLocalizations.of(context)!.status,
                                  value: userProfile.isActive
                                      ? AppLocalizations.of(context)!.active
                                      : AppLocalizations.of(context)!.inactive,
                                  icon: Icons.check_circle,
                                  color: userProfile.isActive
                                      ? Colors.green
                                      : Colors.orange,
                                ),
                                const SizedBox(width: 12),
                                ProfileStatsCard(
                                  label: AppLocalizations.of(
                                    context,
                                  )!.verification,
                                  value: userProfile.isEmailVerified
                                      ? AppLocalizations.of(context)!.verified
                                      : AppLocalizations.of(
                                          context,
                                        )!.notVerified,
                                  icon: Icons.verified_user,
                                  color: userProfile.isEmailVerified
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              ],
                            ),

                            const SizedBox(height: 24),

                            // Quick Edit Cards Section
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    AppLocalizations.of(
                                      context,
                                    )!.personalInformation,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  _buildQuickEditRow(
                                    Icons.person,
                                    AppLocalizations.of(context)!.fullName,
                                    userProfile.name,
                                    Colors.blue,
                                    () => _showEditDialog(
                                      context,
                                      'name',
                                      userProfile.name,
                                      userProfile,
                                    ),
                                  ),
                                  _buildQuickEditRow(
                                    Icons.phone,
                                    AppLocalizations.of(context)!.phoneNumber,
                                    userProfile.phone,
                                    Colors.green,
                                    () => _showEditDialog(
                                      context,
                                      'phone',
                                      userProfile.phone,
                                      userProfile,
                                    ),
                                  ),
                                  _buildQuickEditRow(
                                    Icons.cake,
                                    AppLocalizations.of(context)!.birthDate,
                                    userProfile.birthDate?.isNotEmpty == true
                                        ? _formatBirthDate(
                                            userProfile.birthDate!,
                                          )
                                        : AppLocalizations.of(
                                            context,
                                          )!.notSpecifiedValue,
                                    Colors.pink,
                                    () => _showDatePicker(
                                      context,
                                      userProfile.birthDate,
                                      userProfile,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 16),

                            // Contact Information
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.email, color: Colors.blue[600]),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          AppLocalizations.of(context)!.email,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        Text(
                                          userProfile.email,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 16),

                            // Location Information (Simplified)
                            const SizedBox(height: 24),

                            // Actions Section
                            ProfileActionButton(
                              title: AppLocalizations.of(
                                context,
                              )!.securityAndPrivacy,
                              icon: Icons.security,
                              onTap: () => _navigateToChangePassword(
                                context,
                                userProfile,
                              ),
                            ),

                            ProfileActionButton(
                              title: AppLocalizations.of(
                                context,
                              )!.helpAndSupport,
                              icon: Icons.help,
                              onTap: () => _showHelpCenter(context),
                            ),

                            ProfileActionButton(
                              title: AppLocalizations.of(context)!.logout,
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
                    color: Colors.black.withValues(alpha: 0.3),
                    child: const Center(child: CustomProgressIndicator()),
                  ),
              ],
            );
          }

          if (state is ProfileError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                  const SizedBox(height: 16),
                  Text(
                    AppLocalizations.of(context)!.errorLoadingData,
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => context.read<ProfileCubit>().getProfile(),
                    child: Text(AppLocalizations.of(context)!.retry),
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
      return AppLocalizations.of(context)!.notSpecified;
    }
  }

  void _showImagePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('المعرض'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('الكاميرا'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        context.read<ProfileCubit>().updateProfileImage(image.path);
      }
    } catch (e) {
      if (mounted) {
        CustomSnackbar.showError(
          context: context,
          message: AppLocalizations.of(context)!.errorSelectingImage,
        );
      }
    }
  }

  void _showEditDialog(
    BuildContext context,
    String field,
    String currentValue,
    UserProfile userProfile,
  ) {
    switch (field) {
      case 'name':
        _navigateToEditName(context, userProfile);
        break;
      case 'phone':
        _navigateToEditPhone(context, userProfile);
        break;

      default:
        _showEditProfileSheet(context, userProfile);
    }
  }

  void _showDatePicker(
    BuildContext context,
    String? currentDate,
    UserProfile userProfile,
  ) {
    _navigateToEditBirthDate(context, userProfile);
  }

  void _showEditProfileSheet(BuildContext context, UserProfile userProfile) {
    // This method is kept for backward compatibility but not used anymore
    // Individual edit pages are used instead
    CustomSnackbar.showInfo(
      context: context,
      message: 'استخدم الصفحات المنفصلة لتعديل البيانات',
    );
  }

  void _navigateToChangePassword(
    BuildContext context,
    UserProfile userProfile,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider<ProfileCubit>(
          create: (context) => DependencyInjection.getIt<ProfileCubit>(),
          child: ChangePasswordView(userProfile: userProfile),
        ),
      ),
    );
  }

  void _showHelpCenter(BuildContext context) {
    // TODO: Implement help center
    CustomSnackbar.showInfo(
      context: context,
      message: AppLocalizations.of(context)!.helpCenterComingSoon,
    );
  }

  void _showLogoutDialog(BuildContext context) {
    LogoutConfirmationDialog.show(context);
  }

  Widget _buildQuickEditRow(
    IconData icon,
    String title,
    String value,
    Color iconColor,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: getSemiBoldStyle(
                      color: Colors.grey[600],
                      fontSize: FontSize.size15,
                      fontFamily: FontConstant.cairo,
                    ),
                  ),
                  Text(
                    value.isNotEmpty ? value : 'غير محدد',
                    style: getMediumStyle(
                      fontSize: FontSize.size16,
                      fontFamily: FontConstant.cairo,
                    ),
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

  String _formatBirthDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  void _navigateToEditName(BuildContext context, UserProfile userProfile) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider<ProfileCubit>(
          create: (context) => DependencyInjection.getIt<ProfileCubit>(),
          child: EditNameView(userProfile: userProfile),
        ),
      ),
    );
  }

  void _navigateToEditPhone(BuildContext context, UserProfile userProfile) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider<ProfileCubit>(
          create: (context) => DependencyInjection.getIt<ProfileCubit>(),
          child: EditPhoneView(userProfile: userProfile),
        ),
      ),
    );
  }

  void _navigateToEditBirthDate(BuildContext context, UserProfile userProfile) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider<ProfileCubit>(
          create: (context) => DependencyInjection.getIt<ProfileCubit>(),
          child: EditBirthDateView(userProfile: userProfile),
        ),
      ),
    );
  }
}

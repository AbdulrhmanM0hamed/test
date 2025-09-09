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
import 'package:test/generated/l10n.dart';

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
            CustomSnackbar.showSuccess(
              context: context,
              message: S.current.dataUpdatedSuccessfully,
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
                                  label: S.of(context).memberSince,
                                  value: _getJoinedYear(userProfile.createdAt),
                                  icon: Icons.calendar_today,
                                  color: Colors.blue,
                                ),
                                const SizedBox(width: 12),
                                ProfileStatsCard(
                                  label: S.of(context).status,
                                  value: userProfile.isActive
                                      ? S.of(context).active
                                      : S.of(context).inactive,
                                  icon: Icons.check_circle,
                                  color: userProfile.isActive ? Colors.green : Colors.orange,
                                ),
                                const SizedBox(width: 12),
                                ProfileStatsCard(
                                  label: S.of(context).verification,
                                  value: userProfile.isEmailVerified
                                      ? S.of(context).verified
                                      : S.of(context).notVerified,
                                  icon: Icons.verified_user,
                                  color: userProfile.isEmailVerified ? Colors.green : Colors.red,
                                ),
                              ],
                            ),
                            
                            const SizedBox(height: 24),
                            
                            // Personal Information Section
                            Text(
                              S.of(context).personalInformation,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 16),
                            
                            ProfileInfoCard(
                              title: S.of(context).fullName,
                              value: userProfile.name,
                              icon: Icons.person,
                              isEditable: true,
                              onTap: () => _showEditDialog(context, 'name', userProfile.name),
                            ),
                            
                            ProfileInfoCard(
                              title: S.of(context).email,
                              value: userProfile.email,
                              icon: Icons.email,
                              iconColor: Colors.blue,
                            ),
                            
                            ProfileInfoCard(
                              title: S.of(context).phoneNumber,
                              value: userProfile.phone,
                              icon: Icons.phone,
                              iconColor: Colors.green,
                              isEditable: true,
                              onTap: () => _showEditDialog(context, 'phone', userProfile.phone),
                            ),
                            
                            ProfileInfoCard(
                              title: S.of(context).birthDate,
                              value: userProfile.birthDate ?? '',
                              icon: Icons.cake,
                              iconColor: Colors.pink,
                              isEditable: true,
                              onTap: () => _showDatePicker(context, userProfile.birthDate),
                            ),
                            
                            ProfileInfoCard(
                              title: S.of(context).gender,
                              value: _getGenderText(
                                context,
                                userProfile.gender,
                              ),
                              icon: Icons.wc,
                              iconColor: Colors.purple,
                              isEditable: true,
                              onTap: () => _showGenderPicker(context, userProfile.gender),
                            ),
                            
                            ProfileInfoCard(
                              title: S.of(context).address,
                              value: userProfile.address ?? '',
                              icon: Icons.location_on,
                              iconColor: Colors.red,
                              isEditable: true,
                              onTap: () => _showEditDialog(context, 'address', userProfile.address ?? ''),
                            ),
                            
                            const SizedBox(height: 24),
                            
                            // Location Information Section
                            Text(
                              S.of(context).locationInformation,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 16),
                            
                            ProfileInfoCard(
                              title: S.of(context).country,
                              value: userProfile.country.titleAr,
                              icon: Icons.flag,
                              iconColor: Colors.orange,
                            ),
                            
                            ProfileInfoCard(
                              title: S.of(context).city,
                              value: userProfile.city.titleAr,
                              icon: Icons.location_city,
                              iconColor: Colors.teal,
                            ),
                            
                            ProfileInfoCard(
                              title: S.of(context).region,
                              value: userProfile.region.titleAr,
                              icon: Icons.place,
                              iconColor: Colors.indigo,
                            ),
                            
                            const SizedBox(height: 24),
                            
                            // Actions Section
                            Text(
                              S.of(context).settings,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 16),
                            
                            ProfileActionButton(
                              title: S.of(context).editProfile,
                              icon: Icons.edit,
                              onTap: () => _showEditProfileSheet(context, userProfile),
                            ),
                            
                            ProfileActionButton(
                              title: S.of(context).accountSettings,
                              icon: Icons.settings,
                              onTap: () => _showAccountSettings(context),
                            ),
                            
                            ProfileActionButton(
                              title: S.of(context).securityAndPrivacy,
                              icon: Icons.security,
                              onTap: () => _showSecuritySettings(context),
                            ),
                            
                            ProfileActionButton(
                              title: S.of(context).helpAndSupport,
                              icon: Icons.help,
                              onTap: () => _showHelpCenter(context),
                            ),
                            
                            ProfileActionButton(
                              title: S.of(context).logout,
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
                    S.of(context).errorLoadingData,
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
                    child: Text(S.of(context).retry),
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
      return S.current.notSpecified;
    }
  }

  String _getGenderText(BuildContext context, String gender) {
    switch (gender.toLowerCase()) {
      case 'male':
        return S.of(context).male;
      case 'female':
        return S.of(context).female;
      default:
        return S.of(context).notSpecified;
    }
  }

  void _showImagePicker(BuildContext context) {
    // TODO: Implement image picker
    CustomSnackbar.showInfo(
      context: context,
      message: S.of(context).imageChangeFeatureComingSoon,
    );
  }

  void _showEditDialog(BuildContext context, String field, String currentValue) {
    // TODO: Implement edit dialog
    CustomSnackbar.showInfo(
      context: context,
      message: S.of(context).editFeatureComingSoon,
    );
  }

  void _showDatePicker(BuildContext context, String? currentDate) {
    // TODO: Implement date picker
    CustomSnackbar.showInfo(
      context: context,
      message: S.of(context).datePickerFeatureComingSoon,
    );
  }

  void _showGenderPicker(BuildContext context, String currentGender) {
    // TODO: Implement gender picker
    CustomSnackbar.showInfo(
      context: context,
      message: S.of(context).genderPickerFeatureComingSoon,
    );
  }

  void _showEditProfileSheet(BuildContext context, UserProfile userProfile) {
    // TODO: Implement edit profile sheet
    CustomSnackbar.showInfo(
      context: context,
      message: S.of(context).editProfileFeatureComingSoon,
    );
  }

  void _showAccountSettings(BuildContext context) {
    // TODO: Implement account settings
    CustomSnackbar.showInfo(
      context: context,
      message: S.of(context).accountSettingsComingSoon,
    );
  }

  void _showSecuritySettings(BuildContext context) {
    // TODO: Implement security settings
    CustomSnackbar.showInfo(
      context: context,
      message: S.of(context).securitySettingsComingSoon,
    );
  }

  void _showHelpCenter(BuildContext context) {
    // TODO: Implement help center
    CustomSnackbar.showInfo(
      context: context,
      message: S.of(context).helpCenterComingSoon,
    );
  }

  void _showLogoutDialog(BuildContext context) {
    LogoutConfirmationDialog.show(context);
  }
}

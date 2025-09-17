import 'dart:async';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/core/models/api_response.dart';
import 'package:test/core/services/data_refresh_service.dart';
import 'package:test/core/services/profile_refresh_service.dart';
import 'package:test/core/utils/error/error_handler.dart';
import 'package:test/features/profile/domain/entities/update_profile_request.dart';
import 'package:test/features/profile/domain/entities/user_profile.dart';
import 'package:test/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:test/features/profile/domain/usecases/update_profile_usecase.dart';
import 'package:test/features/profile/domain/repositories/profile_repository.dart';
import 'package:test/features/profile/presentation/cubit/profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetProfileUseCase getProfileUseCase;
  final UpdateProfileUseCase updateProfileUseCase;
  final ProfileRepository profileRepository;
  final DataRefreshService? dataRefreshService;
  final ProfileRefreshService _profileRefreshService = ProfileRefreshService();
  StreamSubscription? _refreshSubscription;

  ProfileCubit({
    required this.getProfileUseCase,
    required this.updateProfileUseCase,
    required this.profileRepository,
    this.dataRefreshService,
  }) : super(ProfileInitial()) {
    dataRefreshService?.registerRefreshCallback(_refreshData);

    // الاستماع لتحديثات البروفايل
    _refreshSubscription = _profileRefreshService.refreshStream.listen((_) {
      if (!isClosed) {
        getProfile();
      }
    });
  }

  Future<void> getProfile() async {
    try {
      if (!isClosed) emit(ProfileLoading());
      final userProfile = await getProfileUseCase();
      if (!isClosed) emit(ProfileLoaded(userProfile));
    } catch (e) {
      final errorMessage = ErrorHandler.extractErrorMessage(e);
      if (!isClosed) emit(ProfileError(errorMessage));
    }
  }

  Future<void> updateProfile({
    String? name,
    String? phone,
    String? birthDate,
    String? address,
    String? gender,
  }) async {
    try {
      final currentState = state;
      if (currentState is ProfileLoaded) {
        if (!isClosed) emit(ProfileUpdating(currentState.userProfile));

        final updatedProfile = await profileRepository.updateProfile(
          name: name,
          phone: phone,
          birthDate: birthDate,
          address: address,
          gender: gender,
        );

        if (!isClosed) emit(ProfileUpdated(updatedProfile));
        // إشعار جميع المستمعين بتحديث البروفايل
        _profileRefreshService.notifyProfileUpdated();
      }
    } catch (e) {
      final errorMessage = ErrorHandler.extractErrorMessage(e);
      if (!isClosed) emit(ProfileError(errorMessage));
    }
  }

  Future<void> updateProfileImage(String imagePath) async {
    try {
      final currentState = state;
      UserProfile currentProfile;

      if (currentState is ProfileLoaded) {
        currentProfile = currentState.userProfile;
      } else if (currentState is ProfileUpdating) {
        currentProfile = currentState.currentProfile;
      } else if (currentState is ProfileImageUploading) {
        currentProfile = currentState.currentProfile;
      } else {
        // إذا لم يكن البروفايل محمل، نحمله أولاً
        await getProfile();
        if (state is! ProfileLoaded) {
          return;
        }
        currentProfile = (state as ProfileLoaded).userProfile;
      }

      if (!isClosed) emit(ProfileImageUploading(currentProfile));

      // استخدام updateProfileNew مع primary_image
      final request = UpdateProfileRequest(primaryImage: File(imagePath));
      await updateProfileUseCase(request);

      // إشعار جميع المستمعين بتحديث البروفايل
      _profileRefreshService.notifyProfileUpdated();

      // تحديث البروفايل من السيرفر للحصول على أحدث البيانات
      if (!isClosed) await getProfile();
      
      // إرسال حالة نجاح تحديث الصورة
      if (!isClosed) emit(ProfileImageUpdated(currentProfile));
    } catch (e) {
      final errorMessage = ErrorHandler.extractErrorMessage(e);
      if (!isClosed) emit(ProfileError(errorMessage));
    }
  }

  Future<void> updateProfileNew(UpdateProfileRequest request) async {
    print('DEBUG: ProfileCubit.updateProfileNew called');
    print(
      'DEBUG: Request - name: ${request.name}, phone: ${request.phone}, birthDate: ${request.birthDate}',
    );
    print(
      'DEBUG: Request - oldPassword: ${request.oldPassword != null ? "***" : "null"}',
    );

    try {
      final currentState = state;
      print('DEBUG: Current state: ${currentState.runtimeType}');

      // بدء حالة التحديث فوراً
      UserProfile currentProfile;
      if (currentState is ProfileLoaded) {
        currentProfile = currentState.userProfile;
      } else if (currentState is ProfileUpdating) {
        currentProfile = currentState.currentProfile;
      } else if (currentState is ProfileImageUploading) {
        currentProfile = currentState.currentProfile;
      } else {
        // إذا لم يكن البروفايل محمل، نحمله أولاً
        print('DEBUG: Profile not loaded, loading first...');
        await getProfile();

        if (state is! ProfileLoaded) {
          print('DEBUG: Failed to load profile, cannot update');
          return;
        }
        currentProfile = (state as ProfileLoaded).userProfile;
      }

      print('DEBUG: Profile loaded, proceeding with update');
      if (!isClosed) emit(ProfileUpdating(currentProfile));

      print('DEBUG: Calling updateProfileUseCase');
      final updatedProfile = await updateProfileUseCase(request);
      print('DEBUG: UpdateProfileUseCase completed successfully');
      print('DEBUG: Updated profile name: ${updatedProfile.name}');

      print('DEBUG: Emitting ProfileUpdated');
      if (!isClosed) emit(ProfileUpdated(updatedProfile));

      print('DEBUG: Refreshing profile from server to get latest data');
      if (!isClosed) await getProfile();
    } catch (e) {
      print('DEBUG: Exception caught in updateProfileNew: $e');
      print('DEBUG: Exception type: ${e.runtimeType}');

      if (e is ApiException) {
        String errorMessage = e.getFirstErrorMessage();
        print('DEBUG: ApiException error message: $errorMessage');
        if (!isClosed) emit(ProfileError(errorMessage));
      } else {
        final errorMessage = ErrorHandler.extractErrorMessage(e);
        print('DEBUG: General error message: $errorMessage');
        if (!isClosed) emit(ProfileError(errorMessage));
      }
    }
  }

  void _refreshData() {
    getProfile();
  }

  @override
  Future<void> close() {
    dataRefreshService?.unregisterRefreshCallback(_refreshData);
    _refreshSubscription?.cancel();
    return super.close();
  }

  void resetState() {
    emit(ProfileInitial());
  }
}

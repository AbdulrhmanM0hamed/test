import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/core/models/api_response.dart';
import 'package:test/core/services/data_refresh_service.dart';
import 'package:test/core/utils/error/error_handler.dart';
import 'package:test/features/profile/domain/entities/update_profile_request.dart';
import 'package:test/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:test/features/profile/domain/usecases/update_profile_usecase.dart';
import 'package:test/features/profile/domain/repositories/profile_repository.dart';
import 'package:test/features/profile/presentation/cubit/profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetProfileUseCase getProfileUseCase;
  final UpdateProfileUseCase updateProfileUseCase;
  final ProfileRepository profileRepository;
  final DataRefreshService? dataRefreshService;

  ProfileCubit({
    required this.getProfileUseCase,
    required this.updateProfileUseCase,
    required this.profileRepository,
    this.dataRefreshService,
  }) : super(ProfileInitial()) {
    dataRefreshService?.registerRefreshCallback(_refreshData);
  }

  Future<void> getProfile() async {
    try {
      emit(ProfileLoading());
      final userProfile = await getProfileUseCase();
      emit(ProfileLoaded(userProfile));
    } catch (e) {
      final errorMessage = ErrorHandler.extractErrorMessage(e);
      emit(ProfileError(errorMessage));
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
        emit(ProfileUpdating(currentState.userProfile));

        final updatedProfile = await profileRepository.updateProfile(
          name: name,
          phone: phone,
          birthDate: birthDate,
          address: address,
          gender: gender,
        );

        emit(ProfileUpdated(updatedProfile));
        // Keep the updated profile loaded
        emit(ProfileLoaded(updatedProfile));
      }
    } catch (e) {
      final errorMessage = ErrorHandler.extractErrorMessage(e);
      emit(ProfileError(errorMessage));
    }
  }

  Future<void> updateProfileImage(String imagePath) async {
    try {
      final currentState = state;
      if (currentState is ProfileLoaded) {
        emit(ProfileImageUploading(currentState.userProfile));

        await profileRepository.updateProfileImage(imagePath);

        // Refresh profile to get updated image
        await getProfile();
      }
    } catch (e) {
      final errorMessage = ErrorHandler.extractErrorMessage(e);
      emit(ProfileError(errorMessage));
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

      // إذا لم يكن البروفايل محمل، نحمله أولاً
      if (currentState is ProfileInitial || currentState is ProfileError) {
        print('DEBUG: Profile not loaded, loading first...');
        await getProfile();

        // التحقق من نجاح التحميل
        if (state is! ProfileLoaded) {
          print('DEBUG: Failed to load profile, cannot update');
          return;
        }
      }

      final profileState = state as ProfileLoaded;
      print('DEBUG: Profile loaded, proceeding with update');
      emit(ProfileUpdating(profileState.userProfile));

      print('DEBUG: Calling updateProfileUseCase');
      final updatedProfile = await updateProfileUseCase(request);
      print('DEBUG: UpdateProfileUseCase completed successfully');
      print('DEBUG: Updated profile name: ${updatedProfile.name}');

      print('DEBUG: Emitting ProfileUpdated');
      emit(ProfileUpdated(updatedProfile));

      print('DEBUG: Emitting ProfileLoaded with updated profile');
      emit(ProfileLoaded(updatedProfile));
    } catch (e) {
      print('DEBUG: Exception caught in updateProfileNew: $e');
      print('DEBUG: Exception type: ${e.runtimeType}');

      if (e is ApiException) {
        String errorMessage = e.getFirstErrorMessage();
        print('DEBUG: ApiException error message: $errorMessage');
        emit(ProfileError(errorMessage));
      } else {
        final errorMessage = ErrorHandler.extractErrorMessage(e);
        print('DEBUG: General error message: $errorMessage');
        emit(ProfileError(errorMessage));
      }
    }
  }

  void _refreshData() {
    getProfile();
  }

  @override
  Future<void> close() {
    dataRefreshService?.unregisterRefreshCallback(_refreshData);
    return super.close();
  }

  void resetState() {
    emit(ProfileInitial());
  }
}

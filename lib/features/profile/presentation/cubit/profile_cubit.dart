import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/core/services/data_refresh_service.dart';
import 'package:test/core/utils/error/error_handler.dart';
import 'package:test/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:test/features/profile/domain/repositories/profile_repository.dart';
import 'package:test/features/profile/presentation/cubit/profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetProfileUseCase getProfileUseCase;
  final ProfileRepository profileRepository;
  final DataRefreshService? dataRefreshService;

  ProfileCubit({
    required this.getProfileUseCase,
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

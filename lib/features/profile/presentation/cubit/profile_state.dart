import 'package:test/features/profile/domain/entities/user_profile.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final UserProfile userProfile;

  ProfileLoaded(this.userProfile);
}

class ProfileUpdating extends ProfileState {
  final UserProfile currentProfile;

  ProfileUpdating(this.currentProfile);
}

class ProfileUpdated extends ProfileState {
  final UserProfile userProfile;

  ProfileUpdated(this.userProfile);
}

class ProfileImageUploading extends ProfileState {
  final UserProfile currentProfile;

  ProfileImageUploading(this.currentProfile);
}

class ProfileImageUpdated extends ProfileState {
  final UserProfile userProfile;

  ProfileImageUpdated(this.userProfile);
}

class ProfileError extends ProfileState {
  final String message;

  ProfileError(this.message);
}

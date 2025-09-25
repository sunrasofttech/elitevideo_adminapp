part of 'update_profile_cubit.dart';

sealed class UpdateProfileState extends Equatable {}

final class UpdateProfileInitial extends UpdateProfileState {
  @override
  List<Object?> get props => [];
}

final class UpdateProfileLoadingState extends UpdateProfileState {
  @override
  List<Object?> get props => [];
}

final class UpdateProfileLoadedState extends UpdateProfileState {
  @override
  List<Object?> get props => [];
}

final class UpdateProfileErrorState extends UpdateProfileState {
  final String error;
  UpdateProfileErrorState(this.error);
  @override
  List<Object?> get props => [error];
}
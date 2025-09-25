part of 'get_profile_cubit.dart';

sealed class GetProfileState extends Equatable {}

final class GetProfileInitial extends GetProfileState {
  @override
  List<Object?> get props => [];
}

final class GetProfileLoadingState extends GetProfileState {
  @override
  List<Object?> get props => [];
}


final class GetProfileErrorState extends GetProfileState {
  final String error;
  GetProfileErrorState(this.error);
  @override
  List<Object?> get props => [error];
}


final class GetProfileLoadedState extends GetProfileState {
  final GetAdminProfileModel model;
  GetProfileLoadedState(this.model);
  @override
  List<Object?> get props => [model];
}

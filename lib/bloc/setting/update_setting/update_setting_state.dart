part of 'update_setting_cubit.dart';

sealed class UpdateSettingState extends Equatable {}

final class UpdateSettingInitial extends UpdateSettingState {
  @override
  List<Object?> get props => [];
}

final class UpdateSettingLoadingState extends UpdateSettingState {
  @override
  List<Object?> get props => [];
}

final class UpdateSettingLoadedState extends UpdateSettingState {
  @override
  List<Object?> get props => [];
}

final class UpdateSettingErrorState extends UpdateSettingState {
  final String error;
  UpdateSettingErrorState(this.error);
  @override
  List<Object?> get props => [error];
}
part of 'get_setting_cubit.dart';

sealed class GetSettingState extends Equatable {}

final class GetSettingInitial extends GetSettingState {
  @override
  List<Object?> get props => [];
}

final class GetSettingLoadingState extends GetSettingState {
  @override
  List<Object?> get props => [];
}

final class GetSettingLoadedState extends GetSettingState {
  final GetSettingModel model;
  GetSettingLoadedState(this.model);
  @override
  List<Object?> get props => [model];
}

final class GetSettingErrorState extends GetSettingState {
  final String error;
  GetSettingErrorState(this.error);
  @override
  List<Object?> get props => [error];
}

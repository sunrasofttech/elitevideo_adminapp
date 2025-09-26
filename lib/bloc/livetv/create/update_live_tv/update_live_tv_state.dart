part of 'update_live_tv_cubit.dart';

sealed class UpdateLiveTvState extends Equatable {}

final class UpdateLiveTvInitial extends UpdateLiveTvState {
  @override
  List<Object?> get props => [];
}


final class UpdateLiveTvLoadingState extends UpdateLiveTvState {
  @override
  List<Object?> get props => [];
}

final class UpdateLiveTvLoadedState extends UpdateLiveTvState {
  @override
  List<Object?> get props => [];
}

final class UpdateLiveTvErrorState extends UpdateLiveTvState {
  final String error;
  UpdateLiveTvErrorState(this.error);
  @override
  List<Object?> get props => [error];
}

final class UpdateLiveProgressState extends UpdateLiveTvState {
  final int percent;
  UpdateLiveProgressState({required this.percent});
  @override
  List<Object?> get props => [percent];
}
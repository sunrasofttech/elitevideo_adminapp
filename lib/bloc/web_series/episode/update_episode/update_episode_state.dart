part of 'update_episode_cubit.dart';

sealed class UpdateEpisodeState extends Equatable {}

final class UpdateEpisodeInitial extends UpdateEpisodeState {
  @override
  List<Object?> get props => [];
}

final class UpdateEpisodeLoadingState extends UpdateEpisodeState {
  @override
  List<Object?> get props => [];
}

final class UpdateEpisodeLoadedState extends UpdateEpisodeState {
  @override
  List<Object?> get props => [];
}

final class UpdateEpisodeErrorState extends UpdateEpisodeState {
  final String error;
  UpdateEpisodeErrorState(this.error);
  @override
  List<Object?> get props => [error];
}

final class UpdateEpisodeProgressState extends UpdateEpisodeState {
  final int percent;
  UpdateEpisodeProgressState({required this.percent});
  @override
  List<Object?> get props => [percent];
}

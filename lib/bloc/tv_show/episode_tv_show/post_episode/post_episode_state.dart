part of 'post_episode_cubit.dart';

sealed class PostEpisodeState extends Equatable {}

final class PostEpisodeInitial extends PostEpisodeState {
  @override
  List<Object?> get props => [];
}

final class PostEpisodeLoadingState extends PostEpisodeState {
  @override
  List<Object?> get props => [];
}

final class PostEpisodeLoadedState extends PostEpisodeState {
  @override
  List<Object?> get props => [];
}

final class PostEpisodeErrorState extends PostEpisodeState {
  final String error;
  PostEpisodeErrorState(this.error);
  @override
  List<Object?> get props => [error];
}

final class PostEpisodeProgressState extends PostEpisodeState {
  final int percent;
  PostEpisodeProgressState({required this.percent});
  @override
  List<Object?> get props => [percent];
}
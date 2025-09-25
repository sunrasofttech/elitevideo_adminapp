part of 'delete_episode_cubit.dart';

sealed class DeleteEpisodeState extends Equatable {}

final class DeleteEpisodeInitial extends DeleteEpisodeState {
  @override
  List<Object?> get props => [];
}

final class DeleteEpisodeLoadingState extends DeleteEpisodeState {
  @override
  List<Object?> get props => [];
}

final class DeleteEpisodeLaodedState extends DeleteEpisodeState {
  @override
  List<Object?> get props => [];
}

final class DeleteEpisodeErrorState extends DeleteEpisodeState {
  final String error;
  DeleteEpisodeErrorState(this.error);
  @override
  List<Object?> get props => [error];
}

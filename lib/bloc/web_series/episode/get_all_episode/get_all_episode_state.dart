part of 'get_all_episode_cubit.dart';

sealed class GetAllEpisodeState extends Equatable {}

final class GetAllEpisodeInitial extends GetAllEpisodeState {
  @override
  List<Object?> get props => [];
}

final class GetAllEpisodeLoadingState extends GetAllEpisodeState {
  @override
  List<Object?> get props => [];
}

final class GetAllEpisodeLoadedState extends GetAllEpisodeState {
  final GetEpisodeModel model;
  GetAllEpisodeLoadedState(this.model);
  @override
  List<Object?> get props => [];
}

final class GetAllEpisodeErrorState extends GetAllEpisodeState {
  final String error;
  GetAllEpisodeErrorState(this.error);
  @override
  List<Object?> get props => [error];
}

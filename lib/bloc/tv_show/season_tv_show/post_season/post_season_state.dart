part of 'post_season_cubit.dart';

sealed class PostSeasonState extends Equatable {}

final class PostSeasonInitial extends PostSeasonState {
  @override
  List<Object?> get props => [];
}

final class PostSeasonLoadingState extends PostSeasonState {
  @override
  List<Object?> get props => [];
}

final class PostSeasonLoadedState extends PostSeasonState {
  @override
  List<Object?> get props => [];
}

final class PostSeasonErrorState extends PostSeasonState {
  final String error;
  PostSeasonErrorState(this.error);
  @override
  List<Object?> get props => [error];
}
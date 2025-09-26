part of 'post_movie_cubit.dart';

sealed class PostMovieState extends Equatable {}

final class PostMovieInitial extends PostMovieState {
  @override
  List<Object?> get props => [];
}

final class PostMovieLoadingState extends PostMovieState {
  @override
  List<Object?> get props => [];
}


final class PostMovieProgressState extends PostMovieState {
  final int percent;
  final Duration eta;

  PostMovieProgressState({required this.percent, required this.eta});

  @override
  List<Object?> get props => [percent, eta];
}

final class PostMovieLoadedState extends PostMovieState {
  @override
  List<Object?> get props => [];
}

final class PostMovieErrorState extends PostMovieState {
  final String error;
  PostMovieErrorState(this.error);
  @override
  List<Object?> get props => [error];
}

part of 'update_movie_cubit.dart';

sealed class UpdateMovieState extends Equatable {}

final class UpdateMovieInitial extends UpdateMovieState {
  @override
  List<Object?> get props => [];
}

final class UpdateMovieLoadingState extends UpdateMovieState {
  @override
  List<Object?> get props => [];
}

final class UpdateMovieProgressState extends UpdateMovieState {
  final int percent;
  final Duration eta;

  UpdateMovieProgressState({required this.percent, required this.eta});

  @override
  List<Object?> get props => [percent, eta];
}

final class UpdateMovieLoadedState extends UpdateMovieState {
  @override
  List<Object?> get props => [];
}

final class UpdateMovieErrorState extends UpdateMovieState {
  final String error;
  UpdateMovieErrorState(this.error);
  @override
  List<Object?> get props => [error];
}

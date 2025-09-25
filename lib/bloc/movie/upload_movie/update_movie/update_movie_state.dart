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

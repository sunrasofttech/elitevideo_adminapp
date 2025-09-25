part of 'delete_movie_cubit.dart';

sealed class DeleteMovieState extends Equatable {}

final class DeleteMovieInitial extends DeleteMovieState {
  @override
  List<Object?> get props => [];
}

final class DeleteMovieLoadingState extends DeleteMovieState {
  @override
  List<Object?> get props => [];
}

final class DeleteMovieLoadedState extends DeleteMovieState {
  @override
  List<Object?> get props => [];
}

final class DeleteMovieErrorState extends DeleteMovieState {
  final String error;
  DeleteMovieErrorState(this.error);
  @override
  List<Object?> get props => [error];
}

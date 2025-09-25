part of 'get_all_movie_cubit.dart';

sealed class GetAllMovieState extends Equatable {}

final class GetAllMovieInitial extends GetAllMovieState {
  @override
  List<Object?> get props => [];
}

final class GetAllMovieLoadingState extends GetAllMovieState {
  @override
  List<Object?> get props => [];
}

final class GetAllMovieLaodedState extends GetAllMovieState {
  final GetAllMoviesModel model;
  GetAllMovieLaodedState(this.model);
  @override
  List<Object?> get props => [model];
}

final class GetAllMovieErrorState extends GetAllMovieState {
  final String error;
  GetAllMovieErrorState(this.error);
  @override
  List<Object?> get props => [error];
}

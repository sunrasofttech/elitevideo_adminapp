part of 'get_all_genre_cubit.dart';

sealed class GetAllGenreState extends Equatable {}

final class GetAllGenreInitial extends GetAllGenreState {
  @override
  List<Object?> get props => [];
}

final class GetAllGenreLoadingState extends GetAllGenreState {
  @override
  List<Object?> get props => [];
}

final class GetAllGenreLaodedState extends GetAllGenreState {
  final GetGenreModel model;
  GetAllGenreLaodedState(this.model);
  @override
  List<Object?> get props => [model];
}

final class GetAllGenreErrorState extends GetAllGenreState {
  final String error;
  GetAllGenreErrorState(this.error);
  @override
  List<Object?> get props => [error];
}

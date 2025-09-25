part of 'delete_genre_cubit.dart';

sealed class DeleteGenreState extends Equatable {}

final class DeleteGenreInitial extends DeleteGenreState {
  @override
  List<Object?> get props => [];
}

final class DeleteGenreLoadingState extends DeleteGenreState {
  @override
  List<Object?> get props => [];
}

final class DeleteGenreLoadedState extends DeleteGenreState {
  @override
  List<Object?> get props => [];
}

final class DeleteGenreErrorState extends DeleteGenreState {
  final String error;
  DeleteGenreErrorState(this.error);
  @override
  List<Object?> get props => [error];
}
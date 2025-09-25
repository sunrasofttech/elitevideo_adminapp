part of 'update_genre_cubit.dart';

sealed class UpdateGenreState extends Equatable {}

final class UpdateGenreInitial extends UpdateGenreState {
  @override
  List<Object?> get props => [];
}

final class UpdateGenreLoadingState extends UpdateGenreState {
  @override
  List<Object?> get props => [];
}

final class UpdateGenreLoadedState extends UpdateGenreState {
  @override
  List<Object?> get props => [];
}

final class UpdateGenreErrorState extends UpdateGenreState {
  final String error;
  UpdateGenreErrorState(this.error);
  @override
  List<Object?> get props => [error];
}

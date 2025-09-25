part of 'post_genre_cubit.dart';

sealed class PostGenreState extends Equatable {}

final class PostGenreInitial extends PostGenreState {
  @override
  List<Object?> get props => [];
}


final class PostGenreLoadingState extends PostGenreState {
  @override
  List<Object?> get props => [];
}

final class PostGenreLaodedState extends PostGenreState {
  @override
  List<Object?> get props => [];
}

final class PostGenreErrorState extends PostGenreState {
  final String error;
  PostGenreErrorState(this.error);
  @override
  List<Object?> get props => [error];
}
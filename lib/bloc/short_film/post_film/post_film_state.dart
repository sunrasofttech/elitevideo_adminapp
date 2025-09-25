part of 'post_film_cubit.dart';

sealed class PostFilmState extends Equatable {}

final class PostFilmInitial extends PostFilmState {
  @override
  List<Object?> get props => [];
}

final class PostFilmLoadingState extends PostFilmState {
  @override
  List<Object?> get props => [];
}

final class PostFilmLoadedState extends PostFilmState {
  @override
  List<Object?> get props => [];
}

final class PostFilmErrorState extends PostFilmState {
  final String error;
  PostFilmErrorState(this.error);
  @override
  List<Object?> get props => [error];
}

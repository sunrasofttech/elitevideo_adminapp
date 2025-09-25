part of 'update_film_cubit.dart';

sealed class UpdateFilmState extends Equatable {}

final class UpdateFilmInitial extends UpdateFilmState {
  @override
  List<Object?> get props => [];
}

final class UpdateFilmLoadingState extends UpdateFilmState {
  @override
  List<Object?> get props => [];
}

final class UpdateFilmLoadedState extends UpdateFilmState {
  @override
  List<Object?> get props => [];
}

final class UpdateFilmErrorState extends UpdateFilmState {
  final String error;
  UpdateFilmErrorState(this.error);
  @override
  List<Object?> get props => [error];
}

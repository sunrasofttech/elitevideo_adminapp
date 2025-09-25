part of 'create_short_film_castcrew_cubit.dart';

sealed class CreateShortFilmCastcrewState extends Equatable {}

final class CreateShortFilmCastcrewInitial extends CreateShortFilmCastcrewState {
  @override
  List<Object?> get props => [];
}


final class CreateShortFilmCastcrewLoadingState extends CreateShortFilmCastcrewState {
  @override
  List<Object?> get props => [];
}


final class CreateShortFilmCastcrewLoadedState extends CreateShortFilmCastcrewState {
  @override
  List<Object?> get props => [];
}

final class CreateShortFilmCastcrewErrorState extends CreateShortFilmCastcrewState {
  final String error;
  CreateShortFilmCastcrewErrorState(this.error);
  @override
  List<Object?> get props => [error];
}
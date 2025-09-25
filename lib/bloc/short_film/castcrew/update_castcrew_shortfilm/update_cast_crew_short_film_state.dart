part of 'update_cast_crew_short_film_cubit.dart';

sealed class UpdateCastCrewShortFilmState extends Equatable {}

final class UpdateCastCrewShortFilmInitial extends UpdateCastCrewShortFilmState {
  @override
  List<Object?> get props => [];
}


final class UpdateCastCrewShortFilmLoadingState extends UpdateCastCrewShortFilmState {
  @override
  List<Object?> get props => [];
}


final class UpdateCastCrewShortFilmLaodedState extends UpdateCastCrewShortFilmState {
  @override
  List<Object?> get props => [];
}


final class UpdateCastCrewShortFilmErrorState extends UpdateCastCrewShortFilmState {
  final String error;
  UpdateCastCrewShortFilmErrorState(this.error);
  @override
  List<Object?> get props => [error];
}
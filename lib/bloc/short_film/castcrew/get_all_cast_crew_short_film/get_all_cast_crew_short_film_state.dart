part of 'get_all_cast_crew_short_film_cubit.dart';

sealed class GetAllCastCrewShortFilmState extends Equatable {}

final class GetAllCastCrewShortFilmInitial extends GetAllCastCrewShortFilmState {
  @override
  List<Object?> get props => [];
}

final class GetAllCastCrewShortFilmLoadingState extends GetAllCastCrewShortFilmState {
  @override
  List<Object?> get props => [];
}

final class GetAllCastCrewShortFilmLoadedState extends GetAllCastCrewShortFilmState {
  final GetCastCrewShortFilmModel model;
  GetAllCastCrewShortFilmLoadedState(this.model);
  @override
  List<Object?> get props => [model];
}

final class GetAllCastCrewShortFilmErrorState extends GetAllCastCrewShortFilmState {
  final String error;
  GetAllCastCrewShortFilmErrorState(this.error);
  @override
  List<Object?> get props => [];
}

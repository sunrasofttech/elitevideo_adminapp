part of 'create_cast_crew_webseries_cubit.dart';

sealed class CreateCastCrewTvShowState extends Equatable {}

final class CreateCastCrewTvShowInitial extends CreateCastCrewTvShowState {
  @override
  List<Object?> get props => [];
}


final class CreateCastCrewTvShowLoadingState extends CreateCastCrewTvShowState {
  @override
  List<Object?> get props => [];
}


final class CreateCastCrewTvShowLoadedState extends CreateCastCrewTvShowState {
  @override
  List<Object?> get props => [];
}


final class CreateCastCrewTvShowErrorState extends CreateCastCrewTvShowState {
  final String error;
  CreateCastCrewTvShowErrorState(this.error);
  @override
  List<Object?> get props => [error];
}
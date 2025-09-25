part of 'create_cast_crew_webseries_cubit.dart';

sealed class CreateCastCrewWebseriesState extends Equatable {}

final class CreateCastCrewWebseriesInitial extends CreateCastCrewWebseriesState {
  @override
  List<Object?> get props => [];
}


final class CreateCastCrewWebseriesLoadingState extends CreateCastCrewWebseriesState {
  @override
  List<Object?> get props => [];
}


final class CreateCastCrewWebseriesLoadedState extends CreateCastCrewWebseriesState {
  @override
  List<Object?> get props => [];
}


final class CreateCastCrewWebseriesErrorState extends CreateCastCrewWebseriesState {
  final String error;
  CreateCastCrewWebseriesErrorState(this.error);
  @override
  List<Object?> get props => [error];
}
part of 'update_cast_crew_webseries_cubit.dart';

sealed class UpdateCastCrewWebseriesState extends Equatable {}

final class UpdateCastCrewWebseriesInitial extends UpdateCastCrewWebseriesState {
  @override
  List<Object?> get props => [];
}

final class UpdateCastCrewWebseriesLoadingState extends UpdateCastCrewWebseriesState {
  @override
  List<Object?> get props => [];
}

final class UpdateCastCrewWebseriesLoadedState extends UpdateCastCrewWebseriesState {
  @override
  List<Object?> get props => [];
}

final class UpdateCastCrewWebseriesErrorState extends UpdateCastCrewWebseriesState {
  final String error;
  UpdateCastCrewWebseriesErrorState(this.error);
  @override
  List<Object?> get props => [error];
}

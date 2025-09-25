part of 'get_all_cast_crew_webseries_cubit.dart';

sealed class GetAllCastCrewWebseriesState extends Equatable {}

final class GetAllCastCrewWebseriesInitial extends GetAllCastCrewWebseriesState {
  @override
  List<Object?> get props => [];
}

final class GetAllCastCrewWebseriesLoadingState extends GetAllCastCrewWebseriesState {
  @override
  List<Object?> get props => [];
}

final class GetAllCastCrewWebseriesLoadedState extends GetAllCastCrewWebseriesState {
  final GetCastCrewWebSeriesModel model;
  GetAllCastCrewWebseriesLoadedState(this.model);
  @override
  List<Object?> get props => [model];
}

final class GetAllCastCrewWebseriesErrorState extends GetAllCastCrewWebseriesState {
  final String error;
  GetAllCastCrewWebseriesErrorState(this.error);
  @override
  List<Object?> get props => [error];
}
part of 'get_all_cast_crew_tv_show_cubit.dart';

sealed class GetAllCastCrewTvShowState extends Equatable {}

final class GetAllCastCrewTvShowInitial extends GetAllCastCrewTvShowState {
  @override
  List<Object?> get props => [];
}

final class GetAllCastCrewTvShowLoadingState extends GetAllCastCrewTvShowState {
  @override
  List<Object?> get props => [];
}

final class GetAllCastCrewTvShowLoadedState extends GetAllCastCrewTvShowState {
  final GetCastCrewWebSeriesModel model;
  GetAllCastCrewTvShowLoadedState(this.model);
  @override
  List<Object?> get props => [model];
}

final class GetAllCastCrewTvShowErrorState extends GetAllCastCrewTvShowState {
  final String error;
  GetAllCastCrewTvShowErrorState(this.error);
  @override
  List<Object?> get props => [error];
}

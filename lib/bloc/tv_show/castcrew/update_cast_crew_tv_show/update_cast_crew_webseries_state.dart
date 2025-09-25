part of 'update_cast_crew_webseries_cubit.dart';

sealed class UpdateCastCrewTvShowState extends Equatable {}

final class UpdateCastCrewTvShowInitial extends UpdateCastCrewTvShowState {
  @override
  List<Object?> get props => [];
}

final class UpdateCastCrewTvShowLoadingState extends UpdateCastCrewTvShowState {
  @override
  List<Object?> get props => [];
}

final class UpdateCastCrewTvShowLoadedState extends UpdateCastCrewTvShowState {
  @override
  List<Object?> get props => [];
}

final class UpdateCastCrewTvShowErrorState extends UpdateCastCrewTvShowState {
  final String error;
  UpdateCastCrewTvShowErrorState(this.error);
  @override
  List<Object?> get props => [error];
}

part of 'update_season_cubit.dart';

sealed class UpdateSeasonState extends Equatable {}

final class UpdateSeasonInitial extends UpdateSeasonState {
  @override
  List<Object?> get props => [];
}

final class UpdateSeasonLoadingState extends UpdateSeasonState {
  @override
  List<Object?> get props => [];
}

final class UpdateSeasonLoadedState extends UpdateSeasonState {
  @override
  List<Object?> get props => [];
}

final class UpdateSeasonErrorState extends UpdateSeasonState {
  final String error;
  UpdateSeasonErrorState(this.error);
  @override
  List<Object?> get props => [error];
}
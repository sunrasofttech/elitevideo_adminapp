part of 'get_all_season_cubit.dart';

sealed class GetAllSeasonState extends Equatable {}

final class GetAllSeasonInitial extends GetAllSeasonState {
  @override
  List<Object?> get props => [];
}

final class GetAllSeasonLoadingState extends GetAllSeasonState {
  @override
  List<Object?> get props => [];
}

final class GetAllSeasonLoadedState extends GetAllSeasonState {
  final GetSeasonModel model;
  GetAllSeasonLoadedState(this.model);
  @override
  List<Object?> get props => [model];
}

final class GetAllSeasonErrorState extends GetAllSeasonState {
  final String error;
  GetAllSeasonErrorState(this.error);
  @override
  List<Object?> get props => [error];
}

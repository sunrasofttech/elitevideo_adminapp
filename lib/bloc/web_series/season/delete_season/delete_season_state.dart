part of 'delete_season_cubit.dart';

sealed class DeleteSeasonState extends Equatable {}

final class DeleteSeasonInitial extends DeleteSeasonState {
  @override
  List<Object?> get props => [];
}

final class DeleteSeasonLoadingState extends DeleteSeasonState {
  @override
  List<Object?> get props => [];
}

final class DeleteSeasonLoadedState extends DeleteSeasonState {
  @override
  List<Object?> get props => [];
}

final class DeleteSeasonErrorState extends DeleteSeasonState {
  final String error;
  DeleteSeasonErrorState(this.error);
  @override
  List<Object?> get props => [error];
}

part of 'update_series_cubit.dart';

sealed class UpdateSeriesState extends Equatable {}

final class UpdateSeriesInitial extends UpdateSeriesState {
  @override
  List<Object?> get props => [];
}

final class UpdateSeriesLoadingState extends UpdateSeriesState {
  @override
  List<Object?> get props => [];
}

final class UpdateSeriesLoadedState extends UpdateSeriesState {
  @override
  List<Object?> get props => [];
}

final class UpdateSeriesErrorState extends UpdateSeriesState {
  final String error;
  UpdateSeriesErrorState(this.error);
  @override
  List<Object?> get props => [error];
}

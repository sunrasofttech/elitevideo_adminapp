part of 'update_tv_show_cubit.dart';

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

final class UpdateSeriesProgressState extends UpdateSeriesState {
  final int percent;
  UpdateSeriesProgressState({required this.percent});
  @override
  List<Object?> get props => [percent];
}

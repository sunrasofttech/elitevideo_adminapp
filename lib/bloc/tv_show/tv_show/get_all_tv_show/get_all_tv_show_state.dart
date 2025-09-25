part of 'get_all_tv_show_cubit.dart';

sealed class GetAllSeriesState extends Equatable {}

final class GetAllSeriesInitial extends GetAllSeriesState {
  @override
  List<Object?> get props => [];
}

final class GetAllSeriesLoadingState extends GetAllSeriesState {
  @override
  List<Object?> get props => [];
}

final class GetAllSeriesLoadedState extends GetAllSeriesState {
  final GetSeriesModel model;
  GetAllSeriesLoadedState(this.model);
  @override
  List<Object?> get props => [model];
}

final class GetAllSeriesErrorState extends GetAllSeriesState {
  final String error;
  GetAllSeriesErrorState(this.error);
  @override
  List<Object?> get props => [error];
}

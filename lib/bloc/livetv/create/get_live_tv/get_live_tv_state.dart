part of 'get_live_tv_cubit.dart';

sealed class GetLiveTvState extends Equatable {}

final class GetLiveTvInitial extends GetLiveTvState {
  @override
  List<Object?> get props => [];
}

final class GetLiveTvLoadingState extends GetLiveTvState {
  @override
  List<Object?> get props => [];
}

final class GetLiveTvLoadedState extends GetLiveTvState {
  final GetLiveModel model;
  GetLiveTvLoadedState(this.model);
  @override
  List<Object?> get props => [model];
}

final class GetLiveTvErrorState extends GetLiveTvState {
  final String error;
  GetLiveTvErrorState(this.error);
  @override
  List<Object?> get props => [error];
}
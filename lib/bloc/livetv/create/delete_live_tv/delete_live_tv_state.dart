part of 'delete_live_tv_cubit.dart';

sealed class DeleteLiveTvState extends Equatable {}

final class DeleteLiveTvInitial extends DeleteLiveTvState {
  @override
  List<Object?> get props => [];
}

final class DeleteLiveTvLoadingState extends DeleteLiveTvState {
  @override
  List<Object?> get props => [];
}

final class DeleteLiveTvLoadedState extends DeleteLiveTvState {
  @override
  List<Object?> get props => [];
}

final class DeleteLiveTvErrorState extends DeleteLiveTvState {
  final String error;
  DeleteLiveTvErrorState(this.error);
  @override
  List<Object?> get props => [error];
}

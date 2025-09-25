part of 'get_all_castcrew_cubit.dart';

sealed class GetAllCastcrewState extends Equatable {}

final class GetAllCastcrewInitial extends GetAllCastcrewState {
  @override
  List<Object?> get props => [];
}

final class GetAllCastcrewLoadingState extends GetAllCastcrewState {
  @override
  List<Object?> get props => [];
}

final class GetAllCastcrewLoadedState extends GetAllCastcrewState {
  final GetAllCastCrewModel model;
  GetAllCastcrewLoadedState(this.model);
  @override
  List<Object?> get props => [model];
}

final class GetAllCastcrewErrorState extends GetAllCastcrewState {
  final String error;
  GetAllCastcrewErrorState(this.error);
  @override
  List<Object?> get props => [error];
}

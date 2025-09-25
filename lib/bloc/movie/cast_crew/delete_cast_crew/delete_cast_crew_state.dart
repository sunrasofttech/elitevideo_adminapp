part of 'delete_cast_crew_cubit.dart';

sealed class DeleteCastCrewState extends Equatable {}

final class DeleteCastCrewInitial extends DeleteCastCrewState {
  @override
  List<Object?> get props => [];
}

final class DeleteCastCrewLoadingState extends DeleteCastCrewState {
  @override
  List<Object?> get props => [];
}


final class DeleteCastCrewLaodedState extends DeleteCastCrewState {
  @override
  List<Object?> get props => [];
}


final class DeleteCastCrewErrorState extends DeleteCastCrewState {
  final String error;
  DeleteCastCrewErrorState(this.error);
  @override
  List<Object?> get props => [error];
}

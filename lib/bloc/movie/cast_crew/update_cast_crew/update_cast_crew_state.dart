part of 'update_cast_crew_cubit.dart';

sealed class UpdateCastCrewState extends Equatable {}

final class UpdateCastCrewInitial extends UpdateCastCrewState {
  @override
  List<Object?> get props => [];
}

final class UpdateCastCrewLoadingState extends UpdateCastCrewState {
  @override
  List<Object?> get props => [];
}


final class UpdateCastCrewLoadedState extends UpdateCastCrewState {
  @override
  List<Object?> get props => [];
}


final class UpdateCastCrewErrorState extends UpdateCastCrewState {
  final String error;
  UpdateCastCrewErrorState(this.error);
  @override
  List<Object?> get props => [error];
}

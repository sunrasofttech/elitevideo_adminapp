part of 'create_castcrew_cubit.dart';

sealed class CreateCastcrewState extends Equatable {}

final class CreateCastcrewInitial extends CreateCastcrewState {
  @override
  List<Object?> get props => [];
}

final class CreateCastcrewLoadingState extends CreateCastcrewState {
  @override
  List<Object?> get props => [];
}

final class CreateCastcrewLoadedState extends CreateCastcrewState {
  @override
  List<Object?> get props => [];
}

final class CreateCastcrewErrorState extends CreateCastcrewState {
  final String error;
  CreateCastcrewErrorState(this.error);
  @override
  List<Object?> get props => [error];
}

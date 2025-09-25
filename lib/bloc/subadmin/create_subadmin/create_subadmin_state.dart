part of 'create_subadmin_cubit.dart';

sealed class CreateSubadminState extends Equatable {}

final class CreateSubadminInitial extends CreateSubadminState {
  @override
  List<Object?> get props => [];
}

final class CreateSubadminLoadingState extends CreateSubadminState {
  @override
  List<Object?> get props => [];
}

final class CreateSubadminLoadedState extends CreateSubadminState {
  @override
  List<Object?> get props => [];
}

final class CreateSubadminErrorState extends CreateSubadminState {
  final String erorr;
  CreateSubadminErrorState(this.erorr);
  @override
  List<Object?> get props => [erorr];
}

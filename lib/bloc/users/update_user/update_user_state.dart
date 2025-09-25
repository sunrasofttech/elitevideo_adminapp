part of 'update_user_cubit.dart';

sealed class UpdateUserState extends Equatable {}

final class UpdateUserInitial extends UpdateUserState {
  @override
  List<Object?> get props => [];
}

final class UpdateUserLoadingState extends UpdateUserState {
  @override
  List<Object?> get props => [];
}

final class UpdateUserLoadedState extends UpdateUserState {
  @override
  List<Object?> get props => [];
}

final class UpdateUserErrorState extends UpdateUserState {
  final String error;
  UpdateUserErrorState(this.error);
  @override
  List<Object?> get props => [error];
}

part of 'delete_user_cubit.dart';

sealed class DeleteUserState extends Equatable {}

final class DeleteUserInitial extends DeleteUserState {
  @override
  List<Object?> get props => [];
}

final class DeleteUserLoadingState extends DeleteUserState {
  @override
  List<Object?> get props => [];
}

final class DeleteUserLoadedState extends DeleteUserState {
  @override
  List<Object?> get props => [];
}

final class DeleteUserErrorState extends DeleteUserState {
  final String error;
  DeleteUserErrorState(this.error);
  @override
  List<Object?> get props => [error];
}

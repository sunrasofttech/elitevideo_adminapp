part of 'get_all_user_cubit.dart';

sealed class GetAllUserState extends Equatable {}

final class GetAllUserInitial extends GetAllUserState {
  @override
  List<Object?> get props => [];
}

final class GetAllUserLoadingState extends GetAllUserState {
  @override
  List<Object?> get props => [];
}

final class GetAllUserLoadedState extends GetAllUserState {
  final GetAllUserModel model;
  GetAllUserLoadedState(this.model);
  @override
  List<Object?> get props => [model];
}

final class GetAllUserErrorState extends GetAllUserState {
  final String error;
  GetAllUserErrorState(this.error);
  @override
  List<Object?> get props => [error];
}
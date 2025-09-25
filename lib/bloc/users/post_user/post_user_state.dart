part of 'post_user_cubit.dart';

sealed class PostUserState extends Equatable {}

final class PostUserInitial extends PostUserState {
  @override
  List<Object?> get props => [];
}

final class PostUserLoadingState extends PostUserState {
  @override
  List<Object?> get props => [];
}

final class PostUserLoadedState extends PostUserState {
  @override
  List<Object?> get props => [];
}

final class PostUserErrorState extends PostUserState {
  final String error;
  PostUserErrorState(this.error);
  @override
  List<Object?> get props => [error];
}

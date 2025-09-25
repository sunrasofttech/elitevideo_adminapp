part of 'login_cubit.dart';

sealed class LoginState extends Equatable {}

final class LoginInitial extends LoginState {
  @override
  List<Object?> get props => [];
}

final class LoginLoadingState extends LoginState {
  @override
  List<Object?> get props => [];
}

final class LoginLoadededState extends LoginState {
  final LoginModel model;
  LoginLoadededState(this.model);
  @override
  List<Object?> get props => [model];
}

final class LoginErrorState extends LoginState {
  final String error;
  LoginErrorState(this.error);
  @override
  List<Object?> get props => [error];
}
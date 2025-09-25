part of 'delete_admin_cubit.dart';

sealed class DeleteAdminState extends Equatable {}

final class DeleteAdminInitial extends DeleteAdminState {
  @override
  List<Object?> get props => [];
}

final class DeleteAdminLoadingState extends DeleteAdminState {
  @override
  List<Object?> get props => [];
}

final class DeleteAdminLoadedState extends DeleteAdminState {
  @override
  List<Object?> get props => [];
}

final class DeleteAdminErrorState extends DeleteAdminState {
  final String error;
  DeleteAdminErrorState(this.error);
  @override
  List<Object?> get props => [error];
}

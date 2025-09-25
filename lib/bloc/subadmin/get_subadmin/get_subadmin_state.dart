part of 'get_subadmin_cubit.dart';

sealed class GetSubadminState extends Equatable {}

final class GetSubadminInitial extends GetSubadminState {
  @override
  List<Object?> get props => [];
}

final class GetSubadminLoadingState extends GetSubadminState {
  @override
  List<Object?> get props => [];
}

final class GetSubadminLaodedState extends GetSubadminState {
  final GetAllSubAdminModel model;
  GetSubadminLaodedState(this.model);
  @override
  List<Object?> get props => [model];
}

final class GetSubadminErrorState extends GetSubadminState {
  final String error;
  GetSubadminErrorState(this.error);
  @override
  List<Object?> get props => [error];
}

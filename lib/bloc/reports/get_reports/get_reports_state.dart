part of 'get_reports_cubit.dart';

sealed class GetReportsState extends Equatable {}

final class GetReportsInitial extends GetReportsState {
  @override
  List<Object?> get props => [];
}

final class GetReportsLoadingState extends GetReportsState {
  @override
  List<Object?> get props => [];
}

final class GetReportsLoadedState extends GetReportsState {
  final GetReportModel model;
  GetReportsLoadedState(this.model);
  @override
  List<Object?> get props => [model];
}

final class GetReportsErrorState extends GetReportsState {
  final String error;
  GetReportsErrorState(this.error);
  @override
  List<Object?> get props => [error];
}

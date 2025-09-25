part of 'get_revenue_anaylsis_cubit.dart';

sealed class GetRevenueAnaylsisState extends Equatable {}

final class GetRevenueAnaylsisInitial extends GetRevenueAnaylsisState {
  @override
  List<Object?> get props => [];
}

final class GetRevenueAnaylsisLoadingState extends GetRevenueAnaylsisState {
  @override
  List<Object?> get props => [];
}


final class GetRevenueAnaylsisLoadedState extends GetRevenueAnaylsisState {
  final GetRevenueModel model;
  GetRevenueAnaylsisLoadedState(this.model);
  @override
  List<Object?> get props => [model];
}


final class GetRevenueAnaylsisErrorState extends GetRevenueAnaylsisState {
  final String error;
  GetRevenueAnaylsisErrorState(this.error);
  @override
  List<Object?> get props => [error];
}

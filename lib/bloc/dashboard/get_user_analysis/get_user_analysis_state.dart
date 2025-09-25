part of 'get_user_analysis_cubit.dart';

sealed class GetUserAnalysisState extends Equatable {}

final class GetUserAnalysisInitial extends GetUserAnalysisState {
  @override
  List<Object?> get props => [];
}

final class GetUserAnalysisLoadingState extends GetUserAnalysisState {
  @override
  List<Object?> get props => [];
}

final class GetUserAnalysisLoadedState extends GetUserAnalysisState {
  final GetUserAnalysisModel model;
  GetUserAnalysisLoadedState(this.model);
  @override
  List<Object?> get props => [model];
}

final class GetUserAnalysisErrorState extends GetUserAnalysisState {
  final String error;
  GetUserAnalysisErrorState(this.error);
  @override
  List<Object?> get props => [error];
}

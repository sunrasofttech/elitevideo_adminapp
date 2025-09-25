part of 'delete_tv_show_cubit.dart';

sealed class DeleteSeriesState extends Equatable {}

final class DeleteSeriesInitial extends DeleteSeriesState {
  @override
  List<Object?> get props => [];
}

final class DeleteSeriesLoadingState extends DeleteSeriesState {
  @override
  List<Object?> get props => [];
}


final class DeleteSeriesLoadedState extends DeleteSeriesState {
  @override
  List<Object?> get props => [];
}

final class DeleteSeriesErrorState extends DeleteSeriesState {
  final String error;
  DeleteSeriesErrorState(this.error);
  @override
  List<Object?> get props => [error];
}

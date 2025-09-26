part of 'post_tv_show_cubit.dart';

sealed class PostSeriesState extends Equatable {}

final class PostSeriesInitial extends PostSeriesState {
  @override
  List<Object?> get props => [];
}

final class PostSeriesLoadingState extends PostSeriesState {
  @override
  List<Object?> get props => [];
}

final class PostSeriesLoadedState extends PostSeriesState {
  @override
  List<Object?> get props => [];
}

final class PostSeriesErrorState extends PostSeriesState {
  final String error;
  PostSeriesErrorState(this.error);
  @override
  List<Object?> get props => [error];
}

final class PostSeriesProgressState extends PostSeriesState {
  final int percent;
 PostSeriesProgressState({required this.percent});
  @override
  List<Object?> get props => [percent];
}
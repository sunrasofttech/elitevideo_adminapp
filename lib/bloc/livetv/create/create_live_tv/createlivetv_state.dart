part of 'createlivetv_cubit.dart';

sealed class CreatelivetvState extends Equatable {}

final class CreatelivetvInitial extends CreatelivetvState {
  @override
  List<Object?> get props => [];
}

final class CreatelivetvLoadingState extends CreatelivetvState {
  @override
  List<Object?> get props => [];
}

final class CreatelivetvLoadedState extends CreatelivetvState {
  @override
  List<Object?> get props => [];
}

final class CreatelivetvErrorState extends CreatelivetvState {
  final String error;
  CreatelivetvErrorState(this.error);
  @override
  List<Object?> get props => [error];
}

final class CreateFilmProgressState extends CreatelivetvState {
  final int percent;
  CreateFilmProgressState({required this.percent});
  @override
  List<Object?> get props => [percent];
}

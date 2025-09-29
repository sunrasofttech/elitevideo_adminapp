part of 'delete_trailer_cubit.dart';

sealed class DeleteTrailerState extends Equatable {}

final class DeleteTrailerInitial extends DeleteTrailerState {
  @override
  List<Object?> get props => [];
}

final class DeleteTrailerLoadingState extends DeleteTrailerState {
  @override
  List<Object?> get props => [];
}

final class DeleteTrailerLoadedState extends DeleteTrailerState {
  @override
  List<Object?> get props => [];
}

final class DeleteTrailerErrorState extends DeleteTrailerState {
  final String error;
  DeleteTrailerErrorState(this.error);
  @override
  List<Object?> get props => [error];
}
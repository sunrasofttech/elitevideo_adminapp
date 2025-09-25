part of 'delete_film_cubit.dart';

sealed class DeleteFilmState extends Equatable {}

final class DeleteFilmInitial extends DeleteFilmState {
  @override
  List<Object?> get props => [];
}

final class DeleteFilmLoadingState extends DeleteFilmState {
  @override
  List<Object?> get props => [];
}


final class DeleteFilmLoadedState extends DeleteFilmState {
  @override
  List<Object?> get props => [];
}


final class DeleteFilmErrorState extends DeleteFilmState {
  final String error;
  DeleteFilmErrorState(this.error);
  @override
  List<Object?> get props => [error];
}

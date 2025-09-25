part of 'get_all_short_film_cubit.dart';

sealed class GetAllShortFilmState extends Equatable {}

final class GetAllShortFilmInitial extends GetAllShortFilmState {
  @override
  List<Object?> get props => [];
}

final class GetAllShortFilmLoadingState extends GetAllShortFilmState {
  @override
  List<Object?> get props => [];
}

final class GetAllShortFilmLoadedState extends GetAllShortFilmState {
  final GetAllShortFilmModel model;
  GetAllShortFilmLoadedState(this.model);
  @override
  List<Object?> get props => [];
}

final class GetAllShortFilmErrorState extends GetAllShortFilmState {
  final String error;
  GetAllShortFilmErrorState(this.error);
  @override
  List<Object?> get props => [error];
}

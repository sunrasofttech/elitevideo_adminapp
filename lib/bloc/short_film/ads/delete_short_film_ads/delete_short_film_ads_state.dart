part of 'delete_short_film_ads_cubit.dart';

sealed class DeleteShortFilmAdsState extends Equatable {}

final class DeleteShortFilmAdsInitial extends DeleteShortFilmAdsState {
  @override
  List<Object?> get props => [];
}

final class DeleteShortFilmAdsLoadingState extends DeleteShortFilmAdsState {
  @override
  List<Object?> get props => [];
}

final class DeleteShortFilmAdsLoadedState extends DeleteShortFilmAdsState {
  @override
  List<Object?> get props => [];
}

final class DeleteShortFilmAdsErrorState extends DeleteShortFilmAdsState {
  final String error;
  DeleteShortFilmAdsErrorState(this.error);
  @override
  List<Object?> get props => [error];
}
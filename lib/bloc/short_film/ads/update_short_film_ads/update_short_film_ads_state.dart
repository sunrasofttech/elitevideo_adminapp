part of 'update_short_film_ads_cubit.dart';

sealed class UpdateShortFilmAdsState extends Equatable {}

final class UpdateShortFilmAdsInitial extends UpdateShortFilmAdsState {
  @override
  List<Object?> get props => [];
}

final class UpdateShortFilmAdsLoadingState extends UpdateShortFilmAdsState {
  @override
  List<Object?> get props => [];
}

final class UpdateShortFilmAdsLoadedState extends UpdateShortFilmAdsState {
  @override
  List<Object?> get props => [];
}

final class UpdateShortFilmAdsErrorState extends UpdateShortFilmAdsState {
  final String error;
  UpdateShortFilmAdsErrorState(this.error);
  @override
  List<Object?> get props => [error];
}

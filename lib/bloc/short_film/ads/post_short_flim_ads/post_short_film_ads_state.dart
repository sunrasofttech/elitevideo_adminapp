part of 'post_short_film_ads_cubit.dart';

sealed class PostShortFilmAdsState extends Equatable {}

final class PostShortFilmAdsInitial extends PostShortFilmAdsState {
  @override
  List<Object?> get props => [];
}

final class PostShortFilmAdsLoadingState extends PostShortFilmAdsState {
  @override
  List<Object?> get props => [];
}

final class PostShortFilmAdsLaodedState extends PostShortFilmAdsState {
  @override
  List<Object?> get props => [];
}

final class PostShortFilmAdsErrorState extends PostShortFilmAdsState {
  final String error;
  PostShortFilmAdsErrorState(this.error);
  @override
  List<Object?> get props => [error];
}

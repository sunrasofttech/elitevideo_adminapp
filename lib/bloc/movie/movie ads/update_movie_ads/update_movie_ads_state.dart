part of 'update_movie_ads_cubit.dart';

sealed class UpdateMovieAdsState extends Equatable {}

final class UpdateMovieAdsInitial extends UpdateMovieAdsState {
  @override
  List<Object?> get props => [];
}

final class UpdateMovieAdsLoadingState extends UpdateMovieAdsState {
  @override
  List<Object?> get props => [];
}


final class UpdateMovieAdsLaodedState extends UpdateMovieAdsState {
  @override
  List<Object?> get props => [];
}


final class UpdateMovieAdsErrorState extends UpdateMovieAdsState {
  final String error;
  UpdateMovieAdsErrorState(this.error);
  @override
  List<Object?> get props => [error];
}



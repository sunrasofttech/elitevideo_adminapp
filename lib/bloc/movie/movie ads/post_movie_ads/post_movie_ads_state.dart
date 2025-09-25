part of 'post_movie_ads_cubit.dart';

sealed class PostMovieAdsState extends Equatable {}

final class PostMovieAdsInitial extends PostMovieAdsState {
  @override
  List<Object?> get props => [];
}

final class PostMovieAdsLoadingState extends PostMovieAdsState {
  @override
  List<Object?> get props => [];
}


final class PostMovieAdsLoadedState extends PostMovieAdsState {
  @override
  List<Object?> get props => [];
}


final class PostMovieAdsErrorState extends PostMovieAdsState {
  final String error;
  PostMovieAdsErrorState(this.error);
  @override
  List<Object?> get props => [error];
}

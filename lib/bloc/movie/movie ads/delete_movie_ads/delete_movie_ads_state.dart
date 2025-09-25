part of 'delete_movie_ads_cubit.dart';

sealed class DeleteMovieAdsState extends Equatable {}

final class DeleteMovieAdsInitial extends DeleteMovieAdsState {
  @override
  List<Object?> get props => [];
}

final class DeleteMovieAdsLoadingState extends DeleteMovieAdsState {
  @override
  List<Object?> get props => [];
}

final class DeleteMovieAdsLoadedState extends DeleteMovieAdsState {
  @override
  List<Object?> get props => [];
}

final class DeleteMovieAdsErrorState extends DeleteMovieAdsState {
  final String error;
  DeleteMovieAdsErrorState(this.error);
  @override
  List<Object?> get props => [error];
}
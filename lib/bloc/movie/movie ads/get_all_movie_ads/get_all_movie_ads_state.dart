part of 'get_all_movie_ads_cubit.dart';

sealed class GetAllMovieAdsState extends Equatable {}

final class GetAllMovieAdsInitial extends GetAllMovieAdsState {
  @override
  List<Object?> get props => [];
}

final class GetAllMovieAdsLoadingState extends GetAllMovieAdsState {
  @override
  List<Object?> get props => [];
}

final class GetAllMovieAdsLaodedState extends GetAllMovieAdsState {
  final MovieAdsModel model;
  GetAllMovieAdsLaodedState(this.model);
  @override
  List<Object?> get props => [model];
}

final class GetAllMovieAdsErrorState extends GetAllMovieAdsState {
  final String error;
  GetAllMovieAdsErrorState(this.error);
  @override
  List<Object?> get props => [error];
}

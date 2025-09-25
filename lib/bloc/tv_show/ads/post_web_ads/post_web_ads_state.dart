part of 'post_web_ads_cubit.dart';

sealed class PostTvShowWebAdsState extends Equatable {}

final class PostWebAdsInitial extends PostTvShowWebAdsState {
  @override
  List<Object?> get props => [];
}

final class PostWebAdsLoadingState extends PostTvShowWebAdsState {
  @override
  List<Object?> get props => [];
}

final class PostWebAdsLoadedState extends PostTvShowWebAdsState {
  @override
  List<Object?> get props => [];
}

final class PostWebAdsErrorState extends PostTvShowWebAdsState {
  final String error;
  PostWebAdsErrorState(this.error);
  @override
  List<Object?> get props => [error];
}

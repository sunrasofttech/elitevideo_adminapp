part of 'post_live_tv_ads_cubit.dart';

sealed class PostLiveTvAdsState extends Equatable {}

final class PostLiveTvAdsInitial extends PostLiveTvAdsState {
  @override
  List<Object?> get props => [];
}

final class PostLiveTvAdsLoadingState extends PostLiveTvAdsState {
  @override
  List<Object?> get props => [];
}

final class PostLiveTvAdsLoadedState extends PostLiveTvAdsState {
  @override
  List<Object?> get props => [];
}

final class PostLiveTvAdsErrorState extends PostLiveTvAdsState {
  final String error;
  PostLiveTvAdsErrorState(this.error);
  @override
  List<Object?> get props => [error];
}

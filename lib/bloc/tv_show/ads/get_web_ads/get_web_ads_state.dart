part of 'get_web_ads_cubit.dart';

sealed class GetTvShowWebAdsState extends Equatable {}

final class GetWebAdsInitial extends GetTvShowWebAdsState {
  @override
  List<Object?> get props => [];
}

final class GetWebAdsLoadingState extends GetTvShowWebAdsState {
  @override
  List<Object?> get props => [];
}

final class GetWebAdsLoadedState extends GetTvShowWebAdsState {
  final GetSeasonAdsModel model;
  GetWebAdsLoadedState(this.model);
  @override
  List<Object?> get props => [model];
}

final class GetWebAdsErrorState extends GetTvShowWebAdsState {
  final String error;
  GetWebAdsErrorState(this.error);
  @override
  List<Object?> get props => [error];
}

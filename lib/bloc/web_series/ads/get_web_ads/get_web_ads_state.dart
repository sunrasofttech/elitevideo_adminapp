part of 'get_web_ads_cubit.dart';

sealed class GetWebAdsState extends Equatable {}

final class GetWebAdsInitial extends GetWebAdsState {
  @override
  List<Object?> get props => [];
}

final class GetWebAdsLoadingState extends GetWebAdsState {
  @override
  List<Object?> get props => [];
}

final class GetWebAdsLoadedState extends GetWebAdsState {
  final GetSeasonAdsModel model;
  GetWebAdsLoadedState(this.model);
  @override
  List<Object?> get props => [model];
}

final class GetWebAdsErrorState extends GetWebAdsState {
  final String error;
  GetWebAdsErrorState(this.error);
  @override
  List<Object?> get props => [error];
}
part of 'get_all_live_tv_ads_cubit.dart';

sealed class GetAllLiveTvAdsState extends Equatable {}

final class GetAllLiveTvAdsInitial extends GetAllLiveTvAdsState {
  @override
  List<Object?> get props => [];
}

final class GetAllLiveTvAdsLoadingState extends GetAllLiveTvAdsState {
  @override
  List<Object?> get props => [];
}

final class GetAllLiveTvAdsLoadedState extends GetAllLiveTvAdsState {
  final GetLiveTvAdsModel model;
  GetAllLiveTvAdsLoadedState(this.model);
  @override
  List<Object?> get props => [model];
}

final class GetAllLiveTvAdsErrorState extends GetAllLiveTvAdsState {
  final String error;
  GetAllLiveTvAdsErrorState(this.error);
  @override
  List<Object?> get props => [error];
}

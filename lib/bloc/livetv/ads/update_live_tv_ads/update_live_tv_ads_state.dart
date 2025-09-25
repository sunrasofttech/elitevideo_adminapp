part of 'update_live_tv_ads_cubit.dart';

sealed class UpdateLiveTvAdsState extends Equatable {}

final class UpdateLiveTvAdsInitial extends UpdateLiveTvAdsState {
  @override
  List<Object?> get props => [];
}

final class UpdateLiveTvAdsLoadingState extends UpdateLiveTvAdsState {
  @override
  List<Object?> get props => [];
}

final class UpdateLiveTvAdsLoadedState extends UpdateLiveTvAdsState {
  @override
  List<Object?> get props => [];
}

final class UpdateLiveTvAdsErrorState extends UpdateLiveTvAdsState {
  final String error;
  UpdateLiveTvAdsErrorState(this.error);
  @override
  List<Object?> get props => [error];
}

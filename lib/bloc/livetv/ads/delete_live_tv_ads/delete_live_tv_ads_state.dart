part of 'delete_live_tv_ads_cubit.dart';

sealed class DeleteLiveTvAdsState extends Equatable {}

final class DeleteLiveTvAdsInitial extends DeleteLiveTvAdsState {
  @override
  List<Object?> get props => [];
}

final class DeleteLiveTvAdsLoadingState extends DeleteLiveTvAdsState {
  @override
  List<Object?> get props => [];
}

final class DeleteLiveTvAdsLoadedState extends DeleteLiveTvAdsState {
  @override
  List<Object?> get props => [];
}

final class DeleteLiveTvAdsErrorState extends DeleteLiveTvAdsState {
  final String error;
  DeleteLiveTvAdsErrorState(this.error);
  @override
  List<Object?> get props => [error];
}

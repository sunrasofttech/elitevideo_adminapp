part of 'update_web_ads_cubit.dart';

sealed class UpdateTvShowWebAdsState extends Equatable {}

final class UpdateWebAdsInitial extends UpdateTvShowWebAdsState {
  @override
  List<Object?> get props => [];
}

final class UpdateWebAdsLoadingState extends UpdateTvShowWebAdsState {
  @override
  List<Object?> get props => [];
}

final class UpdateWebAdsLoadedState extends UpdateTvShowWebAdsState {
  @override
  List<Object?> get props => [];
}

final class UpdateWebAdsErrorState extends UpdateTvShowWebAdsState {
  final String error;
  UpdateWebAdsErrorState(this.error);
  @override
  List<Object?> get props => [error];
}

part of 'get_short_flim_ads_cubit.dart';

sealed class GetShortFlimAdsState extends Equatable {}

final class GetShortFlimAdsInitial extends GetShortFlimAdsState {
  @override
  List<Object?> get props => [];
}

final class GetShortFlimAdsLoadingState extends GetShortFlimAdsState {
  @override
  List<Object?> get props => [];
}

final class GetShortFlimAdsLoadedState extends GetShortFlimAdsState {
  final GetShortFilmAdsModel model;
  GetShortFlimAdsLoadedState(this.model);
  @override
  List<Object?> get props => [model];
}

final class GetShortFlimAdsErrorState extends GetShortFlimAdsState {
  final String error;
  GetShortFlimAdsErrorState(this.error);
  @override
  List<Object?> get props => [error];
}
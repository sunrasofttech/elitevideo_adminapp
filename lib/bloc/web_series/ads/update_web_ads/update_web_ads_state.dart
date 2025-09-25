part of 'update_web_ads_cubit.dart';

sealed class UpdateWebAdsState extends Equatable {}

final class UpdateWebAdsInitial extends UpdateWebAdsState {
  @override
  List<Object?> get props => [];
}

final class UpdateWebAdsLoadingState extends UpdateWebAdsState {
  @override
  List<Object?> get props => [];
}

final class UpdateWebAdsLoadedState extends UpdateWebAdsState {
  @override
  List<Object?> get props => [];
}

final class UpdateWebAdsErrorState extends UpdateWebAdsState {
  final String error;
  UpdateWebAdsErrorState(this.error);
  @override
  List<Object?> get props => [error];
}
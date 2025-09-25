part of 'update_ads_cubit.dart';

sealed class UpdateAdsState extends Equatable {}

final class UpdateAdsInitial extends UpdateAdsState {
  @override
  List<Object?> get props => [];
}

final class UpdateAdsLoadingState extends UpdateAdsState {
  @override
  List<Object?> get props => [];
}

final class UpdateAdsLoadedState extends UpdateAdsState {
  @override
  List<Object?> get props => [];
}

final class UpdateAdsErrorState extends UpdateAdsState {
  final String error;
  UpdateAdsErrorState(this.error);
  @override
  List<Object?> get props => [error];
}

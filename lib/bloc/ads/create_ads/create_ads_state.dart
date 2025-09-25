part of 'create_ads_cubit.dart';

sealed class CreateAdsState extends Equatable {}

final class CreateAdsInitial extends CreateAdsState {
  @override
  List<Object?> get props => [];
}

final class CreateAdsLoadingState extends CreateAdsState {
  @override
  List<Object?> get props => [];
}

final class CreateAdsLaodedState extends CreateAdsState {
  @override
  List<Object?> get props => [];
}

final class CreateAdsErrorState extends CreateAdsState {
  final String error;
  CreateAdsErrorState(this.error);
  @override
  List<Object?> get props => [error];
}
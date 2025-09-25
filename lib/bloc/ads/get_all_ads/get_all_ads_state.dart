part of 'get_all_ads_cubit.dart';

sealed class GetAllAdsState extends Equatable {}

final class GetAllAdsInitial extends GetAllAdsState {
  @override
  List<Object?> get props => [];
}

final class GetAllAdsLoadingState extends GetAllAdsState {
  @override
  List<Object?> get props => [];
}

final class GetAllAdsLaodedState extends GetAllAdsState {
  final GetAllAdsModel model;
  GetAllAdsLaodedState(this.model);
  @override
  List<Object?> get props => [model];
}

final class GetAllAdsErrorState extends GetAllAdsState {
  final String error;
  GetAllAdsErrorState(this.error);
  @override
  List<Object?> get props => [error];
}
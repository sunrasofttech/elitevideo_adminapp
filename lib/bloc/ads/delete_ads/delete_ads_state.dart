part of 'delete_ads_cubit.dart';

sealed class DeleteAdsState extends Equatable {}

final class DeleteAdsInitial extends DeleteAdsState {
  @override
  List<Object?> get props => [];
}

final class DeleteAdsLoadingState extends DeleteAdsState {
  @override
  List<Object?> get props => [];
}

final class DeleteAdsLaodedState extends DeleteAdsState {
  @override
  List<Object?> get props => [];
}

final class DeleteAdsErrorState extends DeleteAdsState {
  final String error;
  DeleteAdsErrorState(this.error);
  @override
  List<Object?> get props => [error];
}

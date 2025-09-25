part of 'delete_web_ads_cubit.dart';

sealed class DeleteWebAdsState extends Equatable {}

final class DeleteWebAdsInitial extends DeleteWebAdsState {
  @override
  List<Object?> get props => [];
}

final class DeleteWebAdsLoadingState extends DeleteWebAdsState {
  @override
  List<Object?> get props => [];
}

final class DeleteWebAdsLoadedState extends DeleteWebAdsState {
  @override
  List<Object?> get props => [];
}

final class DeleteWebAdsErrorState extends DeleteWebAdsState {
  final String error;
  DeleteWebAdsErrorState(this.error);
  @override
  List<Object?> get props => [error];
}

part of 'post_web_ads_cubit.dart';

sealed class PostWebAdsState extends Equatable {}

final class PostWebAdsInitial extends PostWebAdsState {
  @override
  List<Object?> get props => [];
}

final class PostWebAdsLoadingState extends PostWebAdsState {
  @override
  List<Object?> get props => [];
}


final class PostWebAdsLoadedState extends PostWebAdsState {
  @override
  List<Object?> get props => [];
}


final class PostWebAdsErrorState extends PostWebAdsState {
  final String error;
  PostWebAdsErrorState(this.error);
  @override
  List<Object?> get props => [error];
}

part of 'get_subscription_cubit.dart';

sealed class GetSubscriptionState extends Equatable {}

final class GetSubscriptionInitial extends GetSubscriptionState {
  @override
  List<Object?> get props => [];
}


final class GetSubscriptionLoadingState extends GetSubscriptionState {
  @override
  List<Object?> get props => [];
}

final class GetSubscriptionLoadedState extends GetSubscriptionState {
  final GetAllSubscriptionModel model;
  GetSubscriptionLoadedState(this.model);
  @override
  List<Object?> get props => [model];
}

final class GetSubscriptionErrorState extends GetSubscriptionState {
  final String error;
  GetSubscriptionErrorState(this.error);
  @override
  List<Object?> get props => [error];
}
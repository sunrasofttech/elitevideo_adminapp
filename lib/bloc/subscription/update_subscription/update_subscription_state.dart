part of 'update_subscription_cubit.dart';

sealed class UpdateSubscriptionState extends Equatable {}

final class UpdateSubscriptionInitial extends UpdateSubscriptionState {
  @override
  List<Object?> get props => [];
}

final class UpdateSubscriptionLoadingState extends UpdateSubscriptionState {
  @override
  List<Object?> get props => [];
}

final class UpdateSubscriptionLoadedState extends UpdateSubscriptionState {
  @override
  List<Object?> get props => [];
}

final class UpdateSubscriptionErrorState extends UpdateSubscriptionState {
  final String error;
  UpdateSubscriptionErrorState(this.error);
  @override
  List<Object?> get props => [error];
}
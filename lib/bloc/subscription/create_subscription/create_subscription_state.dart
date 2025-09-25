part of 'create_subscription_cubit.dart';

sealed class CreateSubscriptionState extends Equatable {}

final class CreateSubscriptionInitial extends CreateSubscriptionState {
  @override
  List<Object?> get props => [];
}

final class CreateSubscriptionLoadingState extends CreateSubscriptionState {
  @override
  List<Object?> get props => [];
}

final class CreateSubscriptionLoadedState extends CreateSubscriptionState {
  @override
  List<Object?> get props => [];
}

final class CreateSubscriptionErrorState extends CreateSubscriptionState {
  final String error;
  CreateSubscriptionErrorState(this.error);
  @override
  List<Object?> get props => [error];
}
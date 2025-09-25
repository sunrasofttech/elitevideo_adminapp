part of 'delete_subscription_cubit.dart';

sealed class DeleteSubscriptionState extends Equatable {}

final class DeleteSubscriptionInitial extends DeleteSubscriptionState {
  @override
  List<Object?> get props => [];
}

final class DeleteSubscriptionLoadingState extends DeleteSubscriptionState {
  @override
  List<Object?> get props => [];
}


final class DeleteSubscriptionLoadedState extends DeleteSubscriptionState {
  @override
  List<Object?> get props => [];
}


final class DeleteSubscriptionErrorState extends DeleteSubscriptionState {
  final String error;
  DeleteSubscriptionErrorState(this.error);
  @override
  List<Object?> get props => [error];
}

part of 'send_notification_cubit.dart';

sealed class SendNotificationState extends Equatable {}

final class SendNotificationInitial extends SendNotificationState {
  @override
  List<Object?> get props => [];
}

final class SendNotificationLoadingState extends SendNotificationState {
  @override
  List<Object?> get props => [];
}


final class SendNotificationLoadedState extends SendNotificationState {
  @override
  List<Object?> get props => [];
}


final class SendNotificationErrorState extends SendNotificationState {
  final String error;
  SendNotificationErrorState(this.error);
  @override
  List<Object?> get props => [error];
}

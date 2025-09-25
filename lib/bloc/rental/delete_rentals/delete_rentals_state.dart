part of 'delete_rentals_cubit.dart';

sealed class DeleteRentalsState extends Equatable {}

final class DeleteRentalsInitial extends DeleteRentalsState {
  @override
  List<Object?> get props => [];
}

final class DeleteRentalsLoadingState extends DeleteRentalsState {
  @override
  List<Object?> get props => [];
}

final class DeleteRentalsloadedState extends DeleteRentalsState {
  @override
  List<Object?> get props => [];
}

final class DeleteRentalsErrorState extends DeleteRentalsState {
  final String error;
  DeleteRentalsErrorState(this.error);
  @override
  List<Object?> get props => [error];
}

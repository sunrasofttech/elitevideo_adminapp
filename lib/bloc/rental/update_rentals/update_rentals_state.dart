part of 'update_rentals_cubit.dart';

sealed class UpdateRentalsState extends Equatable {}

final class UpdateRentalsInitial extends UpdateRentalsState {
  @override
  List<Object?> get props => [];
}

final class UpdateRentalsLoadingState extends UpdateRentalsState {
  @override
  List<Object?> get props => [];
}

final class UpdateRentalsLaodedState extends UpdateRentalsState {
  @override
  List<Object?> get props => [];
}

final class UpdateRentalsErrorState extends UpdateRentalsState {
  final String error;
  UpdateRentalsErrorState(this.error);
  @override
  List<Object?> get props => [error];
}

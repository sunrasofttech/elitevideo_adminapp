part of 'get_rentals_cubit.dart';

sealed class GetRentalsState extends Equatable {}

final class GetRentalsInitial extends GetRentalsState {
  @override
  List<Object?> get props => [];
}

final class GetRentalsLoadingState extends GetRentalsState {
  @override
  List<Object?> get props => [];
}

final class GetRentalsLoadedState extends GetRentalsState {
  final GetRentalModel model;
  GetRentalsLoadedState(this.model);
  @override
  List<Object?> get props => [model];
}

final class GetRentalsErrorState extends GetRentalsState {
  final String error;
  GetRentalsErrorState(this.error);
  @override
  List<Object?> get props => [error];
}
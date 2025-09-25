import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'update_rentals_state.dart';

class UpdateRentalsCubit extends Cubit<UpdateRentalsState> {
  UpdateRentalsCubit() : super(UpdateRentalsInitial());
}

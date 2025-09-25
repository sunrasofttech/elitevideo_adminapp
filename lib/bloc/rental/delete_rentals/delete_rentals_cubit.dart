import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:elite_admin/utils/apiurls/api.dart';

part 'delete_rentals_state.dart';

class DeleteRentalsCubit extends Cubit<DeleteRentalsState> {
  DeleteRentalsCubit() : super(DeleteRentalsInitial());

   deleteRentals(String id) async {
    try {
      emit(DeleteRentalsLoadingState());
      var response = await delete(
        Uri.parse("${AppUrls.getRentalsUrl}/$id"),
        headers: headers,
      );
      final result = jsonDecode(response.body);
      log("message me $result");
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(
            DeleteRentalsloadedState(),
          );
        } else {
          emit(DeleteRentalsErrorState(result["message"]));
        }
      } else {
        emit(DeleteRentalsErrorState(result["message"]));
      }
    } catch (e, s) {
      print("catch error $e, $s");
      emit(
        DeleteRentalsErrorState(
          "catch error $e, $s",
        ),
      );
    }
  }
}

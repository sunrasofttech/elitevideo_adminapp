import 'dart:convert';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:elite_admin/bloc/rental/get_rentals/get_rentals_model.dart';
import 'package:elite_admin/utils/apiurls/api.dart';
import 'package:http/http.dart';
part 'get_rentals_state.dart';

class GetRentalsCubit extends Cubit<GetRentalsState> {
  GetRentalsCubit() : super(GetRentalsInitial());

  getRentals({String? type}) async {
    try {
      emit(GetRentalsLoadingState());

      final uri = Uri.parse("${AppUrls.getRentalsUrl}/get-all").replace(
        queryParameters: type != null ? {'type': type} : null,
      );

      var response = await post(
        uri,
        headers: headers,
      );
      final result = jsonDecode(response.body);
      log("message me $result");
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(
            GetRentalsLoadedState(
              getRentalModelFromJson(
                json.encode(result),
              ),
            ),
          );
        } else {
          emit(GetRentalsErrorState(result["message"]));
        }
      } else {
        emit(GetRentalsErrorState(result["message"]));
      }
    } catch (e, s) {
      print("catch error $e, $s");
      emit(
        GetRentalsErrorState(
          "catch error $e, $s",
        ),
      );
    }
  }
}

import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:elite_admin/utils/apiurls/api.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';

part 'delete_trailer_state.dart';

class DeleteTrailerCubit extends Cubit<DeleteTrailerState> {
  DeleteTrailerCubit() : super(DeleteTrailerInitial());

   deleteTrailer(List<String> id) async {
    try {
      if (id.isEmpty) {
        emit(DeleteTrailerErrorState("No Id Selected"));
      }
      emit(DeleteTrailerLoadingState());
      var response = await delete(
        Uri.parse("${AppUrls.baseUrl}/api/ott/trailor"),
        
        body: json.encode({
          "ids": id,
        }),
        headers: headers,
      );
      final result = jsonDecode(response.body);
      log("message me $result");
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(
            DeleteTrailerLoadedState(),
          );
        } else {
          emit(DeleteTrailerErrorState(result["message"]));
        }
      } else {
        emit(DeleteTrailerErrorState(result["message"]));
      }
    } catch (e, s) {
      print("catch error $e, $s");
      emit(
        DeleteTrailerErrorState(
          "catch error $e, $s",
        ),
      );
    }
  }
}

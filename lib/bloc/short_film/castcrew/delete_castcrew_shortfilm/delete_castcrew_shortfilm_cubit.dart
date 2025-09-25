import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'package:elite_admin/utils/apiurls/api.dart';

part 'delete_castcrew_shortfilm_state.dart';

class DeleteCastcrewShortfilmCubit extends Cubit<DeleteCastcrewShortfilmState> {
  DeleteCastcrewShortfilmCubit() : super(DeleteCastcrewShortfilmInitial());

  deleteCastCrew(String id) async {
    try {
      emit(DeleteCastcrewShortfilmLoadingState());
      var response = await delete(
        Uri.parse("${AppUrls.shortFilmCastCrewUrl}/$id"),
          headers: headers,
      );
      final result = jsonDecode(response.body.toString());

      log("deleteCastCrew = > $result,, ${response.statusCode} ");

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(
            DeleteCastcrewShortfilmLoadedState(),
          );
        } else {
          emit(DeleteCastcrewShortfilmErrorState("${result['message']}"));
        }
      } else {
        emit(DeleteCastcrewShortfilmErrorState("${result['message']}"));
      }
    } catch (e, s) {
      print("catch error $e, $s");
      emit(DeleteCastcrewShortfilmErrorState("$e $s"));
    }
  }
  
}

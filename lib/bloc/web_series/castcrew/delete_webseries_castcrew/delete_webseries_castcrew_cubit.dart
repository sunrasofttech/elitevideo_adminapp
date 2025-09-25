import 'dart:convert';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:elite_admin/utils/apiurls/api.dart';
import 'package:http/http.dart';
part 'delete_webseries_castcrew_state.dart';

class DeleteWebseriesCastcrewCubit extends Cubit<DeleteWebseriesCastcrewState> {
  DeleteWebseriesCastcrewCubit() : super(DeleteWebseriesCastcrewInitial());

  deleteCastCrew(String id) async {
    try {
      emit(DeleteWebseriesCastcrewLoadingState());
      var response = await delete(
        Uri.parse("${AppUrls.webSeriesCastCrewUrl}/$id"),
          headers: headers,
      );
      final result = jsonDecode(response.body.toString());

      log("deleteCastCrew = > $result,, ${response.statusCode} ");

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(
            DeleteWebseriesCastcrewLoadedState(),
          );
        } else {
          emit(DeleteWebseriesCastcrewErrorState("${result['message']}"));
        }
      } else {
        emit(DeleteWebseriesCastcrewErrorState("${result['message']}"));
      }
    } catch (e, s) {
      print("catch error $e, $s");
      emit(DeleteWebseriesCastcrewErrorState("$e $s"));
    }
  }
}

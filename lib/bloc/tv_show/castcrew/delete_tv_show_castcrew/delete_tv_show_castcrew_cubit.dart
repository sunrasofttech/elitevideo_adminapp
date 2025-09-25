import 'dart:convert';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:elite_admin/utils/apiurls/api.dart';
import 'package:http/http.dart';
part 'delete_tv_show_castcrew_state.dart';

class DeleteTvShowCastcrewCubit extends Cubit<DeleteTvShowCastcrewState> {
  DeleteTvShowCastcrewCubit() : super(DeleteTvShowCastcrewInitial());

  deleteCastCrew(String id) async {
    try {
      emit(DeleteTvShowCastcrewLoadingState());
      var response = await delete(
        Uri.parse("${AppUrls.webSeriesCastCrewUrl}/$id"),
          headers: headers,
      );
      final result = jsonDecode(response.body.toString());

      log("deleteCastCrew = > $result,, ${response.statusCode} ");

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(
            DeleteTvShowCastcrewLoadedState(),
          );
        } else {
          emit(DeleteTvShowCastcrewErrorState("${result['message']}"));
        }
      } else {
        emit(DeleteTvShowCastcrewErrorState("${result['message']}"));
      }
    } catch (e, s) {
      print("catch error $e, $s");
      emit(DeleteTvShowCastcrewErrorState("$e $s"));
    }
  }
}

import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:elite_admin/utils/apiurls/api.dart';

part 'delete_season_state.dart';

class DeleteTvShowSeasonCubit extends Cubit<DeleteSeasonState> {
  DeleteTvShowSeasonCubit() : super(DeleteSeasonInitial());

  deleteSeason(String id) async {
    try {
      emit(DeleteSeasonLoadingState());
      var response = await delete(
        Uri.parse("${AppUrls.seasonUrl}/$id"),
        headers: headers,
      );
      final result = jsonDecode(response.body);
      log("message me $result");
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(
            DeleteSeasonLoadedState(),
          );
        } else {
          emit(DeleteSeasonErrorState(result["message"]));
        }
      } else {
        emit(DeleteSeasonErrorState(result["message"]));
      }
    } catch (e, s) {
      print("catch error $e, $s");
      emit(
        DeleteSeasonErrorState(
          "catch error $e, $s",
        ),
      );
    }
  }
}

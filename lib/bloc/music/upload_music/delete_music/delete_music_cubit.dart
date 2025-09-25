import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'package:elite_admin/utils/apiurls/api.dart';
part 'delete_music_state.dart';

class DeleteMusicCubit extends Cubit<DeleteMusicState> {
  DeleteMusicCubit() : super(DeleteMusicInitial());

  deleteMusic(String id) async {
    try {
      emit(DeleteMusicLoadingState());
      var response = await delete(
        Uri.parse("${AppUrls.musicUrl}/$id"),
        headers: headers,
      );
      final result = jsonDecode(response.body);
      log("message me $result");
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(
            DeleteMusicLoadedState(),
          );
        } else {
          emit(DeleteMusicErrorState(result["message"]));
        }
      } else {
        emit(DeleteMusicErrorState(result["message"]));
      }
    } catch (e, s) {
      print("catch error $e, $s");
      emit(
        DeleteMusicErrorState(
          "catch error $e, $s",
        ),
      );
    }
  }
}

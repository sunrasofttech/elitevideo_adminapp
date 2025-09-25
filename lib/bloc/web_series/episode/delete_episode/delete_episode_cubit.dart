import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';

import '../../../../utils/apiurls/api.dart';
part 'delete_episode_state.dart';

class DeleteEpisodeCubit extends Cubit<DeleteEpisodeState> {
  DeleteEpisodeCubit() : super(DeleteEpisodeInitial());

  deleteEpisode(List<String> id) async {
    try {
      emit(DeleteEpisodeLoadingState());
      var response = await delete(
        Uri.parse(AppUrls.episodeUrl),
        headers: headers,
        body: json.encode({
          "ids": id,
        }),
      );
      final result = jsonDecode(response.body);
      log("message me $result");
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(
            DeleteEpisodeLaodedState(),
          );
        } else {
          emit(DeleteEpisodeErrorState(result["message"]));
        }
      } else {
        emit(DeleteEpisodeErrorState(result["message"]));
      }
    } catch (e, s) {
      print("catch error $e, $s");
      emit(
        DeleteEpisodeErrorState(
          "catch error $e, $s",
        ),
      );
    }
  }
}

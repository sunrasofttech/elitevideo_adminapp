import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'package:elite_admin/utils/apiurls/api.dart';
part 'delete_genre_state.dart';

class DeleteGenreCubit extends Cubit<DeleteGenreState> {
  DeleteGenreCubit() : super(DeleteGenreInitial());

  deleteGenre(String id) async {
    try {
      emit(DeleteGenreLoadingState());
      var response = await delete(
        Uri.parse("${AppUrls.genreUrl}/$id"),
        headers: headers,
      );
      log("Raw Responce ${response.body}");
      final result = jsonDecode(response.body);
      log("message me $result");
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(
            DeleteGenreLoadedState(),
          );
        } else {
          emit(DeleteGenreErrorState(result["message"]));
        }
      } else {
        emit(DeleteGenreErrorState(result["message"]));
      }
    } catch (e, s) {
      print("catch error $e, $s");
      emit(
        DeleteGenreErrorState(
          "catch error $e, $s",
        ),
      );
    }
  }
}

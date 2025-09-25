import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'package:elite_admin/utils/apiurls/api.dart';

part 'delete_artist_state.dart';

class DeleteArtistCubit extends Cubit<DeleteArtistState> {
  DeleteArtistCubit() : super(DeleteArtistInitial());

  deleteArtistCategory(String id) async {
    try {
      emit(DeleteArtistLoadingState());
      var response = await delete(
        Uri.parse("${AppUrls.musicArtistUrl}/$id"),
        headers: headers,
      );
      final result = jsonDecode(response.body.toString());
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(
            DeleteArtistLoadedState(),
          );
        } else {
          emit(DeleteArtistErrorState("${result['message']}"));
        }
      } else {
        emit(DeleteArtistErrorState("${result['message']}"));
      }
    } catch (e, s) {
      print("catch error $e, $s");
      emit(DeleteArtistErrorState("$e $s"));
    }
  }
}

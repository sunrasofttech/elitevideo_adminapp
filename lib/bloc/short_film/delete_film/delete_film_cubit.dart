import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'package:elite_admin/utils/apiurls/api.dart';
part 'delete_film_state.dart';

class DeleteFilmCubit extends Cubit<DeleteFilmState> {
  DeleteFilmCubit() : super(DeleteFilmInitial());

  deleteShortFilm(List<String> id) async {
    try {
      emit(DeleteFilmLoadingState());
      final url = Uri.parse(AppUrls.shortFlimUrl);
      final body = json.encode({"ids": id});
      final curl = StringBuffer()..write("curl -X DELETE '${url.toString()}' ");
      headers.forEach((key, value) {
        curl.write("-H '$key: $value' ");
      });
      if (body.isNotEmpty) {
        curl.write("-d '$body'");
      }

      log("cURL: $curl");
      var response = await delete(Uri.parse(AppUrls.shortFlimUrl),
          headers: headers,
          body: json.encode({
            "ids": id,
          }));
      final result = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(
            DeleteFilmLoadedState(),
          );
        } else {
          emit(DeleteFilmErrorState(result["message"]));
        }
      } else {
        emit(DeleteFilmErrorState(result["message"]));
      }
    } catch (e, s) {
      print("catch error $e, $s");
      emit(
        DeleteFilmErrorState(
          "catch error $e, $s",
        ),
      );
    }
  }
}

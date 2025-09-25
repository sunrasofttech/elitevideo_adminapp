import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:elite_admin/bloc/movie/genre/get_all_genre/get_all_genre_model.dart';
import 'package:http/http.dart';
import 'package:elite_admin/utils/apiurls/api.dart';
part 'get_all_genre_state.dart';

class GetAllGenreCubit extends Cubit<GetAllGenreState> {
  GetAllGenreCubit() : super(GetAllGenreInitial());

  getGenre({String? name}) async {
    try {
      emit(GetAllGenreLoadingState());
      final queryParams = <String, String>{};
      if (name != null && name.trim().isNotEmpty) {
        queryParams['name'] = name.trim();
      }

      final uri = Uri.parse("${AppUrls.genreUrl}/get-all").replace(
        queryParameters: queryParams.isEmpty ? null : queryParams,
      );

      // Make API call
      final response = await post(
        uri,
        headers: headers,
      );

      final result = jsonDecode(response.body);
      log("message me $result");
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(
            GetAllGenreLaodedState(
              getGenreModelFromJson(
                json.encode(result),
              ),
            ),
          );
        } else {
          emit(GetAllGenreErrorState(result["message"]));
        }
      } else {
        emit(GetAllGenreErrorState(result["message"]));
      }
    } catch (e, s) {
      print("catch error $e, $s");
      emit(
        GetAllGenreErrorState(
          "catch error $e, $s",
        ),
      );
    }
  }
}

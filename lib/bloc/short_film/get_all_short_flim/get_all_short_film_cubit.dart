import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:elite_admin/bloc/short_film/get_all_short_flim/get_all_short_film_model.dart';
import 'package:elite_admin/utils/apiurls/api.dart';
part 'get_all_short_film_state.dart';

class GetAllShortFilmCubit extends Cubit<GetAllShortFilmState> {
  GetAllShortFilmCubit() : super(GetAllShortFilmInitial());

  getAllShortFilm({
    int page = 1,
    int limit = 10,
    String? shortFilmTitle,
    String? language,
    String? genre,
  }) async {
    try {
      emit(GetAllShortFilmLoadingState());

      final queryParams = {
        'page': page.toString(),
        'limit': limit.toString(),
        if (shortFilmTitle != null && shortFilmTitle.trim().isNotEmpty) 'short_film_title': shortFilmTitle.trim(),
        if (language != null && language.trim().isNotEmpty) 'language': language.trim(),
        if (genre != null && genre.trim().isNotEmpty) 'genre': genre.trim(),
      };

      final uri = Uri.parse("${AppUrls.shortFlimUrl}/admin/get-all").replace(queryParameters: queryParams);

      log("getAllShortFilm URL => $uri");

      var response = await post(
        uri,
        headers: headers,
      );

      final result = jsonDecode(response.body);
      log("getAllMovie =>  $result");
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(
            GetAllShortFilmLoadedState(
              getAllShortFilmModelFromJson(
                json.encode(result),
              ),
            ),
          );
        } else {
          emit(GetAllShortFilmErrorState(result["message"]));
        }
      } else {
        emit(GetAllShortFilmErrorState(result["message"]));
      }
    } catch (e, s) {
      print("catch error $e, $s");
      emit(
        GetAllShortFilmErrorState(
          "catch error $e, $s",
        ),
      );
    }
  }
}

import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'package:elite_admin/bloc/movie/upload_movie/get_all_movie/get_all_movie_model.dart';
import 'package:elite_admin/utils/apiurls/api.dart';
part 'get_all_movie_state.dart';

class GetAllMovieCubit extends Cubit<GetAllMovieState> {
  GetAllMovieCubit() : super(GetAllMovieInitial());

  getAllMovie({
    String? movieName,
    String? languageId,
    String? categoryId,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      emit(GetAllMovieLoadingState());

      final queryParams = {
        'movie_name': movieName ?? '',
        'language_id': languageId ?? '',
        'category_id': categoryId ?? '',
        'page': page.toString(),
        'limit': limit.toString(),
      };

      final uri = Uri.parse("${AppUrls.movieUrl}/admin/get-all").replace(queryParameters: queryParams);
      log("message $uri");
      final response = await post(uri, headers: headers);

      final result = jsonDecode(response.body);
      log("getAllMovie =>  $result");
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(
            GetAllMovieLaodedState(
              getAllMoviesModelFromJson(
                json.encode(result),
              ),
            ),
          );
        } else {
          emit(GetAllMovieErrorState(result["message"]));
        }
      } else {
        emit(GetAllMovieErrorState(result["message"]));
      }
    } catch (e, s) {
      print("catch error $e, $s");
      emit(
        GetAllMovieErrorState(
          "catch error $e, $s",
        ),
      );
    }
  }
}

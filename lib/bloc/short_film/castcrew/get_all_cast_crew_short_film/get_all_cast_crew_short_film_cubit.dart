import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'package:elite_admin/bloc/short_film/castcrew/get_all_cast_crew_short_film/get_all_cast_crew_short_film_model.dart';
import '../../../../utils/apiurls/api.dart';

part 'get_all_cast_crew_short_film_state.dart';

class GetAllCastCrewShortFilmCubit extends Cubit<GetAllCastCrewShortFilmState> {
  GetAllCastCrewShortFilmCubit() : super(GetAllCastCrewShortFilmInitial());

  Future<void> getAllCastCrew({int page = 1, int limit = 10, String? movieId, String? name}) async {
    try {
      emit(GetAllCastCrewShortFilmLoadingState());

      final queryParams = {
        'page': page.toString(),
        'limit': limit.toString(),
        if (name != null) "name": name,
        if (movieId != null) 'movie_id': movieId,
      };

      final uri = Uri.parse("${AppUrls.shortFilmCastCrewUrl}/get-all").replace(queryParameters: queryParams);

      var response = await post(
        uri,
        headers: headers,
      );

      final result = jsonDecode(response.body.toString());

      log("= = = = = = = = = = = = = = = > GetAllCastCrewWebseriesCubit $result");

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(
            GetAllCastCrewShortFilmLoadedState(
              getCastCrewShortFilmModelFromJson(
                json.encode(result),
              ),
            ),
          );
        } else {
          emit(GetAllCastCrewShortFilmErrorState("${result['message']}"));
        }
      } else {
        emit(GetAllCastCrewShortFilmErrorState("${result['message']}"));
      }
    } catch (e, s) {
      print("catch error $e, $s");
      emit(GetAllCastCrewShortFilmErrorState("$e $s"));
    }
  }
}

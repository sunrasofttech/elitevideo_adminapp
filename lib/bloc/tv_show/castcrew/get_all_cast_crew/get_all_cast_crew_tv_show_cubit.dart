import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'package:elite_admin/bloc/web_series/castcrew/get_all_cast_crew/get_all_cast_crew_webseries.dart';
import 'package:elite_admin/utils/apiurls/api.dart';

part 'get_all_cast_crew_tv_show_state.dart';

class GetAllCastCrewTvShowCubit extends Cubit<GetAllCastCrewTvShowState> {
  GetAllCastCrewTvShowCubit() : super(GetAllCastCrewTvShowInitial());

  Future<void> getAllCastCrew({int page = 1, int limit = 10, String? movieId, String? name}) async {
    try {
      emit(GetAllCastCrewTvShowLoadingState());

      final queryParams = {
        'page': page.toString(),
        'limit': limit.toString(),
        'show_type': 'tvshows',
        if (name != null) "name": name,
        if (movieId != null) 'movie_id': movieId,
      };

      final uri = Uri.parse("${AppUrls.webSeriesCastCrewUrl}/get-all").replace(queryParameters: queryParams);

      var response = await post(
        uri,
        headers: headers,
      );

      final result = jsonDecode(response.body.toString());

      log("= = = = = = = = = = = = = = = > GetAllCastCrewWebseriesCubit $result");

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(
            GetAllCastCrewTvShowLoadedState(
              getCastCrewWebSeriesModelFromJson(
                json.encode(result),
              ),
            ),
          );
        } else {
          emit(GetAllCastCrewTvShowErrorState("${result['message']}"));
        }
      } else {
        emit(GetAllCastCrewTvShowErrorState("${result['message']}"));
      }
    } catch (e, s) {
      print("catch error $e, $s");
      emit(GetAllCastCrewTvShowErrorState("$e $s"));
    }
  }
}

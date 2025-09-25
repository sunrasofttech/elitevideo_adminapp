import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'package:elite_admin/bloc/web_series/castcrew/get_all_cast_crew/get_all_cast_crew_webseries.dart';
import 'package:elite_admin/utils/apiurls/api.dart';

part 'get_all_cast_crew_webseries_state.dart';

class GetAllCastCrewWebseriesCubit extends Cubit<GetAllCastCrewWebseriesState> {
  GetAllCastCrewWebseriesCubit() : super(GetAllCastCrewWebseriesInitial());

  Future<void> getAllCastCrew({int page = 1, int limit = 10, String? movieId, String? name}) async {
    try {
      emit(GetAllCastCrewWebseriesLoadingState());

      final queryParams = {
        'page': page.toString(),
        'limit': limit.toString(),
        'show_type': 'series',
        if (name != null) "name": name,
        if (movieId != null) 'movie_id': movieId,
      };

      final uri =
          Uri.parse("${AppUrls.webSeriesCastCrewUrl}/get-all?show_type=series").replace(queryParameters: queryParams);

      var response = await post(
        uri,
        headers: headers,
      );

      final result = jsonDecode(response.body.toString());

      log("= = = = = = = = = = = = = = = > GetAllCastCrewWebseriesCubit $result");

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(
            GetAllCastCrewWebseriesLoadedState(
              getCastCrewWebSeriesModelFromJson(
                json.encode(result),
              ),
            ),
          );
        } else {
          emit(GetAllCastCrewWebseriesErrorState("${result['message']}"));
        }
      } else {
        emit(GetAllCastCrewWebseriesErrorState("${result['message']}"));
      }
    } catch (e, s) {
      print("catch error $e, $s");
      emit(GetAllCastCrewWebseriesErrorState("$e $s"));
    }
  }
}

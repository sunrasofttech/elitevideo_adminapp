import 'dart:convert';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:elite_admin/utils/apiurls/api.dart';
import 'package:http/http.dart';

import 'get_all_season_model.dart';
part 'get_all_season_state.dart';

class GetAllTvShowSeasonCubit extends Cubit<GetAllSeasonState> {
  GetAllTvShowSeasonCubit() : super(GetAllSeasonInitial());

  getAllSeason({int page = 1, int limit = 10, String? search}) async {
    try {
      emit(GetAllSeasonLoadingState());

      final Map<String, String> queryParams = {
        'page': page.toString(),
        'limit': limit.toString(),
        'show_type': 'tvshows',
      };

      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }

      final uri = Uri.parse("${AppUrls.seasonUrl}/get-all").replace(queryParameters: queryParams);

      var response = await post(
        uri,
        headers: headers,
      );

      final result = jsonDecode(response.body);
      log("getAllSeason =>  $result $uri");
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(
            GetAllSeasonLoadedState(
              getSeasonModelFromJson(
                json.encode(result),
              ),
            ),
          );
        } else {
          emit(GetAllSeasonErrorState(result["message"]));
        }
      } else {
        emit(GetAllSeasonErrorState(result["message"]));
      }
    } catch (e, s) {
      print("catch error $e, $s");
      emit(
        GetAllSeasonErrorState(
          "catch error $e, $s",
        ),
      );
    }
  }
}

import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:elite_admin/utils/apiurls/api.dart';

import 'get_all_episode_model.dart';

part 'get_all_episode_state.dart';

class GetAllTvShowEpisodeCubit extends Cubit<GetAllEpisodeState> {
  GetAllTvShowEpisodeCubit() : super(GetAllEpisodeInitial());

  getAllEpisode({
    int page = 1,
    int limit = 10,
    String? name,
    String? seasonId,
    String? seriesId,
  }) async {
    try {
      emit(GetAllEpisodeLoadingState());

      final queryParams = <String, String>{
        'page': page.toString(),
        'limit': limit.toString(),
        'show_type': 'tvshows',
      };

      if (name != null && name.isNotEmpty) queryParams['name'] = name;
      if (seasonId != null && seasonId.isNotEmpty) queryParams['season_id'] = seasonId;
      if (seriesId != null && seriesId.isNotEmpty) queryParams['series_id'] = seriesId;

      // Create URI with query parameters
      final uri = Uri.parse("${AppUrls.episodeUrl}/get-all").replace(queryParameters: queryParams);

      // Send POST request
      var response = await post(
        uri,
        headers: headers,
      );

      final result = jsonDecode(response.body);
      log("getAllMovie =>  $result");
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(
            GetAllEpisodeLoadedState(
              getEpisodeModelFromJson(
                json.encode(result),
              ),
            ),
          );
        } else {
          emit(GetAllEpisodeErrorState(result["message"]));
        }
      } else {
        emit(GetAllEpisodeErrorState(result["message"]));
      }
    } catch (e, s) {
      print("catch error $e, $s");
      emit(
        GetAllEpisodeErrorState(
          "catch error $e, $s",
        ),
      );
    }
  }
}

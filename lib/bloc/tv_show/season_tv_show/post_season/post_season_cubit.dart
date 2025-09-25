import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:elite_admin/model/season_model.dart';
import 'package:elite_admin/utils/apiurls/api.dart';

part 'post_season_state.dart';

class PostTvShowSeasonCubit extends Cubit<PostSeasonState> {
  PostTvShowSeasonCubit() : super(PostSeasonInitial());

  postSeason({
    required List<Season> season,
  }) async {
    try {
      emit(PostSeasonLoadingState());

      var seasonList = season.map((e) => e.toJson()).toList();
      var url = Uri.parse("${AppUrls.seasonUrl}/bulk");

      var bodyData = jsonEncode({
        "seasons": seasonList,
      });

      var response = await post(
        url,
        body: bodyData,
        headers: headers,
      );

      final result = jsonDecode(response.body);
      log("message me $result");
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(
            PostSeasonLoadedState(
                // loginModelFromJson(
                //   json.encode(result),
                // ),
                ),
          );
        } else {
          emit(PostSeasonErrorState(result["message"]));
        }
      } else {
        emit(PostSeasonErrorState(result["message"]));
      }
    } catch (e, s) {
      print("catch error $e, $s");
      emit(
        PostSeasonErrorState(
          "catch error $e, $s",
        ),
      );
    }
  }
}

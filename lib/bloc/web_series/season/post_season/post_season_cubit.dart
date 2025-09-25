import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:elite_admin/model/season_model.dart';
import 'package:elite_admin/utils/apiurls/api.dart';

part 'post_season_state.dart';

class PostSeasonCubit extends Cubit<PostSeasonState> {
  PostSeasonCubit() : super(PostSeasonInitial());

  postSeason({
    required List<Season> season,
  }) async {
    try {
      emit(PostSeasonLoadingState());
      var seasonList = season.map((e) => e.toJson()).toList();
      var response = await post(
        Uri.parse("${AppUrls.seasonUrl}/bulk"),
        body: jsonEncode({
          "seasons": seasonList,
           "show_type":"series",
        }),
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

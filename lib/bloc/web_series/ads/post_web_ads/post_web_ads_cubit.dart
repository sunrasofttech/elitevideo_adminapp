import 'dart:convert';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:elite_admin/utils/apiurls/api.dart';
import 'package:http/http.dart';
part 'post_web_ads_state.dart';

class PostWebAdsCubit extends Cubit<PostWebAdsState> {
  PostWebAdsCubit() : super(PostWebAdsInitial());

  postMovieAds(
    String movieId,
    String videoAdId,
  ) async {
    try {
      emit(PostWebAdsLoadingState());
      var response = await post(
        Uri.parse(AppUrls.seasonAdsUrl),
        body: jsonEncode({
          "season_episode_id": movieId,
          "video_ad_id": videoAdId,
          "show_type":"series",
        }),
        headers: headers,
      );

      final result = jsonDecode(response.body);
      log("message me $result");
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(
            PostWebAdsLoadedState(),
          );
        } else {
          emit(PostWebAdsErrorState(result["message"]));
        }
      } else {
        emit(PostWebAdsErrorState(result["message"]));
      }
    } catch (e, s) {
      print("catch error $e, $s");
      emit(
        PostWebAdsErrorState(
          "catch error $e, $s",
        ),
      );
    }
  }
}

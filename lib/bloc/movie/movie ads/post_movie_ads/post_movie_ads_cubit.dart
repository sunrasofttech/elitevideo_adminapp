import 'dart:convert';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:elite_admin/utils/apiurls/api.dart';
import 'package:http/http.dart';
part 'post_movie_ads_state.dart';

class PostMovieAdsCubit extends Cubit<PostMovieAdsState> {
  PostMovieAdsCubit() : super(PostMovieAdsInitial());

  postMovieAds(
    String movieId,
    String videoAdId,
  ) async {
    try {
      emit(PostMovieAdsLoadingState());
      var response = await post(
        Uri.parse(AppUrls.movieAdsUrl),
        body: jsonEncode({
          "movie_id": movieId,
          "video_ad_id": videoAdId,
        }),
        headers: headers,
      );

      final result = jsonDecode(response.body);
      log("message me $result");
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(
            PostMovieAdsLoadedState(),
          );
        } else {
          emit(PostMovieAdsErrorState(result["message"]));
        }
      } else {
        emit(PostMovieAdsErrorState(result["message"]));
      }
    } catch (e, s) {
      print("catch error $e, $s");
      emit(
        PostMovieAdsErrorState(
          "catch error $e, $s",
        ),
      );
    }
  }
}

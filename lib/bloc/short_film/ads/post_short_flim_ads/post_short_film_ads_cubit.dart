import 'dart:convert';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:elite_admin/utils/apiurls/api.dart';
import 'package:http/http.dart';
part 'post_short_film_ads_state.dart';

class PostShortFilmAdsCubit extends Cubit<PostShortFilmAdsState> {
  PostShortFilmAdsCubit() : super(PostShortFilmAdsInitial());

  postShortFilmAds(
    String movieId,
    String videoAdId,
  ) async {
    try {
      emit(PostShortFilmAdsLoadingState());
      var response = await post(
        Uri.parse(AppUrls.shortFilmsAds),
        body: jsonEncode({
          "shortfilm_id": movieId,
          "video_ad_id": videoAdId,
        }),
        headers: headers,
      );

      final result = jsonDecode(response.body);
      log("message me $result");
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(
            PostShortFilmAdsLaodedState(),
          );
        } else {
          emit(PostShortFilmAdsErrorState(result["message"]));
        }
      } else {
        emit(PostShortFilmAdsErrorState(result["message"]));
      }
    } catch (e, s) {
      print("catch error $e, $s");
      emit(
        PostShortFilmAdsErrorState(
          "catch error $e, $s",
        ),
      );
    }
  }
}

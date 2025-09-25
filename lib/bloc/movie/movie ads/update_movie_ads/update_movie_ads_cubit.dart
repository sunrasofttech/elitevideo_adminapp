import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:elite_admin/utils/apiurls/api.dart';

part 'update_movie_ads_state.dart';

class UpdateMovieAdsCubit extends Cubit<UpdateMovieAdsState> {
  UpdateMovieAdsCubit() : super(UpdateMovieAdsInitial());

  updateMovieAds({String? movieId, String? videoAdId, required String id}) async {
    try {
      emit(UpdateMovieAdsLoadingState());
      var response = await put(
        Uri.parse("${AppUrls.movieAdsUrl}/$id"),
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
            UpdateMovieAdsLaodedState(),
          );
        } else {
          emit(UpdateMovieAdsErrorState(result["message"]));
        }
      } else {
        emit(UpdateMovieAdsErrorState(result["message"]));
      }
    } catch (e, s) {
      print("catch error $e, $s");
      emit(
        UpdateMovieAdsErrorState(
          "catch error $e, $s",
        ),
      );
    }
  }
}

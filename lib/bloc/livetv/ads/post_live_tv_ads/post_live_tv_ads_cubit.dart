import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:elite_admin/utils/apiurls/api.dart';

part 'post_live_tv_ads_state.dart';

class PostLiveTvAdsCubit extends Cubit<PostLiveTvAdsState> {
  PostLiveTvAdsCubit() : super(PostLiveTvAdsInitial());

  postLiveTvAds(
    String movieId,
    String videoAdId,
  ) async {
    try {
      emit(PostLiveTvAdsLoadingState());
      var response = await post(
        Uri.parse(AppUrls.liveTvAdsUrl),
        body: jsonEncode({
          "livetv_channel_id": movieId,
          "video_ad_id": videoAdId,
        }),
        headers: headers,
      );

      final result = jsonDecode(response.body);
      log("PostLiveTvAdsCubit me $result $headers");
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(
            PostLiveTvAdsLoadedState(),
          );
        } else {
          emit(PostLiveTvAdsErrorState(result["message"]));
        }
      } else {
        emit(PostLiveTvAdsErrorState(result["message"]));
      }
    } catch (e, s) {
      print("catch error $e, $s");
      emit(
        PostLiveTvAdsErrorState(
          "catch error $e, $s",
        ),
      );
    }
  }
}

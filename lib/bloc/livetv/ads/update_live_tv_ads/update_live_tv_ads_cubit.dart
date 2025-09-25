import 'dart:convert';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:elite_admin/utils/apiurls/api.dart';
import 'package:http/http.dart';
part 'update_live_tv_ads_state.dart';

class UpdateLiveTvAdsCubit extends Cubit<UpdateLiveTvAdsState> {
  UpdateLiveTvAdsCubit() : super(UpdateLiveTvAdsInitial());

   updateMovieAds({String? movieId, String? videoAdId, required String id}) async {
    try {
      emit(UpdateLiveTvAdsLoadingState());
      var response = await put(
        Uri.parse("${AppUrls.liveTvAdsUrl}/$id"),
        body: jsonEncode({
          "livetv_channel_id": movieId,
          "video_ad_id": videoAdId,
        }),
        headers: headers,
      );

      final result = jsonDecode(response.body);
      log("message me $result");
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(
            UpdateLiveTvAdsLoadedState(),
          );
        } else {
          emit(UpdateLiveTvAdsErrorState(result["message"]));
        }
      } else {
        emit(UpdateLiveTvAdsErrorState(result["message"]));
      }
    } catch (e, s) {
      print("catch error $e, $s");
      emit(
        UpdateLiveTvAdsErrorState(
          "catch error $e, $s",
        ),
      );
    }
  }
}

import 'dart:convert';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:elite_admin/utils/apiurls/api.dart';
import 'package:http/http.dart';
part 'update_web_ads_state.dart';

class UpdateWebAdsCubit extends Cubit<UpdateWebAdsState> {
  UpdateWebAdsCubit() : super(UpdateWebAdsInitial());

  updateWebSeriesAds({String? movieId, String? videoAdId, required String id}) async {
    try {
      emit(UpdateWebAdsLoadingState());
      log("message - -- - - ${AppUrls.seasonAdsUrl}/$id ,,,");
      var response = await put(
        Uri.parse("${AppUrls.seasonAdsUrl}/$id"),
        body: jsonEncode({
          "season_episode_id": movieId,
          "video_ad_id": videoAdId,
           "show_type":"series",
        }..removeWhere((k, v) => v == null)),
        headers: headers,
      );

      final result = jsonDecode(response.body);
      log("message me $result");
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(
            UpdateWebAdsLoadedState(),
          );
        } else {
          emit(UpdateWebAdsErrorState(result["message"]));
        }
      } else {
        emit(UpdateWebAdsErrorState(result["message"]));
      }
    } catch (e, s) {
      print("catch error $e, $s");
      emit(
        UpdateWebAdsErrorState(
          "catch error $e, $s",
        ),
      );
    }
  }
}

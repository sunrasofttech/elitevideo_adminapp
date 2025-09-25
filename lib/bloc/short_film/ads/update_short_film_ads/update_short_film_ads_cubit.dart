import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:elite_admin/utils/apiurls/api.dart';

part 'update_short_film_ads_state.dart';

class UpdateShortFilmAdsCubit extends Cubit<UpdateShortFilmAdsState> {
  UpdateShortFilmAdsCubit() : super(UpdateShortFilmAdsInitial());

  updateShortFilmAds({String? movieId, String? videoAdId, required String id}) async {
    try {
      emit(UpdateShortFilmAdsLoadingState());
      var response = await put(
        Uri.parse("${AppUrls.shortFilmsAds}/$id"),
        body: jsonEncode({
          "shortfilm_id": movieId,
          "video_ad_id": videoAdId,
        }..removeWhere((k, v) => v == null)),
        headers: headers,
      );

      final result = jsonDecode(response.body);
      log("message me $result");
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(
            UpdateShortFilmAdsLoadedState(),
          );
        } else {
          emit(UpdateShortFilmAdsErrorState(result["message"]));
        }
      } else {
        emit(UpdateShortFilmAdsErrorState(result["message"]));
      }
    } catch (e, s) {
      print("catch error $e, $s");
      emit(
        UpdateShortFilmAdsErrorState(
          "catch error $e, $s",
        ),
      );
    }
  }
}

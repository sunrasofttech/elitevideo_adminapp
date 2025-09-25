import 'dart:convert';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:elite_admin/bloc/short_film/ads/get_short_film_ads/get_short_flim_ads_model.dart';
import 'package:elite_admin/utils/apiurls/api.dart';
import 'package:http/http.dart';
part 'get_short_flim_ads_state.dart';

class GetShortFlimAdsCubit extends Cubit<GetShortFlimAdsState> {
  GetShortFlimAdsCubit() : super(GetShortFlimAdsInitial());

  Future<void> getAllWebAds({int page = 1, int limit = 10}) async {
    try {
      emit(GetShortFlimAdsLoadingState());

      final uri = Uri.parse("${AppUrls.shortFilmsAds}/getall").replace(queryParameters: {
        'page': page.toString(),
        'limit': limit.toString(),
      });

      var response = await post(
        uri,
        headers: headers,
      );
      final result = jsonDecode(response.body);
      log("getAllWebAds =>  $result");
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(
            GetShortFlimAdsLoadedState(
              getShortFilmAdsModelFromJson(
                json.encode(result),
              ),
            ),
          );
        } else {
          emit(GetShortFlimAdsErrorState(result["message"]));
        }
      } else {
        emit(GetShortFlimAdsErrorState(result["message"]));
      }
    } catch (e, s) {
      print("catch error $e, $s");
      emit(
        GetShortFlimAdsErrorState(
          "catch error $e, $s",
        ),
      );
    }
  }
}

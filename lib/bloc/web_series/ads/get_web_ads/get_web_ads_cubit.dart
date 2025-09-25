import 'dart:convert';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:elite_admin/bloc/web_series/ads/get_web_ads/get_web_ads_model.dart';
import 'package:elite_admin/utils/apiurls/api.dart';
import 'package:http/http.dart';
part 'get_web_ads_state.dart';

class GetWebAdsCubit extends Cubit<GetWebAdsState> {
  GetWebAdsCubit() : super(GetWebAdsInitial());

  Future<void> getAllWebAds({int page = 1, int limit = 10}) async {
    try {
      emit(GetWebAdsLoadingState());

      final uri = Uri.parse("${AppUrls.seasonAdsUrl}/getall").replace(queryParameters: {
        'page': page.toString(),
        'limit': limit.toString(),
        'show_type': 'series',
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
            GetWebAdsLoadedState(
              getSeasonAdsModelFromJson(
                json.encode(result),
              ),
            ),
          );
        } else {
          emit(GetWebAdsErrorState(result["message"]));
        }
      } else {
        emit(GetWebAdsErrorState(result["message"]));
      }
    } catch (e, s) {
      print("catch error $e, $s");
      emit(
        GetWebAdsErrorState(
          "catch error $e, $s",
        ),
      );
    }
  }
}

import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:elite_admin/bloc/livetv/ads/get_all_live_tv_ads/get_all_live_tv_ads_model.dart';
import 'package:elite_admin/utils/apiurls/api.dart';
import 'package:http/http.dart';
part 'get_all_live_tv_ads_state.dart';

class GetAllLiveTvAdsCubit extends Cubit<GetAllLiveTvAdsState> {
  GetAllLiveTvAdsCubit() : super(GetAllLiveTvAdsInitial());

  Future<void> getAllLiveTvAds({int page = 1, int limit = 10}) async {
    try {
      emit(GetAllLiveTvAdsLoadingState());

      final uri = Uri.parse("${AppUrls.liveTvAdsUrl}/getall").replace(queryParameters: {
        'page': page.toString(),
        'limit': limit.toString(),
      });

      var response = await post(
        uri,
        headers: headers,
      );
      final result = jsonDecode(response.body);
      log("message => $result $uri");
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(
            GetAllLiveTvAdsLoadedState(
                  getLiveTvAdsModelFromJson(jsonEncode(result))
                ),
          );
        } else {
          emit(GetAllLiveTvAdsErrorState(result["message"]));
        }
      } else {
        emit(GetAllLiveTvAdsErrorState(result["message"]));
      }
    } catch (e, s) {
      print("catch error $e, $s");
      emit(
        GetAllLiveTvAdsErrorState(
          "catch error $e, $s",
        ),
      );
    }
  }
}

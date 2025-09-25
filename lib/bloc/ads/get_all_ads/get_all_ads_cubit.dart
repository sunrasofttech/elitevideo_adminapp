import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'package:elite_admin/bloc/ads/get_all_ads/get_all_ads_model.dart';
import 'package:elite_admin/utils/apiurls/api.dart';
part 'get_all_ads_state.dart';

class GetAllAdsCubit extends Cubit<GetAllAdsState> {
  GetAllAdsCubit() : super(GetAllAdsInitial());

  getAllAds() async {
    try {
      emit(GetAllAdsLoadingState());
      var response = await post(
        Uri.parse("${AppUrls.adsUrl}/get-all"),
        headers: headers,
      );
      final result = jsonDecode(response.body.toString());

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(
            GetAllAdsLaodedState(
              getAllAdsModelFromJson(
                json.encode(result),
              ),
            ),
          );
        } else {
          emit(GetAllAdsErrorState("${result['message']}"));
        }
      } else {
        emit(GetAllAdsErrorState("${result['message']}"));
      }
    } catch (e, s) {
      print("catch error $e, $s");
      emit(GetAllAdsErrorState("$e $s"));
    }
  }
}
